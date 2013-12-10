#!/bin/bash
# Script to set things up from empty repo.

npm install
export PATH=$PATH:./node_modules/.bin
bower install
make bundle

echo "run \`sudo npm link\` to symlink this package"