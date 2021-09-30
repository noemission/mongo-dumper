#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo "Dumping the database..."

CURRENT_TIME=`date +"%Y-%m-%d_%T"`
BACKUP_FILE="${MONGO_DB_NAME}_${CURRENT_TIME}.gz"

mongodump --host $MONGO_HOST --port $MONGO_PORT -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase admin --db $MONGO_DB_NAME --forceTableScan --gzip --archive=${BACKUP_FILE}

echo "Dumping finised. Starting upload..."

aws s3 mv $BACKUP_FILE "s3://${S3_BUCKET}/"

echo "Upload finised."
