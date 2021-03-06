#!/bin/bash -xe
source lib.sh
setup
setup_ansible
run_playbook launch,devstack

# take image of instance post devstack, store uuid.
source novarc
instance_name="$BUILD_TAG-openstack"
nova image-create $instance_name $instance_name --poll
image_id=$(nova image-list |awk '/'$instance_name'/{print $2}')
echo $image_id > ~/jobscripts/devstack_image_id

# Delete old images created by this job
nova image-list |awk '/'$image_id'/{next}; /'$JOB_NAME'/{print $2}'|while read iid; do
    nova image-delete $iid
done

run_playbook launch,destroy
