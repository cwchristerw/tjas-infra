#!/bin/bash

underline=`tput smul`
nounderline=`tput rmul`
bold=$(tput bold)
normal=$(tput sgr0)

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
TIETOJÄRJESTELMÄASENTAJIEN INFRA
PROTECT SCRIPT
"
echo -n "${normal}"
action=$1

encrypt() {
    execute "ansible-vault encrypt --vault-id infra@vault/infra"
}

decrypt() {
    execute "ansible-vault decrypt --vault-id infra@vault/infra"
}

list() {
    i=0
    for file in inventories/hosts.yml inventories/host_vars/*;
    do
        i=$((i + 1))
        echo $i")"$file
    done
}

execute() {
i=0
for file in inventories/hosts.yml inventories/host_vars/*;
    do
        i=$((i + 1))
        echo $i")"$file
        $1 $file
    done
}


case $action in
    encrypt)
        echo "${underline}Encrypting...${nounderline}"
        encrypt
        ;;
    decrypt)
        echo "${underline}Decrypting...${nounderline}"
        decrypt
        ;;
    list)
        echo "${underline}Listing...${nounderline}"
        list
        ;;
    *)
        echo "${underline}HELP${nounderline}"
        echo "encrypt - Encrypt Files"
        echo "decrypt - Decrypt Files"
        echo "list - List Files"
        ;;
esac

echo -e "\n\n\n"
