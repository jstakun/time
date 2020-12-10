#!/bin/bash
cd /opt/backup
export DUMP_FILE=pg-backup_`date +%Y%m%d_%H%M%S`.sql
export PGPASSWORD=$POSTGRES_PASSWORD
export DB_BACKUP_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) 
echo '--- running pg_dump ---'
pg_dump -v -d $POSTGRES_DB -U $POSTGRES_USER -h $POSTGRES_HOST --encoding=UTF-8 > $DUMP_FILE
echo '--- running bzip2 ---'
bzip2 $DUMP_FILE
echo '--- running mcrypt ---'
mcrypt ${DUMP_FILE}.bz2 -k $DB_BACKUP_PASSWORD
echo 'Passphrase:' $DB_BACKUP_PASSWORD
echo '--- running aws s3 ---'
aws s3 cp ${DUMP_FILE}.bz2.nc $S3_BACKUP_PATH/$DUMP_FILE.bz2.nc
echo 
if [ -z "$ADMIN_EMAIL" ]
then
   echo "--- SES notification not sent ---"
else
   echo "--- Sending SES notification ---"
   aws ses send-email \
     --from "$ADMIN_EMAIL" \
     --destination "ToAddresses=$ADMIN_EMAIL" \
     --message "Subject={Data=Daily backup confirmation,Charset=utf8},Body={Text={Data=$DUMP_FILE.bz2.nc passphrase is $DB_BACKUP_PASSWORD\nhttps://s3.console.aws.amazon.com/s3/buckets/,Charset=utf8},Html={Data=$DUMP_FILE.bz2.nc passphrase is $DB_BACKUP_PASSWORD<br/>https://s3.console.aws.amazon.com/s3/buckets/,Charset=utf8}}" \
     --region "$AWS_DEFAULT_REGION"   
fi
