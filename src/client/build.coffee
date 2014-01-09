browserify = require("browserify")
glob = require("glob")
path = require("path")
coffeeify = require("coffeeify")


b = browserify(extensions: [".coffee"])
b.transform(coffeeify)

# Uppercase module can be required by their module names.
PUBLIC_MODULES_RE = /^([A-Z].+)\.(coffee|js)$/

# @return map of public module name to src path
public_modules_of = (dir) ->
  mods = {}
  for file in files = glob.sync(path.join dir, "**/*")
    filename = path.basename(file)
    if m = filename.match(PUBLIC_MODULES_RE)
      mods[m[1]] = "./" + file

  mods

app_modules = -> public_modules_of("src")
uitest_modules = -> public_modules_of("uitest")

target = process.argv[2] || "app"

switch target
  when "app"
    for name, srcPath of app_modules()
      b.require(srcPath,expose: name)

      b.add("./src/app.coffee")

      b.require("./src/check.coffee",expose: "check")
      b.external("check-debug")

  when "uitest"
    for name, srcPath of app_modules()
      b.external(name)

    for name, srcPath of uitest_modules()
      b.require(srcPath,expose: "uitest/#{name}")


# Contract check

b.bundle(debug: true).pipe process.stdout