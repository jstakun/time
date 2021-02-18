#if [ -z ${TOKEN_FILE+x} ]; then
#  TOKEN_FILE="/var/run/secrets/kubernetes.io/serviceaccount/token"
#fi

#if [ -z ${CA_FILE+x} ]; then
#  CA_FILE="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
#fi

if [ -z ${TOKEN+x} ]; then 
  echo "TOKEN environment variable is not set";
  if [ ${TOKEN_FILE} ] && [ -f "${TOKEN_FILE}" ]; then
     TOKEN=`cat $TOKEN_FILE`
  else 
     echo "Token file in not present"
  fi 
fi

if [ -z ${TOKEN+x} ] || [ -z ${KUBERNETES_SERVICE_HOST+x} ] || [ -z ${KUBERNETES_SERVICE_PORT+x} ] || [ -z ${CA_FILE+x} ]; then
  echo "Skipping oc login"
else
  echo "oc login --token=$TOKEN https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT --certificate-authority=$CA_FILE"
  oc login --token=$TOKEN https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT --certificate-authority=$CA_FILE
fi

echo Running as $(oc whoami)

DB_NS=landmarks
DB_POD=$(oc get pods -n $DB_NS | grep landmarksdb | awk '{print $1}') && echo Connecting pod $DB_POD in namespace $DB_NS 
oc exec -i $DB_POD -- /bin/bash -s <<EOF
#!/bin/bash
psql -d landmarksdb -c "SELECT date_trunc('day', update_date) AS Day, count(*) AS Devices from device where update_date > now() - interval '1 months' group by 1 order by 1 desc" > /tmp/db;
cat /tmp/db
rm /tmp/db
EOF
oc exec -i $DB_POD -- /bin/bash -s <<EOF
#!/bin/bash
psql -d landmarksdb -c "SELECT date_trunc('day', creation_date) AS Day, count(*) AS Landmarks from landmark where creation_date > now() - interval '1 months' group by 1 order by 1 desc" > /tmp/db;
cat /tmp/db
rm /tmp/db
EOF
oc exec $DB_POD -- bash -c 'psql -d landmarksdb -c "select (select count(*) from landmark) as landmark, (select count(*) from token) as token, (select count(*) from device) as device, (select count(*) from geocode) as geocode, (select count(*) from checkin) as checkin, (select count(*) from notification) as notification, (select count(*) from screenshot) as screenshot, (select count(*) from gmsworld_user) as gmsworld_user, (select count(*) from routes) as routes, (select count(*) from comment) as comment, (select count(*) from layer) as layer";'

echo Done
