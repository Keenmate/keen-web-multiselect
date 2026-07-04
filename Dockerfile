# syntax=docker/dockerfile:1
#
# Builds the keen_web_multiselect examples app (test_app) as a self-contained
# Elixir release and runs it for https://keen-web-multiselect.keenmate.dev.
#
# IMPORTANT: the build context must be the PARENT repo root, not test_app/.
# test_app pulls the wrapper via `path: ".."` and shares the parent's mix.lock
# and deps/ directory, so both projects have to be visible to the build.
#
#   podman build -t keen-web-multiselect-examples .
#   podman run --rm -p 4060:4060 \
#     -e SECRET_KEY_BASE="$(openssl rand -base64 48)" \
#     keen-web-multiselect-examples
#
# SECRET_KEY_BASE is required at runtime (never baked into the image); PHX_HOST
# and PORT default below and can be overridden with -e. Elixir 1.18 / OTP 27 to
# match the repo's toolchain.

########################################
# Build stage — compile + assemble the release
########################################
FROM elixir:1.18.4-otp-27 AS build

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

WORKDIR /src

# --- Parent library (the `path: ".."` dependency) ---
# Only the files the release needs; deps/ and _build/ are rebuilt below.
COPY mix.exs mix.lock .formatter.exs ./
COPY lib ./lib
COPY priv ./priv

# --- The examples app itself ---
COPY test_app ./test_app

WORKDIR /src/test_app

# Fetch + compile prod dependencies. test_app's `deps_path: "../deps"` and
# `lockfile: "../mix.lock"` mean these resolve against /src (the parent).
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy runtime config explicitly so a bare `mix release` picks it up, then
# compile the app (also compiles the path dep) and assemble the release.
RUN mix compile
RUN mix release --overwrite

########################################
# Runtime stage — minimal image, just the release + its ERTS
########################################
FROM debian:bookworm-slim AS runtime

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
       libstdc++6 openssl libncurses6 locales ca-certificates \
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /app

# Run unprivileged — it's a public demo with no need for root.
RUN useradd --create-home --uid 1000 app
USER app

# The assembled release bundles the ERTS, the app, and every dep (including the
# wrapper's priv/static assets served by Plug.Static), so no Elixir/mix needed.
COPY --from=build --chown=app:app /src/test_app/_build/prod/rel/test_app ./

# Defaults; override at `podman run` time as needed. TLS terminates upstream.
ENV PHX_HOST=keen-web-multiselect.keenmate.dev \
    PORT=4060

EXPOSE 4060

CMD ["bin/test_app", "start"]
