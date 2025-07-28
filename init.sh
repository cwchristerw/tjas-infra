#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    exit 1
fi

echo "
==============================

PVJJK 1.VOS TJAS - Infra
Init Script

------------------------------
"

stop () {

echo "
==============================
"

exit 1

}

apt update
apt-get install -y python3-pip python3-venv jq git curl lsb-release

mkdir -p ~/.ssh/keys/pvjjk-1vos-tjas &> /dev/null
if [[ ! -f ~/.ssh/keys/pvjjk-1vos-tjas/infra ]]
then
    ssh-keygen -f ~/.ssh/keys/pvjjk-1vos-tjas/infra -t ed25519 -N ''
fi

python3 -m venv ~/.venv/ansible
~/.venv/ansible/bin/pip3 install cryptography dnspython hvac jmespath netaddr pexpect
~/.venv/ansible/bin/pip3 install ansible

~/.venv/ansible/bin/ansible-galaxy collection install ansible.posix containers.podman --upgrade

~/.venv/ansible/bin/ansible-pull -U ssh://git@github.com/cwchristerw/tjas-infra -d ~/.ansible/pull/pvjjk-1vos-tjas/infra --accept-host-key --private-key ~/.ssh/keys/pvjjk-1vos-tjas/infra --vault-password-file ~/.ansible/vault/pvjjk-1vos-tjas tasks.yml -t installer

echo "
==============================
"
