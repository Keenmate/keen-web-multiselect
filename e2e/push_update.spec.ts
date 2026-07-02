import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Server→client push_event channel for option/value mutation.
 *
 * What only the wrapper can break:
 *   - the hook listens for "web_multiselect:update"
 *   - payload.id filters: an update for id="child" must not touch #sibling
 *   - payload.options replaces the option list (sets el.options)
 *   - payload.value replaces the selection (calls el.setSelected)
 *   - both fields can travel in one push_event
 *
 * This is the canonical workaround for the wrapper's phx-update="ignore" —
 * morphdom can't morph attribute changes on ignored elements, so options/value
 * mutations from the LV process must go through this channel.
 */

const PAGE = '/test/push-update';

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

async function getOptionValues(p: Locator): Promise<string[]> {
    // The option array lives on the internal picker, not the custom element
    // (the element exposes `picker`, `getValue()`, `getSelected()`, etc.).
    return p.evaluate((el: any) =>
        (el.picker?.allOptions || []).map((o: any) => o.value)
    );
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('selecting on parent pushes new options to child', async ({ page }) => {
    const parent = picker(page, 'parent');
    const child = picker(page, 'child');

    // Child starts empty.
    expect(await getOptionValues(child)).toEqual([]);

    // Pick "Fruit" on parent → server replies with push_event for child.
    await openDropdown(parent);
    await optionByValue(parent, 'fruit').click();

    await expect.poll(() => getOptionValues(child)).toEqual(['apple', 'banana']);
});

test('id filter: an update for "child" leaves "sibling" untouched', async ({ page }) => {
    const parent = picker(page, 'parent');
    const child = picker(page, 'child');
    const sibling = picker(page, 'sibling');

    const siblingBefore = await getOptionValues(sibling);

    await openDropdown(parent);
    await optionByValue(parent, 'veg').click();

    // Child gets the new vegetable options.
    await expect.poll(() => getOptionValues(child)).toEqual(['carrot', 'potato']);

    // Sibling's options are unchanged. Snapshot equality, not just length —
    // a bug that swaps in the wrong array would still pass a length check.
    expect(await getOptionValues(sibling)).toEqual(siblingBefore);
});

test('value-only update sets the selection without touching the option list', async ({ page }) => {
    const parent = picker(page, 'parent');
    const child = picker(page, 'child');

    // Load Fruit options onto child first.
    await openDropdown(parent);
    await optionByValue(parent, 'fruit').click();
    await expect.poll(() => getOptionValues(child)).toEqual(['apple', 'banana']);

    // Now trigger a value-only push_event.
    await page.locator('#preselect-banana').click();

    await expect.poll(() => getValue(child)).toEqual(['banana']);

    // Option list still intact.
    expect(await getOptionValues(child)).toEqual(['apple', 'banana']);
});
