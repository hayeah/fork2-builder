# Getting the source

    git clone https://github.com/hayeah/fork2-builder.git

# Prereqs

Install coffee-script globally.

    npm install -g coffee-script

Add locally installed npm bin to PATH (do this for a shell session, or in your shell init file).

    export PATH=$PATH:./node_modules/.bin

# Install

First, cd into the root of the cloned repository.

    cd fork2-builder

Install project dependencies locally:

    ./install.sh

Everything is installed within the directory of the repo. [See the script](https://github.com/hayeah/fork2-builder/blob/master/install.sh). Finally, link the repo as npm package ([see npm-link](https://npmjs.org/doc/cli/npm-link.html)):

    sudo npm link

# Uninstall Everything

    # uninstall the linked package
    sudo npm rm -g fork2

    # delete the fork2-builder repo
    rm -r fork2-builder

# Building Client-Side

To build client-side assets:

    make build

To create the bundled client-side assets

    make bundle

Or to build the bundle without optimizing with uglify, to inspect the output,

    make bundle optimize=none

# Pitfall

When you are developing, you want `fork2 run` to use the js and css assets created by `make build`. Be sure to remove `bundle` if you've run `make bundle`, otherwise the fork2 server would serve the bundled assets.