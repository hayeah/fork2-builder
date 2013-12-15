build := build
js_build := $(build)/js
js_src := src
js_files := $(shell find $(js_src) -type f -name '*.coffee')

css_build := $(build)/css
css_src := src/css
css_files := $(shell find $(js_src) -type f -name '*.less')

bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build watch deps

rebuild: clean build

build: deps js css

watch:
	watchy -w src -- make build

clean:
	rm -r $(build)

# npm and bower deps
deps: node_modules bower_components

node_modules: package.json
	npm install
	touch $@

bower_components: bower.json | node_modules
	bower install
	touch $@

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
css: $(css_build) $(addprefix $(css_build)/,app.css app-vendor.css)

$(css_build)/%.css: $(css_src)/%.less $(css_files)
	lessc $< $@ --source-map-map-inline --source-map-less-inline

$(css_build):
	mkdir -p $(css_build)