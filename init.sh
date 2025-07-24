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

mkdir -p ~/.ssh/keys/pvjjk-1vos-tjas &> /dev/null
if [[ ! -f ~/.ssh/keys/pvjjk-1vos-tjas/infra ]]
then
    ssh-keygen -f ~/.ssh/keys/pvjjk-1vos-tjas/infra -t ed25519 -N '' &> /dev/null
fi

python3 -m venv ~/.venv/ansible &> /dev/null
~/.venv/ansible/bin/pip3 install cryptography dnspython hvac jmespath netaddr pexpect &> /dev/null
~/.venv/ansible/bin/pip3 install ansible &> /dev/null

~/.venv/ansible/bin/ansible-galaxy collection install ansible.posix containers.podman --upgrade &> /dev/null

~/.venv/ansible/bin/ansible-pull -U ssh://git@github.com/cwchristerw/tjas-infra -d ~/.ansible/pull/pvjjk-1vos-tjas/infra --accept-host-key --private-key ~/.ssh/keys/pvjjk-1vos-tjas/infra --vault-password-file ~/.ansible/vault/pvjjk-1vos-tjas.yml tasks.yml -t installer

echo "
==============================
"
