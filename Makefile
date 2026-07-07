.PHONY: help setup deps build docs test test-watch format format-check compile \
        clean clean-build current-version last-published hex-build hex-build-inspect \
        publish-dry publish-rc publish \
        test-e2e test-e2e-ui test-e2e-headed test-e2e-install \
        dev \
        container-build container-run container-shell container-push

# ---------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------

PKG       := keen_web_multiselect
MIX_EXS   := mix.exs
# Extract the current version from `@version "X.Y.Z"` in mix.exs.
VERSION   := $(shell grep -E '^\s*@version\s+"' $(MIX_EXS) | head -1 | sed -E 's/.*"([^"]+)".*/\1/')

# ---------------------------------------------------------------------------
# Default
# ---------------------------------------------------------------------------

help: ## Show this help message
	@echo "keen_web_multiselect - current version: $(VERSION)"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Development
# ---------------------------------------------------------------------------

setup: deps ## Install dependencies and prepare the project
	@echo "Setup complete."

deps: ## Fetch Hex dependencies
	mix deps.get

compile: ## Compile sources with --warnings-as-errors
	mix compile --warnings-as-errors

build: compile docs ## Compile + generate docs (the publish-time build)

docs: ## Generate hexdocs into ./doc via ex_doc
	mix docs

test: ## Run the ExUnit suite
	mix test

test-watch: ## Re-run tests on file change (requires mix test.watch installed)
	mix test.watch

# ---------------------------------------------------------------------------
# End-to-end tests — Playwright against the test_app/ Phoenix host
# ---------------------------------------------------------------------------

test-e2e-install: ## One-time: download the Chromium browser binary for Playwright
	npm install
	npx playwright install chromium

test-e2e: ## Run the Playwright suite headless (auto-boots test_app)
	npx playwright test

test-e2e-ui: ## Open the Playwright Test UI for debugging
	npx playwright test --ui

test-e2e-headed: ## Watch the browser drive the suite
	npx playwright test --headed

dev: ## Start the test_app demo site on http://localhost:4060 (demo gallery at /)
	@echo "Starting demo site on http://localhost:4060 ..."
	@echo ""
	@echo "Demo gallery:     http://localhost:4060/"
	@echo "  Classic         http://localhost:4060/examples/classic"
	@echo "  New API         http://localhost:4060/examples/new-api"
	@echo "  Performance     http://localhost:4060/examples/performance"
	@echo "  Templating      http://localhost:4060/examples/templating"
	@echo "  Action buttons  http://localhost:4060/examples/action-buttons"
	@echo "  Sizes           http://localhost:4060/examples/sizes"
	@echo "  Base variables  http://localhost:4060/examples/base-variables"
	@echo "  Theming         http://localhost:4060/examples/theming"
	@echo "  Logging         http://localhost:4060/examples/logging"
	@echo "  Positioning     http://localhost:4060/examples/positioning"
	@echo "  Tree            http://localhost:4060/examples/tree"
	@echo "  Search index    http://localhost:4060/examples/search-index"
	@echo ""
	@echo "E2E fixtures:"
	@echo "  Selection       http://localhost:4060/test/selection"
	@echo "  Form            http://localhost:4060/test/form"
	@echo "  Events          http://localhost:4060/test/events"
	@echo "  Attributes      http://localhost:4060/test/attributes"
	@echo ""
	cd test_app && mix deps.get && mix phx.server

format: ## Format all sources
	mix format

format-check: ## Verify formatting without writing
	mix format --check-formatted

# ---------------------------------------------------------------------------
# Container image — the examples app (test_app), for deploying to
# keen-web-multiselect.keenmate.dev.
#
# The build context is the repo ROOT (not test_app/) because the examples app
# pulls the wrapper via `path: ".."` and shares ../deps + ../mix.lock.
#
# CONTAINER defaults to podman; override for docker:
#   make container-run CONTAINER=docker
# SECRET_KEY_BASE is required at runtime and generated fresh per run (never
# baked into the image). PORT/PHX_HOST default inside the image.
# ---------------------------------------------------------------------------

CONTAINER      ?= podman
IMAGE          ?= keen-web-multiselect-examples
HOST_PORT      ?= 4060
# Registry target for `container-push`, e.g. registry.keenmate.dev/keen-web-multiselect-examples:latest
IMAGE_REMOTE   ?=

container-build: ## Build the examples app container image (context = repo root)
	$(CONTAINER) build -t $(IMAGE) .

container-run: container-build ## Build then run the image on http://localhost:$(HOST_PORT)
	@echo "Serving examples on http://localhost:$(HOST_PORT)/ (Ctrl+C to stop) ..."
	$(CONTAINER) run --rm -p $(HOST_PORT):4060 \
		-e SECRET_KEY_BASE="$$(openssl rand -base64 48)" \
		$(IMAGE)

container-shell: container-build ## Open a shell in the built image (debugging)
	$(CONTAINER) run --rm -it --entrypoint /bin/sh $(IMAGE)

container-push: ## Tag + push the image to IMAGE_REMOTE (set IMAGE_REMOTE=registry/host:tag)
	@test -n "$(IMAGE_REMOTE)" || { echo "ERROR: set IMAGE_REMOTE=registry.example.com/name:tag"; exit 1; }
	$(CONTAINER) tag $(IMAGE) $(IMAGE_REMOTE)
	$(CONTAINER) push $(IMAGE_REMOTE)

# ---------------------------------------------------------------------------
# State inspection — the "what version are we at vs registry?" answers
# ---------------------------------------------------------------------------

current-version: ## Print the @version from mix.exs
	@echo "$(VERSION)"

last-published: ## Print the latest version of keen_web_multiselect published on Hex
	@echo "Querying Hex for $(PKG) ..."
	@mix hex.info $(PKG) 2>/dev/null \
		| grep -iE '^(Releases|Config):' \
		|| echo "Package not found on Hex (first publish?)."

# ---------------------------------------------------------------------------
# Cleaning
# ---------------------------------------------------------------------------

clean: ## Remove build artifacts and the Hex tarball
	mix clean
	rm -f $(PKG)-*.tar
	rm -rf doc

clean-build: ## Remove _build entirely (force full rebuild on next compile)
	rm -rf _build

# ---------------------------------------------------------------------------
# Hex tarball — the npm-pack equivalent
# ---------------------------------------------------------------------------

hex-build: ## Build the Hex tarball without publishing
	mix hex.build

hex-build-inspect: hex-build ## Build the tarball and print its file list
	@echo ""
	@echo "Contents of $(PKG)-$(VERSION).tar:"
	@echo "---"
	@tar -tzf $(PKG)-$(VERSION).tar | sort

# ---------------------------------------------------------------------------
# Publish — the rc/release split is enforced by the @version shape
#
# Hex has no dist-tags. The rc/release distinction lives in the version
# string (`0.2.0-rc.0` vs `0.2.0`) and is enforced here:
#   - `make publish-rc`      refuses unless @version matches `X.Y.Z-rc.N`
#   - `make publish`         refuses if @version is an rc
# Consumers' `{:dep, "~> 0.1"}` constraints skip pre-releases by default,
# so the SemVer semantics handle what npm's `--tag rc` does.
# ---------------------------------------------------------------------------

publish-dry: build hex-build ## Dry-run: build, hex.build, hex.publish --dry-run
	@echo "Running mix hex.publish --dry-run ..."
	mix hex.publish --dry-run
	@echo "Dry-run complete - review the output above."

publish-rc: ## Publish an rc version (requires @version to match X.Y.Z-rc.N)
	@case "$(VERSION)" in \
		*-rc.*) \
			echo "Current @version is $(VERSION) - proceeding with rc publish." ;; \
		*) \
			echo "ERROR: @version is $(VERSION), which is not an rc."; \
			echo "       Use 'make publish' for a stable release."; \
			exit 1 ;; \
	esac
	@echo "WARNING: This will publish $(PKG) $(VERSION) to Hex."
	@echo "         RC versions are published as regular releases - consumers must"
	@echo "         opt in explicitly because '~> X.Y' constraints skip pre-releases."
	@echo "         Press Ctrl+C to cancel, or Enter to continue ..."
	@read _
	$(MAKE) build
	mix hex.publish
	@echo "Published $(PKG) $(VERSION) (rc)."

publish: ## Publish a stable release (refuses if @version is an rc)
	@case "$(VERSION)" in \
		*-rc.*) \
			echo "ERROR: @version is $(VERSION), which is an rc."; \
			echo "       Use 'make publish-rc' for pre-releases, or bump @version"; \
			echo "       to a stable (e.g. drop the -rc.N suffix) first."; \
			exit 1 ;; \
	esac
	@echo "WARNING: This will publish $(PKG) $(VERSION) to Hex as a STABLE release."
	@echo "         '~> X.Y' constraints will pick this up on next deps.get."
	@echo "         Press Ctrl+C to cancel, or Enter to continue ..."
	@read _
	$(MAKE) build
	mix hex.publish
	@echo "Published $(PKG) $(VERSION) (stable)."
