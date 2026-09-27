import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Server→client imperative channel: push_command/3 → "web_multiselect:command",
 * and the "web_multiselect:ready" event the hook forwards once the picker's first
 * build completes.
 *
 * What only the wrapper can break:
 *   - the hook forwards a `ready` DOM event (and replays it from el.isReady when
 *     the build beat the hook's mounted()) — the fixture's ready handler uses it
 *     to auto-open, so if the dropdown is open on arrival, the round-trip worked
 *   - the hook listens for "web_multiselect:command" and maps open/close/
 *     scroll_to_* to the element's imperative methods
 *   - payload.id filters (single widget here, but the mapping must reach it)
 */

const PAGE = '/test/command';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

function dropdown(p: Locator): Locator {
    return p.locator('.ms__dropdown');
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('ready event auto-opens the dropdown on page entry (no user interaction)', async ({ page }) => {
    const auto = picker(page, 'auto');
    // The fixture replies to web_multiselect:ready with open: true — so the
    // dropdown becomes visible with zero clicks. This is the "open on entry"
    // recipe end-to-end: element upgrades → ready fires → hook forwards it →
    // server replies with push_command → dropdown opens.
    await expect(dropdown(auto)).toBeVisible();
});

test('push_command close: true closes the auto-opened dropdown', async ({ page }) => {
    const auto = picker(page, 'auto');
    await expect(dropdown(auto)).toBeVisible();

    await page.locator('#cmd-close').click();
    await expect(dropdown(auto)).not.toBeVisible();
});

test('push_command open + scroll_to_value reveals the target option', async ({ page }) => {
    const auto = picker(page, 'auto');

    // Close first so we're driving open from a known-closed state.
    await page.locator('#cmd-close').click();
    await expect(dropdown(auto)).not.toBeVisible();

    await page.locator('#cmd-open-scroll-redis').click();
    await expect(dropdown(auto)).toBeVisible();

    // The scrolled-to option is in the rendered viewport. (open + scroll travel
    // in one push_command; the element defers the scroll one frame internally.)
    await expect(auto.locator('.ms__option[data-value="redis"]')).toBeInViewport();
});
