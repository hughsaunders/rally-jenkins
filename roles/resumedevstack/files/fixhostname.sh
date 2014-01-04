#!/bin/bash -xe
cd /home/stack/devstack
. .stackenv;
. stackrc
. functions;
. lib/rpc_backend

old_ip=$HOST_IP
new_ip=$(ip a l dev eth0 |awk '/inet /{print $2}'|cut -d/ -f1)

# Fix config files
grep -rFl $old_ip /etc .stackenv |while read file; do
    sed -i -e 's/'$old_ip'/'$new_ip'/g' $file;
done
. openrc admin

# Fix database
msqldump -u stack --events -A|sed -e "s/$old_ip/$new_ip/g"|mysql -u stack

# Fix rabbit
cleanup_rpc_backend; install_rpc_backend; restart_rpc_backend
