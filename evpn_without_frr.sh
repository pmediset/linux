#!/bin/bash

declare IN_GATEWAY=139.144.7.119
declare IN_APP_VM1=139.144.7.135
declare IN_APP_VM2=139.144.7.233
declare US_GATEWAY=74.207.224.155
declare US_APP_VM1=74.207.224.185
declare US_APP_VM2=74.207.224.208
declare EU_GATEWAY=178.79.145.102
declare EU_APP_VM1=178.79.145.103
declare EU_APP_VM2=178.79.145.132
declare AP_GATEWAY=139.162.13.43
declare AP_APP_VM1=172.104.44.16
declare AP_APP_VM2=172.104.44.41

ETH0_IP=$(ip -br add show dev eth0 | awk {'print $3'} | sed 's/\/.*//g')

case $ETH0_IP in
$IN_GATEWAY)
hostnamectl set-hostname in-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


# ip link add vxlan1222 type vxlan id 1222 local $IN_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
# ip link set vxlan1222 up
# ip link add br0 type bridge
# ip link set vxlan1222 master br0
# ip link set eth1 master br0
# ip=$(ip -br addr show dev eth1 | awk {'print $3'})
# ip addr del $ip dev eth1
# ip addr add $ip dev br0
# ip link set br0 up


;;
$US_GATEWAY)
hostnamectl set-hostname us-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


# ip link add vxlan1222 type vxlan id 1222 local $US_GATEWAY remote $IN_GATEWAY dstport 4789 dev eth0
# ip link add vxlan1223 type vxlan id 1223 local $US_GATEWAY remote $EU_GATEWAY dstport 4789 dev eth0
# ip link add vxlan1224 type vxlan id 1224 local $US_GATEWAY remote $AP_GATEWAY dstport 4789 dev eth0
# ip link set vxlan1222 up
# ip link set vxlan1223 up
# ip link set vxlan1224 up
# ip link add br0 type bridge
# ip link set vxlan1222 master br0
# ip link set vxlan1223 master br0
# ip link set vxlan1224 master br0
# ip link set eth1 master br0
# ip=$(ip -br addr show dev eth1 | awk {'print $3'})
# ip addr del $ip dev eth1
# ip addr add $ip dev br0
# ip link set br0 up

;;
$EU_GATEWAY)
hostnamectl set-hostname eu-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


# ip link add vxlan1222 type vxlan id 1222 local $EU_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
# ip link set vxlan1222 up
# ip link add br0 type bridge
# ip link set vxlan1222 master br0
# ip link set eth1 master br0
# ip=$(ip -br addr show dev eth1 | awk {'print $3'})
# ip addr del $ip dev eth1
# ip addr add $ip dev br0
# ip link set br0 up

;;
$AP_GATEWAY)
hostnamectl set-hostname ap-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


# ip link add vxlan1222 type vxlan id 1222 local $AP_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
# ip link set vxlan1222 up
# ip link add br0 type bridge
# ip link set vxlan1222 master br0
# ip link set eth1 master br0
# ip=$(ip -br addr show dev eth1 | awk {'print $3'})
# ip addr del $ip dev eth1
# ip addr add $ip dev br0
# ip link set br0 up


;;

$IN_APP_VM1)
hostnamectl set-hostname in-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$IN_APP_VM2)
hostnamectl set-hostname in-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$US_APP_VM1)
hostnamectl set-hostname us-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$US_APP_VM2)
hostnamectl set-hostname us-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$EU_APP_VM1)
hostnamectl set-hostname eu-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$EU_APP_VM2)
hostnamectl set-hostname eu-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$AP_APP_VM1)
hostnamectl set-hostname ap-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;
$AP_APP_VM2)
hostnamectl set-hostname ap-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y
;;

esac





