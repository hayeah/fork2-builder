.PHONY: build watch

watch:
	watchy -w src/types.coffee -- make build

build: build/types.js

build/types.js: src/types.coffee
	mkdir -p build
	coffee -cp $< > $@