// @dannycoates/express-ws (used by Send's server for websockets) loads its ES module source through the 'esm' package,
// which fails on newer versions of Node.js - convert that source to CommonJS when the image is built, so 'esm' isn't
// needed (run from the directory containing node_modules)
const fs = require('fs');
const path = require('path');

const dir = path.join(process.cwd(), 'node_modules', '@dannycoates', 'express-ws');
const src = path.join(dir, 'src');

for (const file of fs.readdirSync(src).filter(f => f.endsWith('.js'))) {
  const p = path.join(src, file);
  const converted = fs
    .readFileSync(p, 'utf8')
    .replace(/^import (\w+) from '([^']+)';$/gm, "const $1 = require('$2');")
    .replace(/^export default function /gm, 'module.exports = function ');

  // stop the build if anything was left that this simple conversion doesn't handle
  if (/^\s*(import|export)\b/m.test(converted)) {
    throw new Error(`${p} contains ES module syntax that could not be converted`);
  }

  fs.writeFileSync(p, converted);
}

fs.writeFileSync(path.join(dir, 'index.js'), "module.exports = require('./src/index');\n");
console.log('Converted @dannycoates/express-ws to CommonJS.');
