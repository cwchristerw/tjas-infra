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
