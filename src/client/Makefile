build := build
js_build := $(build)/js
js_src := src
js_files := $(shell find $(js_src) -type f -name '*.coffee')

css_build := $(build)/css
css_src := src/src
js_files := $(shell find $(js_src) -type f -name '*.less')

bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build test run watch

build: ks

# JS Build Rules
js: $(js_build) $(addprefix $(js_build)/,app.js app-vendor.js)

$(js_build):
	mkdir -p $(js_build)

$(js_build)/%-vendor.js: $(js_src)/%-vendor.txt
	cat $< | sed '/^#/ d' | xargs cat > $@

browserify := browserify -t hbsfy -t coffeeify --extension='.coffee' --no-detect-globals
$(js_build)/%.js: $(js_src)/%.coffee $(js_files)
	$(browserify) -o $@ $< || rm $@

# CSS Build Rules

clean:
	rm -r $(build)