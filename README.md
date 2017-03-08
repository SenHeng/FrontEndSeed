# Front End Seed
![travis][travis-src]


This project is a skeleton for doing html and css development. You can use it to quickly bootstrap web design projects and also the dev environment for these projects.

The seed only contains a single html file and a stylesheet of each type.

There are a few pre-configured [gulp.js][gulp-src] tasks to automatically preprocess the various stylesheets from the `src` directory into the `dist` directory.

## Getting started

To start, simply clone and install the required dependencies with either npm or yarn.

1. `git clone https://github.com/thelegendofcode/FrontEndSeed.git`
1. `npm install` or `yarn`

To clone without the commit histories:

1. `git clone --depth=1 https://github.com/SenHeng/FrontEndSeed.git`

## Set up

The default set up is for SCSS development. To switch to LESS or Post-css, follow the below steps.

TODO add steps for LESS and PostCSS

## Start developing

This project uses [gulp.js][gulp-src] to set up a local dev server and monitor for any changes to html and css files in the `src` directory.

1. `npm start` or `yarn start`

## Build

When development is complete, using the below command will preprocess the css and html into the `dist` folder.

1. `npm run build` or `yarn run build`

## Deploying to GitHub Pages

1. `yarn run makeDist`
1. `yarn run build`
1. release

cd dist
git add .
git commit -m "test: gh deploy"

[gulp-src]: http://gulpjs.com/
[travis-src]: https://travis-ci.org/SenHeng/FrontEndSeed.svg?branch=master
