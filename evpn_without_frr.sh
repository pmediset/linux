#!/bin/bash

declare IN_GATEWAY=192.46.209.220
declare IN_APP_VM1=172.104.206.7
declare IN_APP_VM2=172.104.206.12
declare US_GATEWAY=45.79.220.46
declare US_APP_VM1=45.79.220.146
declare US_APP_VM2=45.33.102.99
declare EU_GATEWAY=212.111.41.138
declare EU_APP_VM1=212.111.41.160
declare EU_APP_VM2=212.111.41.218
declare AP_GATEWAY=192.46.225.120
declare AP_APP_VM1=139.162.38.180
declare AP_APP_VM2=139.162.38.218

ETH0_IP=$(ip -br add show dev eth0 | awk {'print $3'} | sed 's/\/.*//g')

case $ETH0_IP in
$IN_GATEWAY)
hostnamectl set-hostname in-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


ip link add vxlan1222 type vxlan id 1222 local $IN_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
ip link set vxlan1222 up
ip link add br0 type bridge
ip link set vxlan1222 master br0
ip link set eth1 master br0
ip=$(ip -br addr dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br0
ip link set br0 up


;;
$US_GATEWAY)
hostnamectl set-hostname us-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


ip link add vxlan1222 type vxlan id 1222 local $US_GATEWAY remote $IN_GATEWAY dstport 4789 dev eth0
ip link add vxlan1223 type vxlan id 1222 local $US_GATEWAY remote $EU_GATEWAY dstport 4789 dev eth0
ip link add vxlan1224 type vxlan id 1222 local $US_GATEWAY remote $AP_GATEWAY dstport 4789 dev eth0
ip link set vxlan1222 up
ip link set vxlan1223 up
ip link set vxlan1224 up
ip link add br0 type bridge
ip link set vxlan1222 master br0
ip link set vxlan1223 master br0
ip link set vxlan1224 master br0
ip link set eth1 master br0
ip=$(ip -br addr dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br0
ip link set br0 up

;;
$EU_GATEWAY)
hostnamectl set-hostname eu-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


ip link add vxlan1222 type vxlan id 1222 local $EU_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
ip link set vxlan1222 up
ip link add br0 type bridge
ip link set vxlan1222 master br0
ip link set eth1 master br0
ip=$(ip -br addr dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br0
ip link set br0 up

;;
$AP_GATEWAY)
hostnamectl set-hostname ap-gateway 
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump -y


ip link add vxlan1222 type vxlan id 1222 local $AP_GATEWAY remote $US_GATEWAY dstport 4789 dev eth0
ip link set vxlan1222 up
ip link add br0 type bridge
ip link set vxlan1222 master br0
ip link set eth1 master br0
ip=$(ip -br addr dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br0
ip link set br0 up


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





