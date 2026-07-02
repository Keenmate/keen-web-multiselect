import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * LV hook event forwarding.
 *
 * What only the wrapper can break:
 *   - hook="KeenWebMultiselectHook" reaches the rendered element as phx-hook
 *   - the hook forwards `select` / `deselect` / `change` CustomEvents to the
 *     server as web_multiselect:* events with {id, value, values} payloads
 */

const PAGE = '/test/events';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

async function openDropdown(p: Locator): Promise<void> {
    await p.locator('.ms__input').click();
    await expect(p.locator('.ms__dropdown')).toBeVisible();
}

function optionByValue(p: Locator, value: string): Locator {
    return p.locator(`.ms__option[data-value="${value}"]`);
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('hook="KeenWebMultiselectHook" renders as phx-hook', async ({ page }) => {
    const el = picker(page, 'picker');
    await expect(el).toHaveAttribute('phx-hook', 'KeenWebMultiselectHook');
});

test('selecting an option forwards web_multiselect:select with {id, value, values}', async ({ page }) => {
    const p = picker(page, 'picker');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();

    const log = page.locator('[data-testid="captured-events"]');
    await expect(log).toContainText('web_multiselect:select');
    await expect(log).toContainText('web_multiselect:change');
    await expect(log).toContainText('"id" => "picker"');
    await expect(log).toContainText('apple');
});

test('deselecting an option forwards web_multiselect:deselect', async ({ page }) => {
    const p = picker(page, 'picker');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();
    await optionByValue(p, 'apple').click();

    const log = page.locator('[data-testid="captured-events"]');
    await expect(log).toContainText('web_multiselect:deselect');
});

test('a single select fires select + change exactly once each (no double-fire)', async ({ page }) => {
    const p = picker(page, 'picker');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();

    const log = page.locator('[data-testid="captured-events"]');
    // Wait for both events to have landed before counting.
    await expect(log).toContainText('web_multiselect:change');

    const counts = await log.evaluate((el) => {
        const text = el.textContent || '';
        const count = (needle: string) => text.split(needle).length - 1;
        return {
            select: count('web_multiselect:select'),
            change: count('web_multiselect:change'),
            deselect: count('web_multiselect:deselect'),
        };
    });

    expect(counts.select).toBe(1);
    expect(counts.change).toBe(1);
    expect(counts.deselect).toBe(0);
});

test('select fires before change for one click (newest-first log)', async ({ page }) => {
    const p = picker(page, 'picker');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();

    const log = page.locator('[data-testid="captured-events"]');
    await expect(log).toContainText('web_multiselect:change');

    // The log prepends newest-first, so the later-firing `change` sits above
    // the earlier `select`. A regression that reorders or drops one fails here.
    const order = await log.evaluate((el) => {
        const text = el.textContent || '';
        return {
            change: text.indexOf('web_multiselect:change'),
            select: text.indexOf('web_multiselect:select'),
        };
    });

    expect(order.change).toBeGreaterThanOrEqual(0);
    expect(order.select).toBeGreaterThan(order.change);
});
