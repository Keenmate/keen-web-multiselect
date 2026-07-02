import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Declarative <option>/<optgroup> children via :inner_block.
 *
 * What only the wrapper can break:
 *   - the :inner_block slot reaches the rendered element as light-DOM children
 *   - upstream's declarative path is allowed to run (no data-options encoding)
 *   - the wrapper does NOT inject the auto-defaulted value-member/display-value-member
 *     (those are only for the data-options JSON path) — upstream's own value/label
 *     defaults take over for declarative children
 */

const PAGE = '/test/declarative';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

async function openDropdown(p: Locator): Promise<void> {
    await p.locator('.ms__input').click();
    await expect(p.locator('.ms__dropdown')).toBeVisible();
}

async function getValue(p: Locator): Promise<string | string[] | null> {
    return p.evaluate((el: any) => el.getValue());
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('bare <option> children populate the dropdown', async ({ page }) => {
    const p = picker(page, 'bare');
    await openDropdown(p);

    await expect(p.locator('.ms__option[data-value="apple"]')).toBeVisible();
    await expect(p.locator('.ms__option[data-value="banana"]')).toBeVisible();
    await expect(p.locator('.ms__option[data-value="cherry"]')).toBeVisible();
});

test('wrapper does not emit data-options for declarative children', async ({ page }) => {
    // If the wrapper accidentally encoded an empty options list to data-options="[]",
    // upstream would prefer the JSON path and the declarative children would be ignored.
    const p = picker(page, 'bare');
    expect(await p.getAttribute('data-options')).toBeNull();
});

test('wrapper emits the canonical-shape member defaults on the declarative path too', async ({ page }) => {
    // The wrapper unconditionally emits `value-member="value"`,
    // `display-value-member="label"`, etc. so upstream uses the same shape
    // for JSON-options, async-search, and declarative <option> paths.
    // Upstream's declarative parser produces objects shaped exactly like the
    // wrapper's documented canonical shape (`{value, label, icon?, ...}`),
    // so the explicit member attrs are no-ops here, not regressions.
    const p = picker(page, 'bare');
    await expect(p).toHaveAttribute('value-member', 'value');
    await expect(p).toHaveAttribute('display-value-member', 'label');
    await expect(p).toHaveAttribute('icon-member', 'icon');
    await expect(p).toHaveAttribute('subtitle-member', 'subtitle');
});

test('clicking a declarative option records its value', async ({ page }) => {
    const p = picker(page, 'bare');
    await openDropdown(p);
    await p.locator('.ms__option[data-value="banana"]').click();
    expect(await getValue(p)).toEqual(['banana']);
});

test('<optgroup> + selected/disabled attributes round-trip', async ({ page }) => {
    const p = picker(page, 'grouped');

    // The `selected` attribute on <option value="orange"> pre-selects it.
    expect(await getValue(p)).toEqual(['orange']);

    await openDropdown(p);

    // The group labels render as group headers in the dropdown.
    await expect(p.locator('.ms__group-label', { hasText: 'Citrus' })).toBeVisible();
    await expect(p.locator('.ms__group-label', { hasText: 'Berries' })).toBeVisible();

    // The disabled <option> renders with the disabled class.
    await expect(p.locator('.ms__option[data-value="raspberry"]')).toHaveClass(/ms__option--disabled/);
});

test('declarative data-icon / data-subtitle render in the option rows', async ({ page }) => {
    // The wrapper passes these through as light-DOM attributes; upstream's
    // parseDeclarativeOptions maps data-icon → option.icon and
    // data-subtitle → option.subtitle, then renders .ms__option-icon /
    // .ms__option-subtitle. Asserting the rendered DOM proves the whole chain.
    const p = picker(page, 'rich');
    await openDropdown(p);

    const apple = p.locator('.ms__option[data-value="apple"]');
    await expect(apple.locator('.ms__option-icon')).toHaveText('🍎');
    await expect(apple.locator('.ms__option-subtitle')).toHaveText('Crisp and red');

    const banana = p.locator('.ms__option[data-value="banana"]');
    await expect(banana.locator('.ms__option-icon')).toHaveText('🍌');
    await expect(banana.locator('.ms__option-subtitle')).toHaveText('Rich in potassium');
});
