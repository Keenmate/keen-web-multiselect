import { chromium } from '@playwright/test';
const b = await chromium.launch();
const ctx = await b.newContext({ hasTouch: true, isMobile: true, viewport: { width: 900, height: 800 } });
const p = await ctx.newPage();
await p.goto('http://localhost:4060/examples/responsive', { waitUntil: 'networkidle' });
await p.waitForFunction(() => { const el = document.getElementById('intro-select'); return el && typeof el.setSelected === 'function'; });

await p.evaluate(() => {
  window.__env = 0; window.__resized = 0;
  for (const id of ['intro-select','drag-select']) {
    const el = document.getElementById(id);
    if (!el) continue;
    const oe = el.environmentChanged.bind(el);
    el.environmentChanged = (e) => { window.__env++; window.__lastEnv = e; return oe(e); };
    const orz = el.resized.bind(el);
    el.resized = (s) => { window.__resized++; window.__lastSize = s; return orz(s); };
  }
});
const before = await p.evaluate(() => ({ env: window.__env, resized: window.__resized }));
console.log('after instrument, baseline:', JSON.stringify(before));

// resize wide -> narrow (cross the 600 short-side boundary)
await p.setViewportSize({ width: 480, height: 820 });
await p.waitForTimeout(800);
const after = await p.evaluate(() => ({ env: window.__env, resized: window.__resized, lastEnv: window.__lastEnv }));
console.log('after resize 480x820:', JSON.stringify(after));

// resize back wide
await p.setViewportSize({ width: 1000, height: 800 });
await p.waitForTimeout(800);
const after2 = await p.evaluate(() => ({ env: window.__env, resized: window.__resized }));
console.log('after resize back 1000x800:', JSON.stringify(after2));
await b.close();
