clientdir=src/client

.PHONY: up test client

# do what is necessary to run project
up: node_modules client

# build client
client:
	$(MAKE) -C $(clientdir) build

test: up
	mocha --compilers coffee:coffee-script test

node_modules: package.json
	npm install
	touch node_modules

