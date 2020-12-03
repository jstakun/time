#!/bin/bash
cd /opt/backup
export DUMP_FILE=pg-backup_`date +%Y%m%d_%H%M%S`.sql
export PGPASSWORD=$POSTGRES_PASSWORD 
echo 'pg_dump'
pg_dump -v -d $POSTGRES_DB -U $POSTGRES_USER -h $POSTGRES_HOST --encoding=UTF-8 > $DUMP_FILE
echo 'bzip2'
bzip2 $DUMP_FILE
echo 'mcrypt'
mcrypt ${DUMP_FILE}.bz2 -k $DB_BACKUP_PASSWORD
echo 'aws s3'
aws s3 cp ${DUMP_FILE}.bz2.nc $S3_BACKUP_PATH/$DUMP_FILE.bz2.nc
