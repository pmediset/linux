#!/bin/bash

declare IN_GATEWAY=
declare IN_APP_VM1=
declare IN_APP_VM2=
declare US_GATEWAY=
declare US_APP_VM1=
declare US_APP_VM2=
declare EU_GATEWAY=
declare EU_APP_VM1=
declare EU_APP_VM2=
declare AP_GATEWAY=
declare AP_APP_VM1=
declare AP_APP_VM2=

ETH0_IP=$(ip -br add show dev eth0 | awk {'print $3'} | sed 's/\/.*//g')

case $ETH0_IP in
$IN_GATEWAY)
hostnamectl set-hostname in-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet frr most neofetch traceroute mtr nmap tcpdump apache2 -y
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons

ip route add $US_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $EU_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $AP_GATEWAY via $(ip route show default | awk {'print $3'})

cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname in-gateway
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65000
 bgp router-id $IN_GATEWAY
 no bgp ebgp-requires-policy
 neighbor $US_GATEWAY remote-as 65000
 neighbor $EU_GATEWAY remote-as 65000
 neighbor $AP_GATEWAY remote-as 65000
 !
 address-family l2vpn evpn
  neighbor $US_GATEWAY activate
  neighbor $EU_GATEWAY activate
  neighbor $AP_GATEWAY activate
  advertise-all-vni
 exit-address-family
exit
!
end
END
ip link add vxlan1 type vxlan id 100 dstport 4789
ip link add br1 type bridge
ip link set  vxlan1 master br1
ip link set  eth1 master br1
ip link set vxlan1 up
ip link set br1 up
ip=$(ip -br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
systemctl restart frr

;;
$US_GATEWAY)
hostnamectl set-hostname us-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet frr most neofetch traceroute mtr nmap tcpdump apache2 -y
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons

ip route add $IN_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $EU_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $AP_GATEWAY via $(ip route show default | awk {'print $3'})

cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname us-gateway
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65000
 bgp router-id $US_GATEWAY
 no bgp ebgp-requires-policy
 neighbor $IN_GATEWAY remote-as 65000
 neighbor $EU_GATEWAY remote-as 65000
 neighbor $AP_GATEWAY remote-as 65000
 !
 address-family l2vpn evpn
  neighbor $IN_GATEWAY activate
  neighbor $EU_GATEWAY activate
  neighbor $AP_GATEWAY activate
  advertise-all-vni
 exit-address-family
exit
!
end
END
ip link add vxlan1 type vxlan id 100 dstport 4789
ip link add br1 type bridge
ip link set  vxlan1 master br1
ip link set  eth1 master br1
ip link set vxlan1 up
ip link set br1 up
systemctl restart frr
;;
$EU_GATEWAY)
hostnamectl set-hostname eu-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet frr most neofetch traceroute mtr nmap tcpdump apache2 -y
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons

ip route add $US_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $IN_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $AP_GATEWAY via $(ip route show default | awk {'print $3'})

cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname eu-gateway
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65000
 bgp router-id $EU_GATEWAY
 no bgp ebgp-requires-policy
 neighbor $US_GATEWAY remote-as 65000
 neighbor $IN_GATEWAY remote-as 65000
 neighbor $AP_GATEWAY remote-as 65000
 !
 address-family l2vpn evpn
  neighbor $US_GATEWAY activate
  neighbor $IN_GATEWAY activate
  neighbor $AP_GATEWAY activate
  advertise-all-vni
 exit-address-family
exit
!
end
END
ip link add vxlan1 type vxlan id 100 dstport 4789
ip link add br1 type bridge
ip link set  vxlan1 master br1
ip link set  eth1 master br1
ip link set vxlan1 up
ip link set br1 up
systemctl restart frr

;;
$AP_GATEWAY)
hostnamectl set-hostname ap-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet frr most neofetch traceroute mtr nmap tcpdump apache2 -y
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons

ip route add $US_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $EU_GATEWAY via $(ip route show default | awk {'print $3'})
ip route add $IN_GATEWAY via $(ip route show default | awk {'print $3'})

cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname ap-gateway
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65000
 bgp router-id $AP_GATEWAY
 no bgp ebgp-requires-policy
 neighbor $US_GATEWAY remote-as 65000
 neighbor $EU_GATEWAY remote-as 65000
 neighbor $IN_GATEWAY remote-as 65000
 !
 address-family l2vpn evpn
  neighbor $US_GATEWAY activate
  neighbor $EU_GATEWAY activate
  neighbor $IN_GATEWAY activate
  advertise-all-vni
 exit-address-family
exit
!
end
END
ip link add vxlan1 type vxlan id 100 dstport 4789
ip link add br1 type bridge
ip link set  vxlan1 master br1
ip link set  eth1 master br1
ip link set vxlan1 up
ip link set br1 up
systemctl restart frr
;;

$IN_APP_VM1)
hostnamectl set-hostname in-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$IN_APP_VM2)
hostnamectl set-hostname in-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$US_APP_VM1)
hostnamectl set-hostname us-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$US_APP_VM2)
hostnamectl set-hostname us-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$EU_APP_VM1)
hostnamectl set-hostname eu-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$EU_APP_VM2)
hostnamectl set-hostname eu-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$AP_APP_VM1)
hostnamectl set-hostname ap-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;
$AP_APP_VM2)
hostnamectl set-hostname ap-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump apache2 -y
;;

esac





