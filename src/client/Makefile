build := build
bundle_path := bundle

# JS Vars
js_build := $(build)/js
js_bundle_path := $(bundle_path)/js

## Input
js_src := src
js_files := $(shell find $(js_src) -type f -name '*.coffee')
js_contracts := ../types.coffee

## Output
js_build_output := $(addprefix $(js_build)/,app.js app-vendor.js check-debug.js uitest.js)
js_bundle_output := $(addprefix $(js_bundle_path)/,app.js app-vendor.js)

# CSS vars
css_build := $(build)/css
css_bundle_path := $(bundle_path)/css

## Input
css_src := src/css
css_files := $(shell find $(js_src) -type f -name '*.less')

## Output
css_build_output := $(css_build)/app.css
css_bundle_output := $(css_bundle_path)/app.css

# Assets
asset_path := assets
asset_build_path := $(css_build)
asset_bundle_path := $(css_bundle_path)
asset_files := $(shell find $(asset_path) -type f)

asset_build_output := $(patsubst $(asset_path)/%,$(asset_build_path)/%,$(asset_files))
asset_bundle_output := $(patsubst $(asset_path)/%,$(asset_bundle_path)/%,$(asset_files))

bower := bower_components

.PHONY: bundle build watch deps

rebuild: clean build

build: deps build_js build_css build_assets

watch:
	watchy -w uitest,src,$(js_contracts),../contracts.coffee -- make build

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

bundle: bundle_js bundle_css

bundle_js: $(js_bundle_path) $(js_bundle_output)

$(js_bundle_path):
	mkdir -p $@

$(js_bundle_path)/%.js: $(js_build)/%.js
	uglifyjs -m -c --stats -o $@ $< || > $@

bundle_css: $(css_bundle_path) $(css_bundle_output) $(asset_bundle_output)

$(css_bundle_path):
	mkdir -p $@

$(css_bundle_path)/%.css:  $(css_build)/%.css
	lessc --compress $< > $@ || rm $@

bundle_assets: $(asset_build_output)

$(asset_bundle_path)/%: $(asset_path)/%
	mkdir -p $(@D)
	cp $< $@

# bundle_css: $(css_files)

# JS Build Rules
build_js: $(js_build) $(addprefix $(js_build)/,app.js app-vendor.js check-debug.js uitest.js)

$(js_build):
	mkdir -p $(js_build)

$(js_build)/%-vendor.js: $(js_src)/%-vendor.txt
	cat $< | sed '/^#/ d' | xargs cat > $@

browserify := browserify -t hbsfy -t coffeeify --extension='.coffee' --no-detect-globals

# Type contracts for debug mode
$(js_build)/check-debug.js: $(js_contracts) ../contracts.coffee
	$(browserify) -r $(js_contracts):check-debug -o $@ || rm $@

# $(js_build)/%.js: $(js_src)/%.coffee $(js_files)
# 	$(browserify) -r ./$(js_src)/check.coffee:check -x check-debug -o $@ $< || rm $@

$(js_build)/app.js: $(js_src)/app.coffee $(js_files)
	coffee build.coffee app > $@ || rm $@
	@# $(browserify) -r ./$(js_src)/check.coffee:check -x check-debug -o $@ $< || rm $@

$(js_build)/uitest.js: $(shell find uitest -type f -name '*.coffee')
	coffee build.coffee uitest > $@ || rm $@

# CSS Build Rules
build_css: $(css_build) $(css_build_output)

#css/img

# css/img: $(subst $(css_src)/img,$(css_build)/img,$(css_img_files))

# $(css_build)/img/%: $(css_src)/img/%
# 	@mkdir -p $(css_build)/img
# 	cp $< $@
$(css_build):
	mkdir -p $(css_build)

$(css_build)/%.css: $(css_src)/%.less $(css_files)
	lessc $< $@ --source-map-map-inline --source-map-less-inline

# Asset rules

build_assets: $(asset_build_output)

$(asset_build_path)/%: $(asset_path)/%
	mkdir -p $(@D)
	cp $< $@