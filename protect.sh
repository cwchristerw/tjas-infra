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
PVJJK 1.VOS NIINISALO
TIETOJÄRJESTELMÄASENTAJIEN INTRA
PROTECT SCRIPT
"
echo -n "${normal}"
action=$1

encrypt() {
    execute "ansible-vault encrypt --vault-id $1@vault/$1" $1
}

decrypt() {
    execute "ansible-vault decrypt --vault-id $1@vault/$1" $1
}

list() {
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
        echo "${underline}Encrypting...${nounderline}"
        encrypt pvjjk-1vos-niinisalo
        ;;
    decrypt)
        echo "${underline}Decrypting...${nounderline}"
        decrypt pvjjk-1vos-niinisalo
        ;;
    list)
        echo "${underline}Listing...${nounderline}"
        list pvjjk-1vos-niinisalo
        ;;
    *)
        echo "${underline}HELP${nounderline}"
        echo "encrypt - Encrypt Files"
        echo "decrypt - Decrypt Files"
        echo "list - List Files"
        ;;
esac

echo -e "\n\n\n"
