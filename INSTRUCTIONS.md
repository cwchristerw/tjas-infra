# Tietojärjestelmäasentajien Infra
## PVJJK 1.VOS Niinisalo
### Ylläpitäjän ohjeet

**Palvelimen asennus**
1. Asenna Debian-käyttöjärjestelmä
2. Asenna curl-paketti käyttämällä APT-paketinhallintaa – `apt update && apt install curl`
3. Lataa ja suorita Init.sh skripti – `bash <(curl https://raw.githubusercontent.com/cwchristerw/tjas-infra/refs/heads/master/init.sh)`

**Verkkolaitteiden konfigurointi**
1. Kytke verkkolaitteen Console (Ethernet) porttiin serial portti adapteri sekä yhdistä siihen serial portti USB-adapteri
2. Liitä USB-adapteri kiinni palvelimeen
3. Testaa/Muodosta yhteys verkkolaitteeseen, käyttäen picocom-komentoa esim. "picocom -b 9600 /dev/ttyUSB0"

r1.net.tjas
```
!
version 12.4
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname r1.net.tjas
!
boot-start-marker
boot-end-marker
!
enable secret 5 $1$G8oa$toAwtS1iMWnV5PGXYc4qM/
enable password ********
!
no aaa new-model
!
resource policy
!
memory-size iomem 5
ip subnet-zero
!
!
ip cef
!
!
!
!
!
!
interface FastEthernet0/0
 ip address dhcp
 no ip redirects
 no ip unreachables
 no ip proxy-arp
 ip nat outside
 duplex full
 speed auto
 no mop enabled
!
interface FastEthernet0/1
 no ip address
 duplex auto
 speed auto
!
interface FastEthernet0/1.10
 description "TINU - INTERNET"
 encapsulation dot1Q 10
 ip address 192.168.1.1 255.255.255.224
 ip access-group 10 out
 ip helper-address 192.168.2.10
 ip nat inside
 no snmp trap link-status
!
interface FastEthernet0/1.20
 description "JUVA - INTRA"
 encapsulation dot1Q 20
 ip address 192.168.2.1 255.255.255.224
 ip access-group 20 out
 ip helper-address 192.168.2.10
 ip nat inside
 no snmp trap link-status
!
interface FastEthernet0/1.30
 description "AITO - TOIMISTO"
 encapsulation dot1Q 30
 ip address 192.168.3.1 255.255.255.224
 ip access-group 30 out
 ip helper-address 192.168.2.10
 ip nat inside
 no snmp trap link-status
!
interface FastEthernet0/1.69
 description "SIVE - HALLINTA"
 encapsulation dot1Q 69
 ip address 192.168.69.1 255.255.255.192
 ip access-group 69 in
 ip access-group 69 out
 ip helper-address 192.168.69.20
 no snmp trap link-status
!
interface GigabitEthernet0/0/0
 no ip address
 shutdown
 negotiation auto
!
ip classless
!
ip http server
ip nat inside source list 1 interface FastEthernet0/0 overload
!
access-list 1 permit 192.168.1.0 0.0.0.31
access-list 1 permit 192.168.2.0 0.0.0.31
access-list 1 permit 192.168.3.0 0.0.0.31
access-list 10 deny   192.168.0.0 0.0.255.255
access-list 10 permit any
access-list 20 permit 192.168.2.0 0.0.0.31
access-list 20 deny   192.168.0.0 0.0.255.255
access-list 20 permit any
access-list 30 permit 192.168.2.10
access-list 30 permit 192.168.3.0 0.0.0.31
access-list 30 deny   192.168.0.0 0.0.255.255
access-list 30 permit any
access-list 69 permit 192.168.69.0 0.0.0.63
!
control-plane
!
banner motd ^C



  .-') _               ('-.      .-')
 (  OO) )             ( OO ).-. ( OO ).
 /     '._      ,--.  / . --. /(_)---\_)
 |'--...__) .-')| ,|  | \-.  \ /    _ |
 '--.  .--'( OO |(_|.-'-'  |  |\  :` `.
    |  |   | `-'|  | \| |_.'  | '..`''.)
    |  |   ,--. |  |  |  .-.  |.-._)   \
    |  |   |  '-'  /  |  | |  |\       /
    `--'    `-----'   `--' `--' `-----'


 PVJJK 1.VOS NIINISALO
 r1.net.tjas

^C
!
line con 0
line aux 0
line vty 0 4
 password ********
 login
!
scheduler allocate 20000 1000
!
end
```

s1.net.tjas
```
hostname "s1.net.tjas"
ip default-gateway 192.168.1.1
snmp-server community "public" Unrestricted
vlan 1
   name "DEFAULT_VLAN"
   untagged 4-52
   ip address dhcp-bootp
   no untagged 1-3
   exit
vlan 10
   name "TINU"
   ip address 192.168.1.2 255.255.255.224
   tagged 1
   exit
vlan 20
   name "JUVA"
   no ip address
   tagged 1-2
   exit
vlan 30
   name "AITO"
   no ip address
   tagged 1,3
   exit
vlan 69
   name "SIVE"
   ip address 192.168.69.11 255.255.255.192
   tagged 1-3
   exit
ip authorized-managers 192.168.69.20 255.255.255.255
banner motd "


  .-') _               ('-.      .-')
 (  OO) )             ( OO ).-. ( OO ).
 /     '._      ,--.  / . --. /(_)---\_)
 |'--...__) .-')| ,|  | \-.  \ /    _ |
 '--.  .--'( OO |(_|.-'-'  |  |\  :` `.
    |  |   | `-'|  | \| |_.'  | '..`''.)
    |  |   ,--. |  |  |  .-.  |.-._)   \
    |  |   |  '-'  /  |  | |  |\       /
    `--'    `-----'   `--' `--' `-----'


 PVJJK 1.VOS NIINISALO
 s1.net.tjas

"
ip ssh
password manager
```

s2.net.tjas
```
hostname "s2.net.tjas"
interface 3
   disable
exit
interface 4
   disable
exit
interface 5
   disable
exit
interface 6
   disable
exit
interface 7
   disable
exit
interface 8
   disable
exit
interface 9
   disable
exit
interface 10
   disable
exit
interface 11
   disable
exit
interface 12
   disable
exit
interface 13
   disable
exit
interface 14
   disable
exit
interface 15
   disable
exit
interface 16
   disable
exit
interface 17
   disable
exit
interface 18
   disable
exit
interface 19
   disable
exit
interface 20
   disable
exit
interface 21
   disable
exit
interface 22
   disable
exit
interface 23
   disable
exit
interface 24
   disable
exit
ip default-gateway 192.168.2.1
snmp-server community "public" Unrestricted
vlan 1
   name "DEFAULT_VLAN"
   untagged 3-28
   ip address dhcp-bootp
   no untagged 1-2
   exit
vlan 20
   name "JUVA"
   untagged 3-24
   ip address 192.168.2.2 255.255.255.224
   tagged 1-2
   exit
vlan 69
   name "SIVE"
   ip address 192.168.69.12 255.255.255.192
   tagged 1-2
   exit
ip authorized-managers 192.168.69.20
banner motd "


  .-') _               ('-.      .-')
 (  OO) )             ( OO ).-. ( OO ).
 /     '._      ,--.  / . --. /(_)---\_)
 |'--...__) .-')| ,|  | \-.  \ /    _ |
 '--.  .--'( OO |(_|.-'-'  |  |\  :` `.
    |  |   | `-'|  | \| |_.'  | '..`''.)
    |  |   ,--. |  |  |  .-.  |.-._)   \
    |  |   |  '-'  /  |  | |  |\       /
    `--'    `-----'   `--' `--' `-----'


 PVJJK 1.VOS NIINISALO
 s2.net.tjas

"
ip ssh
password manager
```

s3.net.tjas
```
hostname "s3.net.tjas"
interface 2
   disable
exit
interface 3
   disable
exit
interface 4
   disable
exit
interface 5
   disable
exit
interface 6
   disable
exit
interface 7
   disable
exit
interface 8
   disable
exit
interface 9
   disable
exit
interface 10
   disable
exit
interface 11
   disable
exit
interface 12
   disable
exit
ip default-gateway 192.168.3.1
snmp-server community "public" Unrestricted
vlan 1
   name "DEFAULT_VLAN"
   untagged 25-28
   ip address dhcp-bootp
   no untagged 1-24
   exit
vlan 30
   name "AITO"
   untagged 13-24
   ip address 192.168.3.2 255.255.255.224
   tagged 1
   exit
vlan 69
   name "SIVE"
   untagged 2-24
   ip address 192.168.69.13 255.255.255.192
   tagged 1
   exit
ip authorized-managers 192.168.69.20
banner motd "


  .-') _               ('-.      .-')
 (  OO) )             ( OO ).-. ( OO ).
 /     '._      ,--.  / . --. /(_)---\_)
 |'--...__) .-')| ,|  | \-.  \ /    _ |
 '--.  .--'( OO |(_|.-'-'  |  |\  :` `.
    |  |   | `-'|  | \| |_.'  | '..`''.)
    |  |   ,--. |  |  |  .-.  |.-._)   \
    |  |   |  '-'  /  |  | |  |\       /
    `--'    `-----'   `--' `--' `-----'


 PVJJK 1.VOS NIINISALO
 s3.net.tjas

"
ip ssh
password manager
```

# LÄHTEET

## ISSUE - ASCII ART
ASCII Art Generator
https://www.textmods.com/ascii-art
