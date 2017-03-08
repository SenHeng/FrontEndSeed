#!/bin/bash
set -ev # Exit with nonzero exit code if anything fails

# Deploy only on PRs of the master branch
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
  echo "Skip deploy; just make sure it builds"
  yarn run build
  exit 0
fi

# Save useful info for re-use
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages branch into the dist folder
yarn run setupGhPages

# Run the build script
yarn run build
cd dist

# Exit if the built output is unchanged
if [ -z `git diff --exit-code` ]; then
  echo "No changes to build, exiting."
  exit 0
fi

# Commit contents in dist folder to gh-pages
git config user.name "Travis CI"
git config user.email "sen@legendofcode.com"
git add .
git commit -m "Deploy to GitHub Pages: ${SHA}"
git push "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"
