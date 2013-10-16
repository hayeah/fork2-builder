src := src
build:= build
bower := bower_components

coffee_files := $(shell find $(src) -type f -name '*.coffee')
js_files := $(coffee_files:$(src)/%.coffee=$(build)/%.js)

build: js
	@echo copy $(bower) to $(build)/$(bower)
	@rsync -qPa $(bower) $(build)

# Compile CoffeeScript to JavaScript
js: $(js_files)

$(build)/%.js: $(src)/%.coffee
	@mkdir -p $(@D)
	coffee -m -c -o $(@D) $<
