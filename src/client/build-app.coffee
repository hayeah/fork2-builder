browserify = require("browserify")
glob = require("glob")
path = require("path")
coffeeify = require("coffeeify")


b = browserify(extensions: [".coffee"])
b.transform(coffeeify)

# Uppercase module can be required by their module names.
top_modules = {}

TOP_MODULES_REGEX = /^([A-Z].+)\.(coffee|js)$/
for file in files = glob.sync("src/**/*")
  filename = path.basename(file)
  if m = filename.match(TOP_MODULES_REGEX)
    top_modules[m[1]] = "./" + file

for name, srcPath of top_modules
  b.require(srcPath,expose: name)


b.add("./src/app.coffee")

# Contract check
b.require("./src/check.coffee",expose: "check")
b.external("check-debug")
b.bundle(debug: true).pipe process.stdout