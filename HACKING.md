# Getting the source

    git clone https://github.com/hayeah/fork2-builder.git

# Prereqs

Install coffee-script globally.

    npm install -g coffee-script

# Get development dependencies

First, cd into the root of the cloned repository.

    cd fork2-builder

Install server side dependencies:

    npm install

Be sure to add `./node_modules/.bin` to your $PATH so you get the executables installed by npm (e.g. bower, coffee, lessc).

    export PATH=$PATH:./node_modules/.bin

Then install client side Javascript dependencies:

    bower install

# Developing

It's easier to work on fork2-server by installing it as a linked npm package (so changes made to the source are immediately available in the installed package). For details, see [npm-link](https://npmjs.org/doc/cli/npm-link.html). In the project root, do:

    npm link

After that, you should be able to run the fork2 command.

    > fork2

    Fork2 Version 0.0.2
    The available commands are:

    help - Show detailed help for a command
    compile-template - Compiles a single content template.
    build-project - Builds a given project to an output path.
    run - Runs a built project.

    `fork2 help <command>` to show detailed help for a subcommand.

# Building Client-Side

To build client-side assets:

    make build

To create the bundled client-side assets

    make bundle

Or to build the bundle without optimizing with uglify, to inspect the output,

    make bundle optimize=none

# Pitfall

When you are developing, you want `fork2 run` to use the js and css assets created by `make build`. Be sure to remove `bundle` if you've run `make bundle`, otherwise the fork2 server would serve the bundled assets.