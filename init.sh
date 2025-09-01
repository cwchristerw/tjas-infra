#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    exit 1
fi

underline=`tput smul`
nounderline=`tput rmul`
bold=$(tput bold)
normal=$(tput sgr0)

ti-header(){
    echo ${bold}$1${normal}
}

echo "${bold}"
echo "
 .-') _               ('-.      .-')
(  OO) )             ( OO ).-. ( OO ).
/     '._      ,--.  / . --. /(_)---\_)
|'--...__) .-')| ,|  | \-.  \ /    _ |
'--.  .--'( OO |(_|.-'-'  |  |\  :\` \`.
   |  |   | \`-'|  | \| |_.'  | '..\`''.)
   |  |   ,--. |  |  |  .-.  |.-._)   \\
   |  |   |  '-'  /  |  | |  |\       /
   \`--'    \`-----'   \`--' \`--' \`-----'
"
echo "
PVJJK 1.VOS NIINISALO
TIETOJÄRJESTELMÄASENTAJIEN INTRA
INIT SCRIPT
"
echo -n "${normal}"

stop () {

exit 1

}

ti-header "Haetaan pakettien tiedot..."
sudo apt update
echo -e "\n\n"

ti-header "Asennetaan PVJJK 1.VOS TJAS Infran riippuvuudet APT-paketinhallinnalla..."
sudo apt-get install -y python3-pip python3-venv jq git curl lsb-release
echo -e "\n\n"

mkdir -p $HOME/.ssh/keys/pvjjk-1vos-niinisalo &> /dev/null
if [[ ! -f $HOME/.ssh/keys/pvjjk-1vos-niinisalo/infra ]]
then
    ti-header "Generoidaan SSH-avain Infra-repon käyttöön..."
    ssh-keygen -f $HOME/.ssh/keys/pvjjk-1vos-niinisalo/infra -t ed25519 -N '' -C $(hostname --fqdn)
    echo -e "\n\n"
fi

ti-header "Luodaan Ansiblelle virtuaalinen ympäristö..."
python3 -m venv $HOME/.venv/ansible
echo -e "\n\n"

ti-header "Asennetaan Ansiblen riippuvuudet..."
$HOME/.venv/ansible/bin/pip3 install cryptography dnspython hvac jmespath netaddr pexpect
echo -e "\n\n"

ti-header "Asennetaan Ansible..."
$HOME/.venv/ansible/bin/pip3 install ansible
echo -e "\n\n"

ti-header "Asennetaan Ansible kokoelmat..."
$HOME/.venv/ansible/bin/ansible-galaxy collection install ansible.posix containers.podman --upgrade
echo -e "\n\n"

ti-header "Lisää SSH-avain Infra-repon käyttöön..."
cat $HOME/.ssh/keys/pvjjk-1vos-niinisalo/infra.pub

echo -n "Onko avain lisätty Github-repoon? [K/E]"
while [[ -z $SSHKEY_QUESTION || ! -z $SSHKEY_QUESTION && $SSHKEY_QUESTION != "K" ]]
do
    read SSHKEY_QUESTION
done
echo -e "\n\n"

mkdir -p $HOME/.ansible/vault &> /dev/null
if [[ ! -f $HOME/.ansible/vault/pvjjk-1vos-niinisalo ]]
then
    ti-header "Syötä Ansible Vaultin salasana..."
    echo -n "Salasana: "
    while [[ -z $VAULT_PASSWORD ]]
    do
        read VAULT_PASSWORD

        if [[ ! -z $VAULT_PASSWORD ]]
        then
            echo "$VAULT_PASSWORD" > $HOME/.ansible/vault/pvjjk-1vos-niinisalo
        fi
    done
    echo -e "\n\n"
fi

ti-header "Suoritetaan Infran asennus..."
$HOME/.venv/ansible/bin/ansible-pull -U ssh://git@github.com/cwchristerw/tjas-infra -d $HOME/.ansible/pull/pvjjk-1vos-niinisalo/infra --accept-host-key --private-key $HOME/.ssh/keys/pvjjk-1vos-niinisalo/infra --vault-password-file $HOME/.ansible/vault/pvjjk-1vos-niinisalo tasks.yml -t installer
echo -e "\n\n"

echo "
==============================
"
