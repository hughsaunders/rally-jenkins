#!/bin/bash

openstack-rally task list| while read tuuid; do
    openstack-rally task results |jq . #will fail on invalid json
    openstack-rally task detailed | grep finished
done
