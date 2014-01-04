#!/bin/bash -xe
setup(){
    mkdir ../logs
    export PIP_ALLOW_EXTERNAL=netaddr
    export PIP_ALLOW_UNVERIFIED=netaddr
}

# Run unit tests
unit_tests(){
    pushd ..
    pip install --upgrade tox
    tox
    popd
}

run_playbook(){
    TAGS=$1
    ansible-playbook bootstrap.yml -i inventory-local/ -e region=LON -e buildid="$BUILD_TAG" -e keypair=jenkins -vvvv --private-key=id_jenkins -t $TAGS
}
# Run integration tests
setup_ansible(){
    virtualenv ../.venv
    source ../.venv/bin/activate
    pip install --upgrade setuptools
    pip install --upgrade pip
    pip install ansible pyrax rackspace-novaclient
    cp -r ~jenkins/jobscripts/* .
    sed -i -e 's+ansible_python_interpreter=+ansible_python_interpreter='$VIRTUAL_ENV/bin/python'+' inventory-local/hosts
}
integration_tests(){
    run_playbook launch,deploy,rally
    run_playbook launch,destroy
}
