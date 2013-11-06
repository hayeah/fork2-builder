# Getting the source

    git clone <URL>

# Get development dependencies

Install server side dependencies:

    npm install

Be sure to add `./node_modules/.bin` to your $PATH so you get the executables installed by npm (e.g. bower, coffee, lessc).

Then install client side Javascript dependencies:

    bower install

# Developing

It's easier to work on fork2-server by installing it as a linked npm package (so changes made to the source are immediately available in the installed package). For details, see [npm-link](https://npmjs.org/doc/cli/npm-link.html). In the project root, do:

    npm link

To rebuild client-side assets:

    make build

To create the bundled client-side assets

    make bundle

Or to build the bundle without optimizing with uglify

    make bundle optimize=none
