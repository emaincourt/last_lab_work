## Asynchronous Server Technologies

> Final appointment

### Target

* Be a correct NodeJS project (package.json) (4 pts)
* Apply best practices as seen in class (readme.md, scripts, ...) (2 pts)
* Set-up a NodeJS HTTP server (2 pts)
* Handle routing to be able to serve multiple static files on different paths (2 pts)
* Handle expected errors (file not found, ...) (2 pts)
* Use transpilers to render files (coffeescript / pug / stylus) (4 pts)
* Split it's logic in multiple files (2 pts)
* Have some basic unit tests to validate your routing (for example: expect 200 HTTP code if file exists, 404 if not, ...) (1 pt)
* Use travis-ci to run unit tests (1 pt)

### What's been done ?

We have tried to apply as much as be could the best practices as seen in class.

About the organization :
* All the scripts that can be run are located in the `bin` directory. They all leverage bash shell for starting commands.
* Since we have been using the native `http` module over the last two month, there was no need for such a simple use case to rely on another library (Express, Koa, HapiJS...) that could have been completely overkill
* Any of the previously enounced compilers are in use in this project. If we would have loved to use `Babel` for alternative operators support, it would have added to much complexity during testing. Indeed, if we can pass a flag to `coffee` for hooking to `Babel` after transformation, we can not chain both the libraries with `Mocha`. The basic idea would have to first transform the files in a temporary directory, then test it. Too much tricky here.
* `Mocha` and `should` have made a great work. We've added `Sinon` to them for being able to `stub`, `spy` and `mock` our modules.
* Code coverage and build status badges have also been added to our repository

### Getting started

First of all, `npm i` or `yarn` at the root of the project for getting the packages.

Then you need to compile all the files of the project :
```bash
yarn compile stylus && yarn compile coffee & yarn compile pug
// or
npm run compile stylus && npm run compile coffee & npm run compile pug
```

You can now start the server :
```bash
yarn start
// or
npm start
```

If you want to run the tests, you can then :
* Run all : `yarn test`
* Only run the `mocha` tests : `yarn test:mocha`
* Only run the `jest` tests : `yarn test:jest`