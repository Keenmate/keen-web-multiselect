import { test, expect } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * snake_case → kebab-case attribute mapping. The wrapper's
 * OptionHelpers.to_html_attributes/1 is the only thing between HEEx and the
 * rendered element, so this spec spot-checks one representative attribute
 * from each upstream prop family (search, badges, virtual scroll, members,
 * format) plus the boolean-as-explicit-string behavior.
 */

const PAGE = '/test/attributes';

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('every snake_case attr is rendered kebab-cased', async ({ page }) => {
    const el = page.locator('#kebab-check');

    await expect(el).toHaveAttribute('search-placeholder', 'Search fruits...');
    await expect(el).toHaveAttribute('badges-display-mode', 'badges');
    await expect(el).toHaveAttribute('badges-threshold', '3');
    await expect(el).toHaveAttribute('badges-max-visible', '2');
    await expect(el).toHaveAttribute('badges-position', 'top');
    await expect(el).toHaveAttribute('enable-search', 'true');
    await expect(el).toHaveAttribute('search-mode', 'filter');
    await expect(el).toHaveAttribute('min-search-length', '2');
    await expect(el).toHaveAttribute('enable-virtual-scroll', 'true');
    await expect(el).toHaveAttribute('virtual-scroll-threshold', '100');
    await expect(el).toHaveAttribute('option-height', '32');
    await expect(el).toHaveAttribute('value-format', 'json');
    await expect(el).toHaveAttribute('value-member', 'value');
    await expect(el).toHaveAttribute('display-value-member', 'label');
});

test('the four audit-added typed attrs render kebab-cased', async ({ page }) => {
    // Regression guard: these landed as first-class attr/3 in the 2026-06-25
    // audit (previously only reachable via :rest). A typo or enum-default
    // silent-fallback in components.ex must fail CI here.
    const el = page.locator('#kebab-check');

    await expect(el).toHaveAttribute('checkbox-align', 'top');
    await expect(el).toHaveAttribute('dropdown-max-width', '40rem');
    await expect(el).toHaveAttribute('remove-button-tooltip-text', 'Drop {0}');
    await expect(el).toHaveAttribute('badge-height', '40');
    await expect(el).toHaveAttribute('show-debug-info', 'true');
});

test('show-debug-info="true" actually renders the upstream debug panel', async ({ page }) => {
    // show-debug-info is an out-of-table upstream attr but reactive — it toggles
    // the .ms__debug-info panel. Proves the attr reaches a live code path, not
    // just that it lands on the element.
    const el = page.locator('#kebab-check');
    await expect(el.locator('.ms__debug-info')).toBeAttached();
});

test('booleans render as explicit "true" / "false" strings (not bare presence)', async ({ page }) => {
    await expect(page.locator('#bool-true')).toHaveAttribute('multiple', 'true');
    await expect(page.locator('#bool-false')).toHaveAttribute('multiple', 'false');
});
