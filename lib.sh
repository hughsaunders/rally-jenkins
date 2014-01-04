#!/bin/bash -xe
setup(){
    mkdir ../logs
    virtualenv ../.venv
    source ../.venv/bin/activate
    export PIP_ALLOW_EXTERNAL=netaddr
    export PIP_ALLOW_UNVERIFIED=netaddr

    pip install --upgrade setuptools
    pip install --upgrade pip
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
    shift
    ansible-playbook bootstrap.yml -i inventory-local/ -e region=LON -e buildid="$BUILD_TAG" -e keypair=jenkins -vvvv --private-key=id_jenkins -t $TAGS $@
}
# Run integration tests
setup_ansible(){
    pip install ansible pyrax rackspace-novaclient
    cp -r ~jenkins/jobscripts/* .
    sed -i -e 's+ansible_python_interpreter=+ansible_python_interpreter='$VIRTUAL_ENV/bin/python'+' inventory-local/hosts
}
integration_tests(){
    run_playbook launch,deploy,rally
    run_playbook launch,destroy
}
