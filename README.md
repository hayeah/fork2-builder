This authoring tool helps you create workshop-like courses.

# Requirements

For now, this project needs coffee script. To install coffeescript globally for your user, run

    npm install -g coffee-script

We'll remove this requirement in future versions.

# Installation

Install the stable release from NPM

    npm install -g fork2

If the install had been successful, running the fork2 command should output some help message,

```
> fork2
Fork2 Version 0.0.1
The available commands are:

  help - Show detailed help for a command
  compile-template - Compiles a single content template.
  build-project - Builds a given project to an output path.
  run - Runs a built project.
```

### Local Path Installation

NPM allows you do install a package on your local path. To install fork2 that way, just cd into the path you want, and run

    npm install fork2

To get access to the fork2 bins, be sure to add the local node_modules bin path to your PATH environment variable. Like so,

    export PATH=$PATH:./node_modules/.bin

# To Build And Run a project

```
cd $PROJECT && fork2 build && fork2 run --port 3000
```

# Documentation

[See the wiki](https://github.com/hayeah/fork2-builder/wiki/Fork2-Builder-Documentation)

# Contributing

[See the HACKING guide](https://github.com/hayeah/fork2-builder/blob/master/HACKING.md).

# License

This project is under the MIT License.
