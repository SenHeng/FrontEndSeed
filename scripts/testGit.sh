#!/bin/bash
set -ev # Exit with nonzero exit code if anything fails

echo "token: ${GITHUB_TOKEN}"

git clone git@github.com:SenHeng/FrontEndSeed.git -b gh-pages dist
yarn run build
cd dist

git config user.name "Travis CI"
git config user.email "sen@legendofcode.com"

git add .
git commit -m "test: travis gh deploy"
git push "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"
