#!/bin/bash
set -ev # Exit with nonzero exit code if anything fails

echo "cloning"
git clone https://github.com/SenHeng/FrontEndSeed.git -b gh-pages dist

echo "build"
yarn run build
cd dist

git config user.name "Travis CI"
git config user.email "sen@legendofcode.com"

echo "git add"
git add .
echo "git commit"
git commit -m "test: travis gh deploy"
echo "git push"
git push "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"
