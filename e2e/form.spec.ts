import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Form integration via Phoenix.HTML.FormField.
 *
 * What only the wrapper can break:
 *   - the FormField's id/name make it onto the rendered element
 *   - the FormField's value flows into `initial-values` (JSON-encoded list)
 *   - the upstream hidden input is named per the field so that
 *     phx-change / phx-submit deliver params[form_name][field_name]
 */

const PAGE = '/test/form';

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

test('field={@form[:fruits]} fills id and name', async ({ page }) => {
    // The page also hosts a #prefilled picker, so scope to the field-bound one.
    const el = picker(page, 'basket_fruits');
    await expect(el).toHaveAttribute('id', 'basket_fruits');
    await expect(el).toHaveAttribute('name', 'basket[fruits]');
});

test('selecting options bubbles to phx-change as params[basket][fruits]', async ({ page }) => {
    const p = picker(page, 'basket_fruits');
    await openDropdown(p);
    await optionByValue(p, 'apple').click();
    await optionByValue(p, 'banana').click();

    const params = page.locator('[data-testid="form-params"]');
    // The hidden input writes JSON-encoded array by default; phx-change
    // ships %{"basket" => %{"fruits" => "[\"apple\",\"banana\"]"}}.
    await expect(params).toContainText('basket');
    await expect(params).toContainText('fruits');
    await expect(params).toContainText('apple');
    await expect(params).toContainText('banana');
});

test('phx-submit captures the same shape', async ({ page }) => {
    const p = picker(page, 'basket_fruits');
    await openDropdown(p);
    await optionByValue(p, 'cherry').click();

    // Dropdown stays open after a multi-select pick and covers the submit
    // button. Close it with Escape before driving the submit.
    await page.keyboard.press('Escape');
    await page.locator('#submit-btn').click();

    const params = page.locator('[data-testid="form-params"]');
    await expect(params).toContainText('submitted');
    await expect(params).toContainText('cherry');
});

test('FormField with a pre-set value renders the selection as badges post-mount', async ({ page }) => {
    // The earlier form.spec test only proves the value is on the element
    // (in initial-values). This proves upstream actually consumed it: the
    // badges appear in the closed-state input, and `el.getValue()` returns
    // the pre-set list. Catches regressions where initial-values is shaped
    // wrong (single string vs JSON array, etc.) and upstream silently drops it.
    const p = picker(page, 'prefilled');

    // getValue() reflects the upstream-consumed selection.
    await expect.poll(() => p.evaluate((el: any) => el.getValue())).toEqual(['banana', 'cherry']);

    // Badges show in the closed state — search inside the picker so the
    // text match isn't ambiguous with dropdown rows that might be visible.
    await expect(p.locator('.ms__badge', { hasText: 'Banana' })).toBeVisible();
    await expect(p.locator('.ms__badge', { hasText: 'Cherry' })).toBeVisible();
});
