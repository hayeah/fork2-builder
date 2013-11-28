src := src/client
build := build/client
bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build test run watch

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

css_files := $(shell find $(src)/css -type f -name '.less')

bundle: build $(bundle)/mobile.js $(bundle)/mobile.css $(bundle)/app.js $(bundle)/app-vendor.js $(bundle)/app.css

$(bundle)/ace:
	@mkdir -p $(bundle)
	rsync -Pa $(build)/bower_components/ace-builds/src-min-noconflict/ $(bundle)/ace

$(bundle)/%.js: $(build)/build/%.js
	r.js -o $< optimize=$(optimize)	out=$@

$(bundle)/%.css: $(build)/%.css
	lessc -x $< $@

build: js css
	@rsync -qPa $(bower) $(build)
	@rsync -qPa $(src)/lib $(build)

build/bower:
	@rsync -qPa $(bower) $(build)

css: $(build)/css/app.css $(build)/css/mobile.css

$(build)/%.css: $(src)/%.less $(css_files)
	@mkdir -p $(build)
	lessc $< $@

# css: $(css_files)
#
# $(build)/%.css: $(src)/%.less
# 	@mkdir -p $(@D)
# 	lessc $< $@

# Compile CoffeeScript to JavaScript
js: $(js_files)

# Compile the r.js build configuration as JSON
# This should precede the normal coffeescript build
$(build)/build/%.js: $(src)/build/%.coffee
	@mkdir -p $(@D)
	coffee --bare -c -p $< | sed '1d ; s/^});/}/ ; s/^({/{/' > $@

$(build)/%.js: $(src)/%.js
	@mkdir -p $(@D)
	cp $< $@

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
