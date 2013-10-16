src := src
build := build
bower := bower_components
bundle := bundle

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

bundle: build
	r.js -o $(build)/build.js dir=$(bundle)

build: js
	@rsync -qPa $(bower) $(build)

# Compile CoffeeScript to JavaScript
js: $(js_files)

$(build)/%.js: $(src)/%.coffee
	@mkdir -p $(@D)
	coffee -m -c -o $(@D) $<

# Compile the r.js build configuration as JSON
$(build)/build.js: $(src)/build.coffee
	@mkdir -p $(@D)
	coffee --bare -c -p $< | sed '1d ; s/^});/}/ ; s/^({/{/' > $@
	
