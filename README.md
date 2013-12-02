This authoring tool helps you create workshop-like courses.

# Requirements

For now, this project needs coffee script. To install coffeescript globally for your user, run

    npm install -g coffee-script

We'll remove this requirement in future versions.

# Installation

Install the stable release from NPM

    npm install fork2

Or install the latest master from git

    npm install https://github.com/hayeah/fork2-builder.git

If you want to develop the builder itself, see the HACKING guide.

# Documentation

[Link to wiki]

# Permalink

project content files

    <permalink>.<content-type>.html

local server urls

    / # show projcet index
    /<permalink> # show content. It matches a file in workspace, and determine the type by looking at files suffix

where `<permalink>` must be unique.

# License

This project is under the MIT License.
