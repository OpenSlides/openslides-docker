#!/bin/bash

rm -rf openslides
git clone -b $BRANCH $REPOSITORY_URL openslides
cd openslides
git reset --hard $COMMIT_HASH
rm -rf git

~/.yarn/bin/yarn --non-interactive
node_modules/.bin/gulp --production

python setup.py sdist
cd ..
sudo cp openslides/dist/* /app/build
sudo chown -R $NEWUID /app/build
