import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Declarative server-side search via search_event="..." + KeenWebMultiselectHook.
 *
 * What only the wrapper can break:
 *   - data-search-event="..." is rendered on the element
 *   - the hook installs el.searchCallback at mount time
 *   - typed queries reach the server's handle_event/3 as %{"id" => ..., "query" => ...}
 *   - the server's {:reply, %{results: [...]}, socket} return populates the dropdown
 *   - the rc04 AbortSignal contract: when a newer query supersedes an in-flight
 *     one, the stale LV reply is dropped before reaching the dropdown
 */

const PAGE = '/test/search-event';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

async function openDropdown(p: Locator): Promise<void> {
    await p.locator('.ms__input').click();
    await expect(p.locator('.ms__dropdown')).toBeVisible();
}

async function typeQuery(p: Locator, query: string): Promise<void> {
    const input = p.locator('.ms__input');
    await input.click();
    await input.fill('');
    await input.type(query, { delay: 5 });
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('data-search-event renders on the element', async ({ page }) => {
    const p = picker(page, 'search');
    await expect(p).toHaveAttribute('data-search-event', 'fruit_search');
});

test('typing a query reaches the server and populates the dropdown', async ({ page }) => {
    const p = picker(page, 'search');
    await openDropdown(p);
    await typeQuery(p, 'ap');

    // Wait for the dropdown to show server-returned options. The toy catalog
    // has Apple and Apricot matching "ap".
    await expect(p.locator('.ms__option[data-value="apple"]')).toBeVisible();
    await expect(p.locator('.ms__option[data-value="apricot"]')).toBeVisible();

    // The server saw the query — the wrapper's payload contract round-trips.
    await expect(page.locator('[data-testid="last-query"]')).toContainText('"ap"');
});

test('a fresh query replaces the previous result set', async ({ page }) => {
    const p = picker(page, 'search');
    await openDropdown(p);

    await typeQuery(p, 'ap');
    await expect(p.locator('.ms__option[data-value="apple"]')).toBeVisible();

    await typeQuery(p, 'bl');
    await expect(p.locator('.ms__option[data-value="blackberry"]')).toBeVisible();
    await expect(p.locator('.ms__option[data-value="blueberry"]')).toBeVisible();
    // "apple" must not still be in the dropdown after a fresh query.
    await expect(p.locator('.ms__option[data-value="apple"]')).toHaveCount(0);
});

test('AbortSignal: a superseded slow reply does not overwrite the live results', async ({ page }) => {
    const p = picker(page, 'search');

    // Tell the server to delay the next reply by 500ms.
    await page.locator('#slow-next-on').click();
    await expect(page.locator('[data-testid="slow-next"]')).toHaveText('true');

    await openDropdown(p);

    // Fire the slow query — its reply will be queued for 500ms.
    await typeQuery(p, 'ap');

    // Immediately supersede it with a different query. The hook's
    // AbortSignal listener should mark the first reply as aborted, so when it
    // eventually arrives it must NOT show "apple"/"apricot" in the dropdown.
    await typeQuery(p, 'bl');

    // Wait for the fast reply (bl* — no server delay this round).
    await expect(p.locator('.ms__option[data-value="blueberry"]')).toBeVisible();

    // Now give the slow reply enough time to arrive. If the hook ignored the
    // AbortSignal contract, the stale "ap" results would race in and replace
    // the "bl" results.
    await page.waitForTimeout(700);

    await expect(p.locator('.ms__option[data-value="blueberry"]')).toBeVisible();
    await expect(p.locator('.ms__option[data-value="apple"]')).toHaveCount(0);
    await expect(p.locator('.ms__option[data-value="apricot"]')).toHaveCount(0);
});
