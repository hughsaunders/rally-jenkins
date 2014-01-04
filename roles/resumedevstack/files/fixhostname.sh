#!/bin/bash -xe
cd /home/stack/devstack
source .stackenv;
old_ip=$HOST_IP; echo $old_ip >/tmp/old
new_ip=$(ip a l dev eth0 |awk '/inet /{print $2}'|cut -d/ -f1); echo $new_ip > /tmp/new

# Fix config files
grep -rFl $old_ip /etc .stackenv |while read file; do
    sed -i -e 's/'$old_ip'/'$new_ip'/g' $file;
done

# Fix database
su stack -c 'msqldump --events -A|sed -e "s/$(cat /tmp/old)/$(cat /tmp/new)/g"|mysql'

# Fix rabbit
source stackrc; source openrc admin; source lib/rpc_backend; cleanup_rpc_backend; install_rpc_backend; restart_rpc_backend
