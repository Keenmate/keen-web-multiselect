import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Virtual scrolling actually virtualizes.
 *
 * attributes.spec proves enable-virtual-scroll / virtual-scroll-threshold /
 * option-height render kebab-cased — but not that the windowed-render code path
 * fires. This spec opens a 500-option picker and asserts:
 *   - upstream switches the options container into virtual mode (.ms__options--virtual)
 *   - the DOM holds far fewer than 500 .ms__option nodes (the window + buffer)
 *   - el.allOptions still has all 500 (data is complete; only the DOM is windowed)
 *   - a non-virtual control with the same data renders every row
 */

const PAGE = '/test/virtual-scroll';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

async function openDropdown(p: Locator): Promise<void> {
    await p.locator('.ms__input').click();
    await expect(p.locator('.ms__dropdown')).toBeVisible();
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('virtual picker windows the DOM but keeps all options in data', async ({ page }) => {
    const p = picker(page, 'virtual');
    await openDropdown(p);

    // Upstream flags the container as virtual.
    await expect(p.locator('.ms__options--virtual')).toBeAttached();

    // The data side is complete. Since upstream 2.0.0 the engine (`#picker`) is
    // private, so `allOptions` is gone; read the public inputs instead. The
    // wrapper feeds options via the `data-options` attribute (→ `optionsSource`);
    // a JS `el.options =` assignment would populate `options`. Count whichever
    // source is set.
    const total = await p.evaluate((el: any) => {
        if (Array.isArray(el.options) && el.options.length) return el.options.length;
        try { return JSON.parse(el.optionsSource || '[]').length; } catch { return 0; }
    });
    expect(total).toBe(500);

    // ...but only a window of rows is materialized. A 20rem viewport over
    // 40px rows is ~8 visible; even with a generous buffer this is well under
    // 500. Use a conservative ceiling so the test isn't brittle to buffer tuning.
    const rendered = await p.locator('.ms__option').count();
    expect(rendered).toBeGreaterThan(0);
    expect(rendered).toBeLessThan(100);
});

test('non-virtual control renders every row', async ({ page }) => {
    const p = picker(page, 'plain');
    await openDropdown(p);

    await expect(p.locator('.ms__options--virtual')).toHaveCount(0);
    await expect(p.locator('.ms__option')).toHaveCount(500);
});

test('scrolling the virtual list swaps in later rows', async ({ page }) => {
    const p = picker(page, 'virtual');
    await openDropdown(p);

    // Item 1 is in the initial window; a deep item is not yet materialized.
    await expect(p.locator('.ms__option[data-value="item-1"]')).toBeAttached();
    await expect(p.locator('.ms__option[data-value="item-400"]')).toHaveCount(0);

    // In virtual mode the scroll container is .ms__options--virtual itself
    // (overflow-y: auto); scroll it to the bottom.
    await p.locator('.ms__options--virtual').evaluate((el: HTMLElement) => {
        el.scrollTop = el.scrollHeight;
    });

    // A late row materializes; an early row recycles out.
    await expect(p.locator('.ms__option[data-value="item-500"]')).toBeAttached();
    await expect(p.locator('.ms__option[data-value="item-1"]')).toHaveCount(0);
});
