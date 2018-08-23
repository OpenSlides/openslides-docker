#!/bin/bash
shopt -s extglob 

sleep 25

while true
do
    if [ "$REMOTE_MODE" == "SLAVE" ]; then
        echo "Start backing up static files from https://$REMOTE_HOST"
        wget --quiet --http-password=$REMOTE_PASS --http-user=$REMOTE_USER -nH https://$REMOTE_HOST/static-backup/backup.zip
        echo "Done Downloading - Start copying"
        rm -rf static/*
        unzip backup.zip -d tmp
        mkdir -p static
        mkdir -p static/var
        mv tmp/static/var/* static/var
        rm -rf backup.zip
        rm -rf tmp
        chown openslides -R static
        echo "Backup Done - Sleeping for 5m"
    fi;
    if [ "$REMOTE_MODE" == "MASTER" ]; then
        echo "Start backing up static files"
	zip -r backup.zip static/var/*
        mkdir -p static/backup
        mv backup.zip static/backup
        echo "Backup Done - Sleeping for 5m"
    fi;
    sleep 600
done
