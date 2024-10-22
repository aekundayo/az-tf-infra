#!/bin/bash

# Check for required arguments
# sudo umount /mnt/pg_backup

echo "PG_ACTION VALUE IS: $PG_ACTION"
echo "KV_NAME VALUE IS: $KV_NAME"
logs_path="/mnt/logs"
shared_path="/mnt/dsfileshare"
pg_scripts_path="/opt/pg_scripts"

if [ -d "$logs_path" ]; then
  echo "$logs_path Directory exists."
else
  sudo mkdir -p $logs_path
  sudo chmod 777 $logs_path
fi

if [ -d "$shared_path" ]; then
    echo "$shared_path Directory exists."
else
    sudo mkdir -p $shared_path
    sudo chmod 777 $shared_path
fi

if [ -d "$pg_scripts_path" ]; then
    echo "Directory exists."
else
    sudo mkdir -p $pg_scripts_path
    sudo chmod 777 $pg_scripts_path
fi

sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#install postgres client 14


sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update -y
sudo apt install postgresql-client-14 -y 


sudo apt-get update -y
sudo apt-get install cifs-utils -y




az login --identity --allow-no-subscriptions

STATIC_SHARE_NAME=$(az keyvault secret show --vault-name  $KV_NAME --name staticFileShareName --query value --output tsv || true)
STATIC_STORAGE_KEY=$(az keyvault secret show --vault-name  $KV_NAME --name staticStorageAccKey --query value --output tsv || true)
STATIC_STORE_NAME=$(az keyvault secret show --vault-name  $KV_NAME --name staticStorageAccName --query value --output tsv || true)

if mount | grep $shared_path > /dev/null; then 
    echo "Folder is mounted."
else    
    echo "Folder is not mounted."
    sudo mount -t cifs //$STATIC_STORE_NAME.file.core.windows.net/$STATIC_SHARE_NAME $shared_path -o vers=3.0,username=$STATIC_STORE_NAME,password=$STATIC_STORAGE_KEY,dir_mode=0777,file_mode=0777 
fi

echo "Entering crontab creation sequence for backup/restore script. PG_ACTION is $PG_ACTION"
restore_script_path="$pg_scripts_path/weekly_restore.sh"
backup_script_path="$pg_scripts_path/weekly_backup.sh"


# set the environment restore filename

if [ "$ENV" = "dev" ]; then   
    echo "Environment is dev."
    export RESTORE_PREFIX="test"
elif [ "$ENV" = "test" ]; then
    echo "Environment is test."
    export RESTORE_PREFIX="uat"
elif [ "$ENV" = "uat" ]; then
    echo "Environment is uat."
    export RESTORE_PREFIX="prod"
elif [ "$ENV" = "prod" ]; then
    echo "Environment is prod."
    export RESTORE_PREFIX="prod"
fi

# Write the content into weekly_restore.sh

echo "#!/bin/bash
#test restore script exists if not exit.
if [ -f /mnt/dsfileshare/$RESTORE_PREFIX.backup ]; then
    echo '$RESTORE_PREFIX.backup script exists'
else
    echo '$RESTORE_PREFIX.backup script does not exist'
    exit 1
fi

BACKUP_SIZE=\$(du -sh /mnt/dsfileshare/$RESTORE_PREFIX.backup | cut -f1)
echo \"Script started at \$(date '+%Y-%m-%d %H:%M:%S') Backup Size: \$BACKUP_SIZE\" | tee -a /mnt/logs/$ENV-restore.log
az login --identity --allow-no-subscriptions

export POSTGRES_HOST=\$(az keyvault secret show --vault-name $KV_NAME --name postgresHost --query value --output tsv || true)
export POSTGRES_USER=\$(az keyvault secret show --vault-name $KV_NAME --name postgresUser --query value --output tsv || true) 
export POSTGRES_DB=\$(az keyvault secret show --vault-name $KV_NAME --name showroomDB --query value --output tsv || true)
export POSTGRES_ADMIN_DB=\$(az keyvault secret show --vault-name $KV_NAME --name postgresName --query value --output tsv || true)
export POSTGRES_ADMIN_USER=\$(az keyvault secret show --vault-name $KV_NAME --name postgresAdminUser --query value --output tsv || true)
export POSTGRES_ADMIN_PASSWORD=\$(az keyvault secret show --vault-name $KV_NAME --name postgresAdminPassword --query value --output tsv || true)
export PGPASSWORD=\$(az keyvault secret show --vault-name $KV_NAME --name postgresAdminPassword --query value --output tsv || true)
export POSTGRES_PASSWORD=\$(az keyvault secret show --vault-name $KV_NAME --name postgresPassword --query value --output tsv || true)

psql -h \$POSTGRES_HOST -U \$POSTGRES_ADMIN_USER -d postgres -c \"GRANT pg_signal_backend TO \$POSTGRES_ADMIN_USER;\"
psql -h \$POSTGRES_HOST -U \$POSTGRES_ADMIN_USER -d postgres -c \"DROP DATABASE IF EXISTS \$POSTGRES_DB WITH (FORCE);\"
psql -h \$POSTGRES_HOST -U \$POSTGRES_ADMIN_USER -d postgres -c \"CREATE DATABASE \$POSTGRES_DB;\"
psql -h \$POSTGRES_HOST -U \$POSTGRES_ADMIN_USER -d postgres -c \"CREATE USER \$POSTGRES_USER WITH PASSWORD '\$POSTGRES_PASSWORD';\"
psql -h \$POSTGRES_HOST -U \$POSTGRES_ADMIN_USER -d postgres -c \"GRANT ALL PRIVILEGES ON DATABASE \$POSTGRES_DB TO \$POSTGRES_USER;\"

export PGPASSWORD=\$(az keyvault secret show --vault-name $KV_NAME --name postgresPassword --query value --output tsv || true)

pg_restore -h \$POSTGRES_HOST -U \$POSTGRES_USER -d \$POSTGRES_DB -p 5432 -v /mnt/dsfileshare/$RESTORE_PREFIX.backup | tee -a /mnt/logs/$ENV-restore.log

echo \"Script ended at \$(date '+%Y-%m-%d %H:%M:%S') Backup Size: \$BACKUP_SIZE\" | tee -a /mnt/logs/$ENV-restore.log
rm -rf /mnt/dsfileshare/$RESTORE_PREFIX.backup" | sudo tee "$restore_script_path" || true

# Make the new script executable
sudo chmod 755 "$restore_script_path"


# Write the content into weekly_backup.sh

echo "#!/bin/bash
echo \"Script started at \$(date '+%Y-%m-%d %H:%M:%S')\" | tee -a /mnt/logs/$ENV-backup.log

    az login --identity --allow-no-subscriptions

export POSTGRES_HOST=\$(az keyvault secret show --vault-name $KV_NAME --name postgresHost --query value --output tsv || true)
export POSTGRES_USER=\$(az keyvault secret show --vault-name $KV_NAME --name postgresUser --query value --output tsv || true) 
export POSTGRES_DB=\$(az keyvault secret show --vault-name $KV_NAME --name showroomDB --query value --output tsv || true)
export PGPASSWORD=\$(az keyvault secret show --vault-name $KV_NAME --name postgresPassword --query value --output tsv || true)



pg_dump -h \$POSTGRES_HOST -U \$POSTGRES_USER -d \$POSTGRES_DB -p 5432 -F c -b -v --exclude-table-data=public.log_import -f /mnt/dsfileshare/$ENV.backup | tee -a /mnt/logs/$ENV-backup.log
BACKUP_SIZE=\$(du -sh /mnt/dsfileshare/$ENV.backup)
echo \"Script ended at \$(date '+%Y-%m-%d %H:%M:%S') Backup Size: \$BACKUP_SIZE\" | tee -a /mnt/logs/$ENV-backup.log" | sudo tee "$backup_script_path"

# Make the new script executable
sudo chmod 755 "$backup_script_path"
    


if [ "$PG_ACTION" = "restore" ]; then    
    echo "Creating restore script schedule."
    #RESTORE SCRIPT STARTS HERE
    

     # List the current cron jobs and filter out the ones related to weekly_backup.sh
    sudo crontab -l | grep -v $restore_script_path > tempcron

    # Install the new cron file
    sudo crontab tempcron

    # Remove the temporary cron file
    sudo rm tempcron
    echo "Successfully removed cron entries for weekly_restore.sh."


    # Add a cron job to run weekly_backup.sh every Monday at 3:30 AM
    (crontab -l 2>/dev/null; echo "$RESTORE_SCHEDULE $restore_script_path") | crontab -

else    
    echo "Creating dump script schedule."
    #BACKUP SCRIPT STARTS HERE
    

     # List the current cron jobs and filter out the ones related to weekly_backup.sh
    sudo crontab -l | grep -v $backup_script_path > tempcron

    # Install the new cron files
    sudo crontab tempcron

    # Remove the temporary cron file
    sudo rm tempcron
    echo "Successfully removed cron entries for weekly_backup.sh."

    # Add a cron job to run weekly_backup.sh every Monday at 3:30 AM
    (crontab -l 2>/dev/null; echo "$BACKUP_SCHEDULE  $backup_script_path") | crontab -
fi