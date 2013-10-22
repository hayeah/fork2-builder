src := src
build := build
bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

less_files := $(shell find $(src) -type f -name '*.less')
css_files := $(less_files:$(src)/%.less=$(build)/%.css)

bundle: build
	r.js -o $(build)/build.js dir=$(bundle) optimize=$(optimize)

build: js css
	@rsync -qPa $(bower) $(build)
	@rsync -qPa $(src)/lib $(build)

css: $(css_files)

$(build)/%.css: $(src)/%.less
	@mkdir -p $(@D)
	lessc $< $@

# Compile CoffeeScript to JavaScript
js: $(js_files)

$(build)/%.js: $(src)/%.coffee
	@mkdir -p $(@D)
	coffee -m -c -o $(@D) $<

# Compile the r.js build configuration as JSON
$(build)/build.js: $(src)/build.coffee
	@mkdir -p $(@D)
	coffee --bare -c -p $< | sed '1d ; s/^});/}/ ; s/^({/{/' > $@
	
