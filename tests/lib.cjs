// Shared test helpers. Playwright comes from the project (npm i -D playwright) or a global install.
const path = require('path'), fs = require('fs');
function playwright() {
  try { return require('playwright'); } catch (_) {}
  const g = require('child_process').execSync('npm root -g').toString().trim();
  return require(path.join(g, 'playwright'));
}
const ROOT = path.resolve(__dirname, '..');
const WORK = path.join(__dirname, '.work');
fs.mkdirSync(path.join(WORK, 'out'), { recursive: true });
module.exports = {
  chromium: playwright().chromium,
  APP_FILE: 'file://' + path.join(ROOT, 'index.html'),
  ROOT, WORK, FIXTURES: path.join(WORK, 'fixtures'), OUT: path.join(WORK, 'out'),
};
