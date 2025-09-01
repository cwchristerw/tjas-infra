#!/bin/bash

underline=`tput smul`
nounderline=`tput rmul`
bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}PVJJK 1.VOS Niinisalo / TJAS Infra / Protect${normal}"
action=$1

encrypt() {
    echo "${underline}Encrypting...${nounderline}"
    execute "ansible-vault encrypt --vault-id $1@vault/$1" $1
}

decrypt() {
    echo "${underline}Decrypting...${nounderline}"
    execute "ansible-vault decrypt --vault-id $1@vault/$1" $1
}

list() {
    echo "${underline}Listing...${nounderline}"
    i=0
    for file in inventories/$1/group_vars/* inventories/$1/host_vars/*;
    do
        i=$((i + 1))
        echo $i")"$file
    done
}

execute() {
i=0
for file in inventories/$2/group_vars/* inventories/$2/host_vars/*;
    do
        i=$((i + 1))
        echo $i")"$file
        $1 $file
    done
}


case $action in
    encrypt)
        encrypt pvjjk-1vos-niinisalo
        ;;
    decrypt)
        decrypt pvjjk-1vos-niinisalo
        ;;
    list)
        list pvjjk-1vos-niinisalo
        ;;
    help)
        echo "encrypt, decrypt, list"
        ;;
    *)
        echo "..."
        ;;
esac
