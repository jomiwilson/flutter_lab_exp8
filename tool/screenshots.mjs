// Captures screenshots of the running Flutter web build for the lab record.
import { chromium } from 'playwright';
import fs from 'fs';

const EXP = Number(process.env.EXP);
const URL = 'http://localhost:8080/';
fs.mkdirSync('screenshots', { recursive: true });

const browser = await chromium.launch();
const ctx = await browser.newContext({ viewport: { width: 412, height: 870 }, deviceScaleFactor: 2 });
const page = await ctx.newPage();
page.on('console', m => console.log('[console]', m.text()));
page.on('pageerror', e => console.log('[pageerror]', e.message));
const wait = ms => page.waitForTimeout(ms);
let n = 0;
const shot = async name => { n++; await page.screenshot({ path: `screenshots/${String(n).padStart(2, '0')}_${name}.png` }); console.log('shot', name); };

async function load() {
  await page.goto(URL);
  await page.waitForSelector('flutter-view, flt-glass-pane', { timeout: 60000 });
  await wait(3000);
  await page.evaluate(() => { const e = document.querySelector('flt-semantics-placeholder'); if (e) e.click(); });
  await wait(1000);
}
async function tap(name) {
  const b = page.getByRole('button', { name, exact: false }).first();
  if (await b.count()) await b.click(); else await page.getByText(name, { exact: false }).first().click();
  await wait(700);
}
async function type(label, text) {
  const t = page.getByRole('textbox', { name: label, exact: false }).first();
  await t.click(); await wait(300);
  await page.keyboard.type(text, { delay: 30 }); await wait(300);
}
async function desktop() { await page.setViewportSize({ width: 1280, height: 720 }); await wait(1500); }

await load();
switch (EXP) {
  case 1: await shot('student_profile'); break;
  case 2: await shot('mobile_layout'); await desktop(); await shot('desktop_layout'); break;
  case 3:
    await tap('Submit'); await shot('validation_message');
    await type('Student Name', 'Jomi W'); await type('Email', 'jomi@example.com'); await type('Password', 'jomi1234');
    await tap('Submit'); await wait(300); await shot('form_submitted'); break;
  case 4: await wait(1500); await shot('image_gallery'); break;
  case 5:
    await shot('home_screen'); await tap('Go to Profile'); await shot('profile_screen');
    await tap('View Details'); await shot('details_screen'); break;
  case 6: await shot('before_animation'); await tap('Animate'); await wait(1500); await shot('after_animation'); break;
  case 7:
    for (const s of ['Jomi W', 'Arun K', 'Priya S']) { await type('Student Name', s); await tap('Add Student'); }
    await shot('student_list'); break;
  case 8:
    for (const [s, c] of [['Jomi W', 'CSE'], ['Arun K', 'ECE'], ['Priya S', 'IT']]) {
      await type('Student Name', s); await type('Course', c); await tap('Add Student'); await wait(800);
    }
    await shot('sqlite_records');
    await load(); await wait(1500); await shot('records_after_restart'); break;
  case 9:
    await shot('api_data');
    await page.route('**/posts', async r => { await new Promise(x => setTimeout(x, 6000)); await r.continue(); });
    await page.goto(URL); await page.waitForSelector('flutter-view, flt-glass-pane'); await wait(2500); await shot('loading');
    await page.unroute('**/posts');
    await page.route('**/posts', r => r.fulfill({ status: 500, body: 'error' }));
    await load(); await shot('error'); break;
  case 10: for (let i = 0; i < 3; i++) await tap('Increment'); await shot('counter_app'); break;
  case 11: await shot('home'); await tap('Test Button'); await wait(300); await shot('test_button'); break;
  case 12: await shot('mobile_web_layout'); await desktop(); await shot('desktop_web_layout'); break;
}
await browser.close();
