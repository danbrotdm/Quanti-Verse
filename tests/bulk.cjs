const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const out = process.argv[2] || OUTDIR;
const assert = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch();
  const ctx = await b.newContext({ viewport: { width: 1280, height: 1000 }, locale: 'en-US' });
  const p = await ctx.newPage();
  const errs = []; p.on('pageerror', e => errs.push(e.message)); p.on('console', m => m.type() === 'error' && errs.push(m.text()));
  p.on('dialog', d => d.accept());
  await p.goto(APP_FILE); await p.click('#nexusSorterBtn');
  await p.setInputFiles('#qs-file', ['flash', 'dos', 'web'].map(n => `${out}/${n}.bootable.zip`));
  await p.waitForFunction(() => document.querySelectorAll('.qs-card').length === 3);
  const state = () => p.evaluate(() => [...document.querySelectorAll('.qs-card')].map(c => ({
    title: c.querySelector('.qs-title').textContent, sel: c.classList.contains('selected'),
    tags: [...c.querySelectorAll('.qs-mini-tag')].map(t => t.textContent).filter(t => t !== '#untagged'),
    fav: c.querySelector('[data-action=favorite]').textContent.trim() === '★' })));
  const act = async (fn, re) => { await fn(); await p.waitForFunction(r => new RegExp(r).test(document.getElementById('qs-tagline').textContent), re); };
  const sel = async i => (await p.$$('.qs-sel'))[i];
  assert(await p.isVisible('#qs-bulk') && await p.isDisabled('#qs-bulk-delete'), 'bulk bar visible, actions disabled with nothing selected');

  await (await sel(0)).click(); await (await sel(2)).click({ modifiers: ['Shift'] });
  let st = await state();
  assert(st.every(c => c.sel) && (await p.textContent('#qs-bulk-count')).startsWith('3 SELECTED'), 'shift-click selected the whole range (3)');

  await p.fill('#qs-bulk-tag', 'Retro, test'); await act(() => p.click('#qs-bulk-tagadd'), 'ADDED TO 3');
  st = await state();
  assert(st.every(c => c.tags.includes('#retro') && c.tags.includes('#test')), 'tags added to all 3: ' + JSON.stringify(st.map(c => c.tags)));
  console.log('  tagline:', await p.textContent('#qs-tagline'));

  await (await sel(1)).click();                       // deselect the middle one
    await p.fill('#qs-bulk-tag', 'test'); await act(() => p.click('#qs-bulk-tagdel'), 'REMOVED FROM 2');
  st = await state();
  assert(!st[0].tags.includes('#test') && st[1].tags.includes('#test') && !st[2].tags.includes('#test'), 'tag removed only from the 2 selected');

  await act(() => p.click('#qs-bulk-fav'), '2 ADDED TO FAVORITES'); st = await state();
  assert(st[0].fav && !st[1].fav && st[2].fav, 'favorite applied to the 2 selected');

  // Filter hides a selected game: the count should say so, and actions still apply to it.
  await p.fill('#qs-search', st[0].title);
  console.log('  count while filtered:', await p.textContent('#qs-bulk-count'));
  assert((await p.textContent('#qs-bulk-count')).includes('HIDDEN'), 'count reports selected games hidden by the search');
  await p.fill('#qs-search', '');

  const keep = st[1].title;
  await p.click('#qs-bulk-delete');
  await p.waitForFunction(() => document.querySelectorAll('.qs-card').length === 1);
  st = await state();
  assert(st.length === 1 && st[0].title === keep && (await p.textContent('#qs-bulk-count')).startsWith('0 SELECTED'), 'delete removed the 2 selected, kept ' + keep);
  await p.screenshot({ path: out + '/bulk.png' });

  await p.reload(); await p.click('#nexusSorterBtn'); await p.waitForTimeout(800);
  st = await state();
  assert(st.length === 1 && st[0].title === keep && st[0].tags.join() === '#retro,#test' && !st[0].fav, 'state persisted after reload: ' + JSON.stringify(st));
  console.log('errors:', errs.length ? errs : 'none');
  await b.close();
})();
