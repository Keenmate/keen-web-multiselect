import { test, expect, Page, Locator } from '@playwright/test';
import { waitForReady } from './_lib';

/**
 * Badges overflow popover.
 *
 * In `partial` mode with badges_max_visible=2 and four values preselected,
 * upstream renders two badges plus a "+2 more" overflow badge
 * (.ms__badge--more[data-action="show-selected"]). Clicking that badge (not its
 * remove button) opens the selected-items popover (.ms__selected-popover--visible)
 * listing all four. This exercises the threshold/partial rendering path and the
 * popover toggle the wrapper otherwise never touches.
 */

const PAGE = '/test/badges-popover';

function picker(page: Page, id: string): Locator {
    return page.locator(`#${id}`);
}

test.beforeEach(async ({ page }) => {
    await page.goto(PAGE);
    await waitForReady(page);
});

test('partial mode renders only max-visible badges plus a "+N more"', async ({ page }) => {
    const p = picker(page, 'overflow');

    // Two real badges + one overflow badge = 3 .ms__badge nodes.
    await expect(p.locator('.ms__badge:not(.ms__badge--more)')).toHaveCount(2);

    const more = p.locator('.ms__badge--more');
    await expect(more).toBeVisible();
    await expect(more.locator('.ms__badge-text')).toHaveText('+2 more');
});

test('clicking the "+N more" badge opens the selected-items popover', async ({ page }) => {
    const p = picker(page, 'overflow');

    const popover = p.locator('.ms__selected-popover');
    await expect(popover).not.toHaveClass(/ms__selected-popover--visible/);

    // Click the badge body, not its remove-hidden button.
    await p.locator('.ms__badge--more .ms__badge-text').click();

    await expect(popover).toHaveClass(/ms__selected-popover--visible/);

    // All four selected values are listed in the popover body.
    const badges = popover.locator('.ms__selected-popover-body .ms__badge');
    await expect(badges).toHaveCount(4);
});

test('the popover close button dismisses it', async ({ page }) => {
    const p = picker(page, 'overflow');

    await p.locator('.ms__badge--more .ms__badge-text').click();
    const popover = p.locator('.ms__selected-popover');
    await expect(popover).toHaveClass(/ms__selected-popover--visible/);

    await popover.locator('.ms__selected-popover-close').click();
    await expect(popover).not.toHaveClass(/ms__selected-popover--visible/);
});
