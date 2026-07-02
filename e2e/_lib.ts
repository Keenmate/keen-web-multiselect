import { Page } from '@playwright/test';

/**
 * Wait until the page is interactive end-to-end:
 *   - the upstream <web-multiselect> custom element has upgraded, AND
 *   - the LiveSocket has connected and the layout's LvReady hook has mounted.
 *
 * Without the LvReady wait, Playwright can click options within ~100ms of
 * page load — before the wrapper's LV hook has attached its listeners — and
 * the `select` / `change` events silently drop on the floor.
 */
export async function waitForReady(page: Page): Promise<void> {
    await page.waitForFunction(
        () =>
            !!customElements.get('web-multiselect') &&
            (window as any).__phxReady === true
    );
}
