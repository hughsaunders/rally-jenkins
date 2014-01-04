#!/bin/bash -xe
cd /home/stack/devstack
. functions;
. .stackenv;
. stackrc
. lib/rpc_backend

echo_summary(){ echo $@; }

old_ip=$HOST_IP
new_ip=$(ip a l dev eth0 |awk '/inet /{print $2}'|cut -d/ -f1)

# Fix config files
grep -rFl $old_ip /etc .stackenv |while read file; do
    sed -i -e 's/'$old_ip'/'$new_ip'/g' $file;
done
. openrc admin

# Fix database
cp ~stack/.my.cnf ~

mysqldump --events -A > dump.sql
sed -e "s/$old_ip/$new_ip/g" <dump.sql |mysql

# Fix rabbit
cleanup_rpc_backend
pkill -f rabbit
install_rpc_backend
restart_rpc_backend
