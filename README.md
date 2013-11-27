Large chunks of code "borrowed" from https://github.com/apsu/virtlab.

To deploy an OpenStack + Ceph cluster, create a rax_creds file w/ your Rackspace cloud details and then:

    ansible-playbook bootstrap.yml

Image ID, keypair, network_prefix, etc. can be overriden like:

    ansible-playbook bootstrap.yml -e image_id=<image_id>
