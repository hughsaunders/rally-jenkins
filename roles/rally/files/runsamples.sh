#!/bin/bash
iid=$(nova image-list |awk '$4 ~ /precise/{print $2}')
did=$(openstack-rally deployment list|awk '/dummy/{print $2}'|tail -n1)
die(){ echo $@; exit 1; }
for task in doc/samples/tasks/nova/*; do
    tmptask=/tmp/$(basename $task)
    jq '.[][]["args"]["image_id"]="'$iid'"|.[][]["args"]["flavor_id"]=10' <$task >$tmptask
    openstack-rally --verbose task start --deploy-id="$did" --task=$tmptask
    tuuid=$(openstack-rally task list |awk '$2 ~ /-/{tuuid=$2}; END{print tuuid}')
    openstack-rally task results $tuuid |jq . || die "invalid jason returned by $task: $(cat $tmptask)"
    openstack-rally task detailed $tuuid | grep finished || die "Task failed: $task: $(cat $tmptask)"
done
