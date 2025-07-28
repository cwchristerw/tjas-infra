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

echo "Haetaan pakettien tiedot..."
apt update
echo "\n\n"

echo "Asennetaan PVJJK 1.VOS TJAS Infran riippuvuudet APT-paketinhallinnalla..."
apt-get install -y python3-pip python3-venv jq git curl lsb-release
echo "\n\n"

mkdir -p ~/.ssh/keys/pvjjk-1vos-tjas &> /dev/null
if [[ ! -f ~/.ssh/keys/pvjjk-1vos-tjas/infra ]]
then
    echo "Generoidaan SSH-avain Infra-repon käyttöön..."
    ssh-keygen -f ~/.ssh/keys/pvjjk-1vos-tjas/infra -t ed25519 -N ''
    echo "\n\n"
fi

echo "Luodaan Ansiblelle virtuaalinen ympäristö..."
python3 -m venv ~/.venv/ansible
echo "\n\n"

echo "Asennetaan Ansiblen riippuvuudet..."
~/.venv/ansible/bin/pip3 install cryptography dnspython hvac jmespath netaddr pexpect
echo "\n\n"

echo "Asennetaan Ansible..."
~/.venv/ansible/bin/pip3 install ansible
echo "\n\n"

echo "Asennetaan Ansible kokoelmat..."
~/.venv/ansible/bin/ansible-galaxy collection install ansible.posix containers.podman --upgrade

cat ~/.ssh/keys/pvjjk-1vos-tjas/infra

echo "Suoritetaan Infran asennus..."
~/.venv/ansible/bin/ansible-pull -U ssh://git@github.com/cwchristerw/tjas-infra -d ~/.ansible/pull/pvjjk-1vos-tjas/infra --accept-host-key --private-key ~/.ssh/keys/pvjjk-1vos-tjas/infra --vault-password-file ~/.ansible/vault/pvjjk-1vos-tjas tasks.yml -t installer

echo "
==============================
"
