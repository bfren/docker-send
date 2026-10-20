// Start Send's server - Node.js 23 removed util.log and the util.is* functions (e.g. util.isError), but Send's logging
// library (intel, used by mozlog) still calls them, so put back any that are missing before loading the server
const util = require('util');

const removed = {
  isBoolean: x => typeof x === 'boolean',
  isBuffer: x => Buffer.isBuffer(x),
  isDate: x => util.types.isDate(x),
  isError: x => util.types.isNativeError(x) || x instanceof Error,
  isFunction: x => typeof x === 'function',
  isNull: x => x === null,
  isNullOrUndefined: x => x === null || x === undefined,
  isNumber: x => typeof x === 'number',
  isObject: x => x !== null && typeof x === 'object',
  isPrimitive: x => x === null || (typeof x !== 'object' && typeof x !== 'function'),
  isRegExp: x => util.types.isRegExp(x),
  isString: x => typeof x === 'string',
  isSymbol: x => typeof x === 'symbol',
  isUndefined: x => x === undefined,
  log: (...args) => console.log(`${new Date().toISOString()} - ${util.format(...args)}`)
};

for (const [name, fn] of Object.entries(removed)) {
  if (typeof util[name] !== 'function') {
    util[name] = fn;
  }
}

require('./prod.js');
