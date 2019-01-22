#!/bin/bash

rm -rf openslides
git clone -b $BRANCH $REPOSITORY_URL openslides
cd openslides
git reset --hard $COMMIT_HASH
rm -rf git

cd client
npm install
npm run build
cd ..

python setup.py sdist
cd ..
sudo cp openslides/dist/* /app/build
sudo chown -R $NEWUID /app/build
