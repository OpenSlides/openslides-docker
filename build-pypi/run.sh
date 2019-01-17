#!/bin/bash

rm -rf openslides
git clone -b $BRANCH $REPOSITORY_URL openslides
cd openslides
git reset --hard $COMMIT_HASH
rm -rf git

cd client
npm install
./node_modules/@angular/cli/bin/ng build --prod
cd ..

sed -i "s/DEBUG = %(debug)s/DEBUG = True/" openslides/utils/settings.py.tpl

python setup.py sdist
cd ..
sudo cp openslides/dist/* /app/build
sudo chown -R $NEWUID /app/build
