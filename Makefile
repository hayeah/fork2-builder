src := src/client
build := build/client
bower := bower_components
bundle := bundle
optimize := uglify2

.PHONY: bundle build test server watch

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

css_files := $(shell find $(src)/css -type f)

bundle: build
	r.js -o $(build)/build.js dir=$(bundle) optimize=$(optimize)

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

$(build)/%.js: $(src)/%.coffee
	@mkdir -p $(@D)
	coffee -m -c -o $(@D) $<

# Compile the r.js build configuration as JSON
$(build)/build.js: $(src)/build.coffee
	@mkdir -p $(@D)
	coffee --bare -c -p $< | sed '1d ; s/^});/}/ ; s/^({/{/' > $@

test:
	mocha --compilers coffee:coffee-script test

server:
	nodemon ./bin/server.coffee

watch:
	watchy -w src/ -- make build
	
clean:
	rm -r $(build)