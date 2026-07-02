import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright config for the keen_web_multiselect Phoenix wrapper.
 *
 * Specs live in e2e/ and target fixture LiveViews mounted by the host app
 * under test_app/ (served by `mix phx.server` on port 4060). The fixtures
 * are intentionally separate from any future demo so they stay minimal and
 * focused on the wrapper-specific surface — FormField binding, hook event
 * forwarding, snake→kebab attribute mapping.
 *
 * Commands:
 *   npm run test:e2e:install   # one-time: download chromium browser binary
 *   npm run test:e2e           # headless run
 *   npm run test:e2e:ui        # Playwright Test UI (debugging)
 *   npm run test:e2e:headed    # watch the browser do its thing
 */
export default defineConfig({
    testDir: './e2e',
    timeout: 30_000,
    expect: { timeout: 5_000 },

    fullyParallel: true,
    forbidOnly: !!process.env.CI,
    retries: process.env.CI ? 2 : 0,
    workers: process.env.CI ? 1 : undefined,

    reporter: process.env.CI ? 'github' : 'list',

    use: {
        baseURL: 'http://localhost:4060',
        trace: 'on-first-retry',
        screenshot: 'only-on-failure',
        video: 'retain-on-failure'
    },

    projects: [
        {
            name: 'chromium',
            use: {
                ...devices['Desktop Chrome'],
                viewport: { width: 1440, height: 1024 }
            }
        }
    ],

    webServer: {
        command: 'mix phx.server',
        cwd: 'test_app',
        url: 'http://localhost:4060',
        reuseExistingServer: !process.env.CI,
        timeout: 60_000,
        stdout: 'ignore',
        stderr: 'pipe'
    }
});
