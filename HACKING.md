# Prereqs

Install coffee-script globally.

    npm install -g coffee-script

Add locally installed npm bin to PATH (do this for a shell session, or in your shell init file).

    export PATH=$PATH:./node_modules/.bin

# Install

Clone the repo

    git clone https://github.com/hayeah/fork2-builder.git

First, cd into the root of the cloned repository.

    cd fork2-builder

Prepare to run the project by installing project dependencies and building client Javascript:

    make up

Note that everything is installed locally.

Finally, link the repo as npm package ([see npm-link](https://npmjs.org/doc/cli/npm-link.html)):

    sudo npm link

# Uninstall Everything

    # uninstall the linked package
    sudo npm rm -g fork2

    # delete the fork2-builder repo
    rm -r fork2-builder

# Building Client-Side

The client side code is in its own subdirectory, in `src/client`. To build it:

    # in src/client
    make build

To automatically rebuild on change,

    # in src/client
    make watch

To completely rebuild

    # in src/client
    make rebuild

# Bundling the Client-Side for Release

To create the bundled client-side assets

    # in src/client
    make bundle

Or to build the bundle without optimizing with uglify, to inspect the output,

    # in src/client
    make bundle optimize=none

# Pitfall

When you are developing, you want `fork2 run` to use the js and css assets created by `make build`. Be sure to remove `bundle` if you've run `make bundle`, otherwise the fork2 server would serve the bundled assets.