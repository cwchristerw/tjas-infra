#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    exit 1
fi

ti-header(){
    echo $(tput bold)$1$(tput sgr0)
}

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

ti-header "Haetaan pakettien tiedot..."
apt update
echo -e "\n\n"

ti-header "Asennetaan PVJJK 1.VOS TJAS Infran riippuvuudet APT-paketinhallinnalla..."
apt-get install -y python3-pip python3-venv jq git curl lsb-release
echo -e "\n\n"

mkdir -p ~/.ssh/keys/pvjjk-1vos-tjas &> /dev/null
if [[ ! -f ~/.ssh/keys/pvjjk-1vos-tjas/infra ]]
then
    ti-header "Generoidaan SSH-avain Infra-repon käyttöön..."
    ssh-keygen -f ~/.ssh/keys/pvjjk-1vos-tjas/infra -t ed25519 -N '' -C $(hostname --fqdn)
    echo -e "\n\n"
fi

ti-header "Luodaan Ansiblelle virtuaalinen ympäristö..."
python3 -m venv ~/.venv/ansible
echo -e "\n\n"

ti-header "Asennetaan Ansiblen riippuvuudet..."
~/.venv/ansible/bin/pip3 install cryptography dnspython hvac jmespath netaddr pexpect
echo -e "\n\n"

ti-header "Asennetaan Ansible..."
~/.venv/ansible/bin/pip3 install ansible
echo -e "\n\n"

ti-header "Asennetaan Ansible kokoelmat..."
~/.venv/ansible/bin/ansible-galaxy collection install ansible.posix containers.podman --upgrade
echo -e "\n\n"

ti-header "Näytetään SSH-avain Infra-repon käyttöön..."
cat ~/.ssh/keys/pvjjk-1vos-tjas/infra.pub
echo -e "\n\n"

if [[ ! -f ~/.ansible/vault/pvjjk-1vos-tjas ]]
then
    ti-header "Syötä Ansible Vaultin salasana..."
    echo -n "Salasana: "
    read VAULT_PASSWORD
    echo -e "\n\n"

    if [[ ! -z $VAULT_PASSWORD ]]
    then
        echo "$VAULT_PASSWORD" > ~/.ansible/vault/pvjjk-1vos-tjas
    fi
fi

ti-header "Suoritetaan Infran asennus..."
~/.venv/ansible/bin/ansible-pull -U ssh://git@github.com/cwchristerw/tjas-infra -d ~/.ansible/pull/pvjjk-1vos-tjas/infra --accept-host-key --private-key ~/.ssh/keys/pvjjk-1vos-tjas/infra --vault-password-file ~/.ansible/vault/pvjjk-1vos-tjas tasks.yml -t installer
echo -e "\n\n"

echo "
==============================
"
