#!/bin/bash

# Database credentials
user="testuser"
password="passtest123"
host="9.9.9.9"
db_name="awesome_database"

# Path and name
backup_path="/home/backup"
date=$(date +"%d-%b-%Yh%H%M")

# Set default file permissions
umask 177

# Dump database into SQL file
mysqldump --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql

# Delete files older than 30 days
find $backup_path/* -mtime +30 -exec rm {} \;

#send files to dropbox
curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer awesometoken123_" \
    --header "Dropbox-API-Arg: {\"path\": \""$backup_path/$db_name-$date.sql"\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary $backup_path/$db_name-$date.sql