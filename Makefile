src := src/client
build := build/client
bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build test run watch

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

css_files := $(shell find $(src)/css -type f)

bundle: build $(bundle)/app.js $(bundle)/vendor.js $(bundle)/main.css

$(bundle)/%.js: $(build)/build-%.js
	r.js -o $< optimize=$(optimize)	out=$@

$(bundle)/%.css: $(build)/%.css
	lessc -x $< $@

build: js css
	@rsync -qPa $(bower) $(build)
	@rsync -qPa $(src)/lib $(build)

css: $(build)/main.css

$(build)/main.css: $(css_files)
	@mkdir -p $(build)
	lessc $(src)/main.less $@

# css: $(css_files)
#
# $(build)/%.css: $(src)/%.less
# 	@mkdir -p $(@D)
# 	lessc $< $@

# Compile CoffeeScript to JavaScript
js: $(js_files)

# Compile the r.js build configuration as JSON
# This should precede the normal coffeescript build
$(build)/build%.js: $(src)/build%.coffee
	@mkdir -p $(@D)
	coffee --bare -c -p $< | sed '1d ; s/^});/}/ ; s/^({/{/' > $@

$(build)/%.js: $(src)/%.coffee
	@mkdir -p $(@D)
	coffee -m -c -o $(@D) $<

test:
	mocha --compilers coffee:coffee-script test

run: build
	fork2 run sample-content

watch:
	watchy -w src/ -- make run

clean:
	rm -r $(build)
	rm -r $(bundle)
