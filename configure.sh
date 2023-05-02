#!/bin/bash

declare IN_RTR1_PUBLIC="139.162.61.12"
declare IN_RTR2_PUBLIC="139.162.22.234"
declare IN_APP1_PUBLIC="139.162.14.19"
declare IN_APP2_PUBLIC="139.162.16.122"
declare IN_APP3_PUBLIC="139.162.28.118"
declare US_RTR1_PUBLIC="172.104.24.176"
declare US_RTR2_PUBLIC="172.104.24.233"
declare US_APP1_PUBLIC="172.104.24.182"
declare US_APP2_PUBLIC="45.79.181.23"
declare US_APP3_PUBLIC="45.79.181.34"


declare ONPREM_FW1="72.247.47.16" # fw-clientlab4600.145bw.neteng.akamai.com IND .1 US .9
declare ONPREM_FW2="72.247.47.21" # fw-clientlab1500.145bw.neteng.akamai.com IND .5 US .13
ETH0_IP=$(ip -br add show dev eth0 | awk {'print $3'} | sed 's/\/.*//g')
ETH1_IP=$(ip -br add show dev eth1 | awk {'print $3'} | sed 's/\/.*//g')


case $ETH0_IP in

$IN_RTR1_PUBLIC)
hostnamectl set-hostname in-router1
apt-get update
apt-get install iftop nload tree keepalived strongswan fping zsh wireguard-tools telnet frr most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
#configure VRRP on eth1
cat >/etc/keepalived/keepalived.conf<<END
vrrp_instance VRRP {
        state MASTER
        interface eth1
        virtual_router_id 100
        priority 200
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass foobar
        }
        virtual_ipaddress {
              $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1/24
        }
}
END
systemctl restart keepalived
#configure ike and ipsec 
cat >/etc/ipsec.secrets<<END
$ETH0_IP $ONPREM_FW1 : PSK foobar
END
cat > /etc/strongswan.conf<<END
charon {
    load_modular = yes
        interfaces_use = eth0
        install_routes = 0
    plugins {
        include strongswan.d/charon/*.conf
    }
}
END

cat >/etc/ipsec.conf<<END
conn to_onprem
  type=tunnel
  left=$ETH0_IP
  leftsubnet=0.0.0.0/0
  leftid=$ETH0_IP
  right=$ONPREM_FW1
  rightsubnet=0.0.0.0/0
  rightid=$ONPREM_FW1
  authby=secret
  mark=100
  ike=aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes256-aes128-sha256-sha1-modp2048-modp4096-modp1024,aes256-sha1-modp1024,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16-aes256gcm12-aes128gcm16-aes128gcm12-sha256-sha1-modp2048-modp4096-modp1024,3des-sha1-modp1024!
  esp=aes128-aes256-sha1-sha256-modp2048-modp4096-modp1024,aes128-sha1,aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes128gcm12-aes128gcm16-aes256gcm12-aes256gcm16-modp2048-modp4096-modp1024,aes128gcm16,aes128gcm16-ecp256,aes256-sha1,aes256-sha256,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16,aes256gcm16-ecp384,3des-sha1!
  keyexchange=ikev2
  auto=start
END

ip link add name vti1 type vti key 100 local $ETH0_IP remote $ONPREM_FW1
ip link set vti1 up
ip addr add 100.100.100.1/30 dev vti1
sysctl -w net.ipv4.conf.vti1.disable_policy=1
sysctl -w net.ipv4.ip_forward=1
ipsec reload; ipsec restart
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
cat >/etc/frr/frr.conf<<END
frr version 8.1
frr defaults traditional
hostname in-router1
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id 1.1.1.1
 no bgp ebgp-requires-policy
 neighbor 100.100.100.2 remote-as 65535
 neighbor 100.100.100.2 ebgp-multihop 255
 neighbor 172.22.1.3 remote-as 65550
 !
 address-family ipv4 unicast
  network 172.22.1.0/24
  neighbor 100.100.100.2 route-map rmap in
  neighbor 172.22.1.3 next-hop-self
 exit-address-family
exit
!
ip prefix-list allow_all_pref seq 10 permit any
!
route-map rmap permit 10
 match ip address prefix-list allow_all_pref
 set local-preference 200
exit
!
END
systemctl restart frr


;; 
$IN_RTR2_PUBLIC)
hostnamectl set-hostname in-router2
apt-get update
apt-get install iftop nload tree keepalived strongswan fping zsh wireguard-tools telnet frr most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
#configure VRRP on eth1
cat >/etc/keepalived/keepalived.conf<<END
vrrp_instance VRRP {
        state BACKUP
        interface eth1
        virtual_router_id 100
        priority 100
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass foobar
        }
        virtual_ipaddress {
              $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1/24
        }
}
END
systemctl restart keepalived
#configure ike and ipsec 
cat >/etc/ipsec.secrets<<END
$ETH0_IP $ONPREM_FW2 : PSK foobar
END
cat > /etc/strongswan.conf<<END
charon {
    load_modular = yes
        interfaces_use = eth0
        install_routes = 0
    plugins {
        include strongswan.d/charon/*.conf
    }
}
END
cat >/etc/ipsec.conf<<END
conn to_onprem
  type=tunnel
  left=$ETH0_IP
  leftsubnet=0.0.0.0/0
  leftid=$ETH0_IP
  right=$ONPREM_FW2
  rightsubnet=0.0.0.0/0
  rightid=$ONPREM_FW2
  authby=secret
  mark=100
  ike=aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes256-aes128-sha256-sha1-modp2048-modp4096-modp1024,aes256-sha1-modp1024,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16-aes256gcm12-aes128gcm16-aes128gcm12-sha256-sha1-modp2048-modp4096-modp1024,3des-sha1-modp1024!
  esp=aes128-aes256-sha1-sha256-modp2048-modp4096-modp1024,aes128-sha1,aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes128gcm12-aes128gcm16-aes256gcm12-aes256gcm16-modp2048-modp4096-modp1024,aes128gcm16,aes128gcm16-ecp256,aes256-sha1,aes256-sha256,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16,aes256gcm16-ecp384,3des-sha1!
  keyexchange=ikev2
  auto=start
END
ip link add name vti1 type vti key 100 local $ETH0_IP remote $ONPREM_FW2
ip link set vti1 up
ip addr add 100.100.100.5/30 dev vti1
sysctl -w net.ipv4.conf.vti1.disable_policy=1
sysctl -w net.ipv4.ip_forward=1
ipsec reload; ipsec restart
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
cat >/etc/frr/frr.conf<<END
frr version 8.1
frr defaults traditional
hostname in-router2
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id 2.2.2.2
 no bgp ebgp-requires-policy
 neighbor 100.100.100.6 remote-as 65535
 neighbor 100.100.100.6 ebgp-multihop 255
 neighbor 172.22.1.2 remote-as 65550
 !
 address-family ipv4 unicast
  network 172.22.1.0/24
  neighbor 172.22.1.2 next-hop-self
 exit-address-family
exit
!
END
systemctl restart frr

;;
$US_RTR1_PUBLIC)
hostnamectl set-hostname us-router1
apt-get update
apt-get install iftop nload tree keepalived strongswan fping zsh wireguard-tools telnet frr most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
#configure VRRP on eth1
cat >/etc/keepalived/keepalived.conf<<END
vrrp_instance VRRP {
        state MASTER
        interface eth1
        virtual_router_id 100
        priority 200
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass foobar
        }
        virtual_ipaddress {
              $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1/24
        }
}
END
systemctl restart keepalived
#configure ike and ipsec 
cat >/etc/ipsec.secrets<<END
$ETH0_IP $ONPREM_FW1 : PSK foobar
END
cat > /etc/strongswan.conf<<END
charon {
    load_modular = yes
        interfaces_use = eth0
        install_routes = 0
    plugins {
        include strongswan.d/charon/*.conf
    }
}
END

#aes-256-cbc
cat >/etc/ipsec.conf<<END
conn to_onprem
  type=tunnel
  left=$ETH0_IP
  leftsubnet=0.0.0.0/0
  leftid=$ETH0_IP
  right=$ONPREM_FW1
  rightsubnet=0.0.0.0/0
  rightid=$ONPREM_FW1
  authby=secret
  mark=100
  ike=aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes256-aes128-sha256-sha1-modp2048-modp4096-modp1024,aes256-sha1-modp1024,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16-aes256gcm12-aes128gcm16-aes128gcm12-sha256-sha1-modp2048-modp4096-modp1024,3des-sha1-modp1024!
  esp=aes128-aes256-sha1-sha256-modp2048-modp4096-modp1024,aes128-sha1,aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes128gcm12-aes128gcm16-aes256gcm12-aes256gcm16-modp2048-modp4096-modp1024,aes128gcm16,aes128gcm16-ecp256,aes256-sha1,aes256-sha256,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16,aes256gcm16-ecp384,3des-sha1!
  keyexchange=ikev2
  auto=start
END



ip link add name vti1 type vti key 100 local $ETH0_IP remote $ONPREM_FW1
ip link set vti1 up
ip addr add 100.100.100.9/30 dev vti1
sysctl -w net.ipv4.conf.vti1.disable_policy=1
sysctl -w net.ipv4.ip_forward=1
ipsec reload; ipsec restart
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
cat >/etc/frr/frr.conf<<END
frr version 8.1
frr defaults traditional
hostname us-router1
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id 3.3.3.3
 no bgp ebgp-requires-policy
 neighbor 100.100.100.10 remote-as 65535
 neighbor 100.100.100.10 ebgp-multihop 255
 neighbor 172.22.2.3 remote-as 65550
 !
 address-family ipv4 unicast
  network 172.22.2.0/24
  neighbor 100.100.100.10 route-map rmap in
  neighbor 172.22.2.3 next-hop-self
 exit-address-family
exit
!
ip prefix-list allow_all_pref seq 10 permit any
!
route-map rmap permit 10
 match ip address prefix-list allow_all_pref
 set local-preference 200
exit
!
END
systemctl restart frr

;; 
$US_RTR2_PUBLIC)
hostnamectl set-hostname us-router2
apt-get update
apt-get install iftop nload tree keepalived strongswan fping zsh wireguard-tools telnet frr most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
#configure VRRP on eth1
cat >/etc/keepalived/keepalived.conf<<END
vrrp_instance VRRP {
        state BACKUP
        interface eth1
        virtual_router_id 100
        priority 100
        advert_int 1
        authentication {
              auth_type PASS
              auth_pass foobar
        }
        virtual_ipaddress {
              $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1/24
        }
}
END
systemctl restart keepalived
#configure ike and ipsec 
cat >/etc/ipsec.secrets<<END
$ETH0_IP $ONPREM_FW2 : PSK foobar
END
cat > /etc/strongswan.conf<<END
charon {
    load_modular = yes
        interfaces_use = eth0
        install_routes = 0
    plugins {
        include strongswan.d/charon/*.conf
    }
}
END
cat >/etc/ipsec.conf<<END
conn to_onprem
  type=tunnel
  left=$ETH0_IP
  leftsubnet=0.0.0.0/0
  leftid=$ETH0_IP
  right=$ONPREM_FW2
  rightsubnet=0.0.0.0/0
  rightid=$ONPREM_FW2
  authby=secret
  mark=100
  ike=aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes256-aes128-sha256-sha1-modp2048-modp4096-modp1024,aes256-sha1-modp1024,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16-aes256gcm12-aes128gcm16-aes128gcm12-sha256-sha1-modp2048-modp4096-modp1024,3des-sha1-modp1024!
  esp=aes128-aes256-sha1-sha256-modp2048-modp4096-modp1024,aes128-sha1,aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes128gcm12-aes128gcm16-aes256gcm12-aes256gcm16-modp2048-modp4096-modp1024,aes128gcm16,aes128gcm16-ecp256,aes256-sha1,aes256-sha256,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16,aes256gcm16-ecp384,3des-sha1!
  keyexchange=ikev2
  auto=start
END
ip link add name vti1 type vti key 100 local $ETH0_IP remote $ONPREM_FW2
ip link set vti1 up
ip addr add 100.100.100.13/30 dev vti1
sysctl -w net.ipv4.conf.vti1.disable_policy=1
sysctl -w net.ipv4.ip_forward=1
ipsec reload; ipsec restart
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
cat >/etc/frr/frr.conf<<END
frr version 8.1
frr defaults traditional
hostname us-router2
log syslog informational
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id 4.4.4.4
 no bgp ebgp-requires-policy
 neighbor 100.100.100.14 remote-as 65535
 neighbor 100.100.100.14 ebgp-multihop 255
 neighbor 172.22.2.2 remote-as 65550
 !
 address-family ipv4 unicast
  network 172.22.2.0/24
  neighbor 172.22.2.2 next-hop-self
 exit-address-family
exit
!
END
systemctl restart frr


;; 


$IN_APP1_PUBLIC)
hostnamectl set-hostname in-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
$IN_APP2_PUBLIC)
hostnamectl set-hostname in-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
$IN_APP3_PUBLIC)
hostnamectl set-hostname in-app-vm3
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
$US_APP1_PUBLIC)
hostnamectl set-hostname us-app-vm1
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
$US_APP2_PUBLIC)
hostnamectl set-hostname us-app-vm2
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
$US_APP3_PUBLIC)
hostnamectl set-hostname us-app-vm3
apt-get update
apt-get install iftop nload tree fping zsh telnet most neofetch traceroute mtr nmap tcpdump sipcalc apache2 -y
echo 200 ext >> /etc/iproute2/rt_tables
ip route add default via $(ip route show default  | awk {'print $3'}) dev eth0 table ext
ip rule add from $ETH0_IP table ext prio 100
ip route del default
ip route add default via $(ip -br addr show dev eth1 | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}").1
;; 
esac



