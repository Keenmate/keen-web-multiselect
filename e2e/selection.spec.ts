import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Wrapper smoke test: confirms the rendered <web-multiselect> behaves like
 * upstream when driven through HEEx. We're not re-testing upstream — these
 * cases prove that `value={[...]}` flows into `initial-values`, that
 * `multiple={false}` round-trips as the string "false", and that explicit
 * snake_case attrs reach the rendered element.
 */

const PAGE = '/test/selection';

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

async function getValue(p: Locator): Promise<string | string[] | null> {
    return p.evaluate((el: any) => el.getValue());
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('value={["banana"]} populates initial-values', async ({ page }) => {
    const p = picker(page, 'initial');
    expect(await getValue(p)).toEqual(['banana']);
});

test('multiple={false} renders as the string "false" on the element', async ({ page }) => {
    const p = picker(page, 'single');
    expect(await p.getAttribute('multiple')).toBe('false');

    // And single-select semantics actually work end-to-end.
    await openDropdown(p);
    await optionByValue(p, 'apple').click();
    expect(await getValue(p)).toBe('apple');
});

test('close_on_select={true} maps to close-on-select="true"', async ({ page }) => {
    const p = picker(page, 'close-on-select');
    expect(await p.getAttribute('close-on-select')).toBe('true');

    await openDropdown(p);
    await optionByValue(p, 'apple').click();
    await expect(p.locator('.ms__dropdown')).not.toBeVisible();
});

test('multi-select round-trips two clicks into a two-value array', async ({ page }) => {
    const p = picker(page, 'multi');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();
    await optionByValue(p, 'cherry').click();

    expect(await getValue(p)).toEqual(['apple', 'cherry']);
});

/**
 * Wrapper-only morph guards: the component renders phx-update="ignore" on
 * every element that has an :id (so morphdom leaves upstream's shadow-DOM
 * children alone), and pre-emits data-placeholder-ready="" so LV's mergeAttrs
 * doesn't strip it on the first patch — without that, the placeholder flashes
 * for one frame on every re-render. Spot-check both attributes are present.
 */
test('phx-update="ignore" is auto-emitted on every multiselect with an id', async ({ page }) => {
    for (const id of ['multi', 'single', 'initial', 'close-on-select']) {
        await expect(picker(page, id)).toHaveAttribute('phx-update', 'ignore');
    }
});

test('data-placeholder-ready="" is pre-emitted on first render so placeholder does not flash', async ({ page }) => {
    for (const id of ['multi', 'single', 'initial', 'close-on-select']) {
        // toHaveAttribute with an empty string asserts the attribute exists
        // and has an empty value — exactly what the template emits.
        await expect(picker(page, id)).toHaveAttribute('data-placeholder-ready', '');
    }
});
