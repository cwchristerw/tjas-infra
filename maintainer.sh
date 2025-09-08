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
TIETOJÄRJESTELMÄASENTAJIEN INTRA
MAINTAINER SCRIPT
"
echo -n "${normal}"

echo "${bold}PowerDNS Authorative - MySQL Schema${normal}"
echo "Downloading..."
curl https://raw.githubusercontent.com/PowerDNS/pdns/refs/heads/master/modules/gmysqlbackend/schema.mysql.sql -o "$PWD/files/powerdns-authorative/schema.mysql.sql" -s

echo -e "\n\n\n"
