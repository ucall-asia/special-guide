#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh

#database details
database_username=fusionpbx
if [ .$database_password = .'random' ]; then
	database_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
fi

#allow the script to use the new password
export PGPASSWORD=$database_password

#update the database password
sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '$database_password';"
sudo -u postgres psql -c "ALTER USER freeswitch WITH PASSWORD '$database_password';"

#install the database backup
# cp backup/fusionpbx-backup /etc/cron.daily
# cp backup/fusionpbx-maintenance /etc/cron.daily
# chmod 755 /etc/cron.daily/fusionpbx-backup
# chmod 755 /etc/cron.daily/fusionpbx-maintenance
# sed -i "s/zzz/$database_password/g" /etc/cron.daily/fusionpbx-backup
# sed -i "s/zzz/$database_password/g" /etc/cron.daily/fusionpbx-maintenance

#add the config.conf
mkdir -p /etc/fusionpbx
cp config.conf /etc/fusionpbx
sed -i /etc/fusionpbx/config.conf -e s:"{database_host}:$database_host:"
sed -i /etc/fusionpbx/config.conf -e s:"{database_name}:$database_name:"
sed -i /etc/fusionpbx/config.conf -e s:"{database_username}:$database_username:"
sed -i /etc/fusionpbx/config.conf -e s:"{database_password}:$database_password:"
