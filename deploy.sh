#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

# Pull requests and commits shouldn't try to deploy.
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
  echo "Skip deploy; just building."
  yarn run build
  exit 0
fi

# Save useful info for re-use
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`
echo "${REPO}, ${SSH_REPO}, ${SHA}"

# Clone the existing gh-pages for this repo into dist/
# Create a new empty branch if gh-pages doesn't exist yet
git clone $REPO dist
cd dist
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Clean out existing contents
echo "Clean out existing contents"
rm -rf dist/**/* || exit 0

# Run the build script
echo "Compiling"
yarn run build

# Commit the dist folder to gh-pages
cd dist
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# If there are no changes to the compiled folder, exit.
# if [ -z `git diff --exit-code` ]; then
#   echo "No changes to build, exiting."
#   exit 0
# fi

# Commit changes.
GIT_STATUS=`git status`
echo "git status: ${GIT_STATUS}"
ls

git add .
git commit -m "Deploy to GitHub Pages: ${SHA}"
echo "committing ${SHA}" 


# Get the deploy key
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ../deploy_key.enc -out ../deploy_key -d
chmod 600 ../deploy_key
eval `ssh-agent -s`
echo "ssh step"
ssh-add ../deploy_key
echo "label: ${ENCRYPTION_LABEL}, iv: ${ENCRYPTED_IV}, ley: ${ENCRYPTED_KEY}"

# Push to GitHub
git push $SSH_REPO $TARGET_BRANCH
echo "pushed to ${SSH_REPO} ${TARGET_BRANCH}"
