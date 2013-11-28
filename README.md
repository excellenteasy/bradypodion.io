# bradypodion.io

## Prerequisites

You have to install some global dependencies to use the build process.

```bash
npm install -g grunt-cli bower
```

Once this is finished you can install local dependencies.

```bash
npm install
bower install
```
## Build

For development you may fire up a server with livereload enabled.

```bash
grunt serve
```

For distribution you can use the build command.

```bash
grunt build
```

There is a command to serve the distribution build.

```bash
grunt serve:dist
```
