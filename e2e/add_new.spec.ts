import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Add-new (tag creation).
 *
 * allow_add_new lands as the bare allow-add-new="true" attribute; the consumer assigns
 * el.addNewCallback in a <script>. Typing an unknown term into the open input
 * and pressing Enter runs handleAddNew → callback → push into allOptions →
 * select. This is the only path that exercises the wrapper's allow_add_new attr
 * end-to-end (the callback itself is JS-only by design).
 */

const PAGE = '/test/add-new';

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

test('allow_add_new renders as data-allow-add-new="true"', async ({ page }) => {
    await expect(picker(page, 'tagger')).toHaveAttribute('allow-add-new', 'true');
});

test('typing an unknown term + Enter creates and selects it', async ({ page }) => {
    const p = picker(page, 'tagger');
    await openDropdown(p);

    const input = p.locator('.ms__input');
    await input.fill('Mango');
    // No existing option matches, so nothing is focused — Enter triggers add-new.
    await input.press('Enter');

    // The new value is selected...
    await expect.poll(() => getValue(p)).toEqual(['mango']);

    // ...and renders as a badge with the original-cased label.
    await expect(p.locator('.ms__badge .ms__badge-text', { hasText: 'Mango' })).toBeVisible();

    // The input is cleared after a successful add.
    await expect(input).toHaveValue('');
});

test('the created option appears in allOptions for re-selection', async ({ page }) => {
    const p = picker(page, 'tagger');
    await openDropdown(p);

    const input = p.locator('.ms__input');
    await input.fill('Kiwi');
    await input.press('Enter');

    await expect.poll(() => getValue(p)).toEqual(['kiwi']);

    const values = await p.evaluate((el: any) => el.picker.allOptions.map((o: any) => o.value));
    expect(values).toContain('kiwi');
});
