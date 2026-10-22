const sass = require("sass");

// sass-loader 6 always passes an async webpack importer. Dart Sass's
// callback-style render() deadlocks on that importer because compilation
// never yields back to the event loop. Resolve relative files from
// includePaths instead, which is how these stylesheets import.
function syncImporter(importer) {
  if (typeof importer !== "function" || importer.length < 3) return importer;

  return (url) => ({ file: url });
}

function render(options, callback) {
  const opts = Object.assign({}, options);
  delete opts.precision;

  if (Array.isArray(opts.importer)) {
    opts.importer = opts.importer.map(syncImporter);
  } else if (typeof opts.importer === "function") {
    opts.importer = syncImporter(opts.importer);
  }

  try {
    const result = sass.renderSync(opts);
    if (typeof callback === "function") {
      callback(null, result);
      return undefined;
    }
    return result;
  } catch (error) {
    if (typeof callback === "function") {
      callback(error);
      return undefined;
    }
    throw error;
  }
}

module.exports = Object.assign({}, sass, { render });
