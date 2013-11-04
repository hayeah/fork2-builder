# working on the source

Getting the source

    git clone <URL>

It's easier to work on fork2-server by installing it as a linked npm package (so changes made to the source are immediately available in the installed package). For details, see [npm-link](https://npmjs.org/doc/cli/npm-link.html). In the project root, do:

    npm link

To rebuild client-side assets:

    make build

To watch for changes and rebuild client-side assets:

    make watch
