Nmap
Scan Port 80 in CIDR 24

nmap -Pn -p80 -oG  IP/24

Scan all Hosts of net with CIDR 24 for OS detection

nmap -T4 -A -v IP/24
