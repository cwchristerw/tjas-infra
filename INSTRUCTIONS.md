#Tietojärjestelmäasentajien Infra
## PVJJK 1.VOS TJAS - Infra
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
 ip address 192.168.0.1 255.255.255.0
 duplex auto
 speed auto
!
interface FastEthernet0/1.10
 encapsulation dot1Q 10
 ip address 192.168.1.1 255.255.255.0
 ip helper-address 192.168.2.10
 no snmp trap link-status
!
interface FastEthernet0/1.20
 encapsulation dot1Q 20
 ip address 192.168.2.1 255.255.255.0
 ip helper-address 192.168.2.10
 no snmp trap link-status
!
interface FastEthernet0/1.30
 encapsulation dot1Q 30
 ip address 192.168.3.1 255.255.255.0
 ip helper-address 192.168.2.10
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
!
access-list 1 permit 192.168.0.0
access-list 1 permit 192.168.1.0
access-list 1 permit 192.168.2.0
access-list 1 permit 192.168.3.0
access-list 1 deny   any
!
control-plane
!
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
   ip address dhcp-bootp
   exit
vlan 10
   name "VLAN10"
   ip address 192.168.1.2 255.255.255.0
   tagged 1
   exit
vlan 20
   name "VLAN20"
   ip address 192.168.2.2 255.255.255.0
   tagged 1-2
   exit
vlan 30
   name "VLAN30"
   ip address 192.168.3.2 255.255.255.0
   tagged 1,3
   exit
ip authorized-managers 192.168.2.10 255.255.255.255
ip ssh
password manager
```

s2.net.tjas
```
; J9085A Configuration Editor; Created on release #R.11.30

hostname "s2.net.tjas"
ip routing
snmp-server community "public" Unrestricted
vlan 1
   name "DEFAULT_VLAN"
   untagged 1,25-28
   ip address dhcp-bootp
   no untagged 2-24
   exit
vlan 20
   name "VLAN20"
   untagged 2-24
   ip address 192.168.2.3 255.255.255.0
   ip helper-address 192.168.2.10
   tagged 1
   exit
ip authorized-managers 192.168.2.10 255.255.255.255
ip ssh
password manager
```

s3.net.tjas
```
; J9085A Configuration Editor; Created on release #R.11.22

hostname "s3.net.tjas"
snmp-server community "public" Unrestricted
vlan 1
   name "DEFAULT_VLAN"
   untagged 1,25-28
   ip address dhcp-bootp
   no untagged 2-24
   exit
vlan 30
   name "VLAN30"
   untagged 2-24
   ip address 192.168.3.3 255.255.255.0
   tagged 1
   exit
ip authorized-managers 192.168.2.10
ip ssh
password manager
```
