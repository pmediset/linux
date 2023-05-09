#!/bin/bash

cloud_to_onprem1=194.195.211.178
ap_west_gtw=172.232.75.115
ca_central_gtw=172.105.20.114
ap_southeast_gtw=143.42.45.111
us_southeast_gtw=170.187.201.11
us_east_gtw=50.116.61.186
eu_west_gtw=176.58.119.16
ap_south_gtw=139.162.21.17
eu_central_gtw=194.233.172.112
ap_west_app=172.232.75.102
ca_central_app=170.187.192.197
ap_southeast_app=143.42.45.113
us_southeast_app=45.79.208.94
us_east_app=69.164.222.13
eu_west_app=109.74.196.118
ap_south_app=139.162.33.107
eu_central_app=194.233.172.154

eth0_ip=$(ip -br add show dev eth0 | awk {'print $3'} | sed 's/\/.*//g')
default_gw=$(ip route show default | awk {'print $3'})
case $eth0_ip in
$ap_west_gtw)
hostnamectl set-hostname $( echo ap_west_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$ca_central_gtw)
hostnamectl set-hostname $( echo ca_central_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$ap_southeast_gtw)
hostnamectl set-hostname $( echo ap_southeast_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$us_southeast_gtw)
hostnamectl set-hostname $( echo us_southeast_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$eu_west_gtw)
hostnamectl set-hostname $( echo eu_west_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$ap_south_gtw)
hostnamectl set-hostname $( echo ap_south_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$eu_central_gtw)
hostnamectl set-hostname $( echo eu_central_gtw | sed 's/_/-/g')
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
ip link add br1 type bridge
ip link add vni1 type vxlan local $eth0_ip dstport 4789 id 1 nolearning
ip link set vni1 master br1 addrgenmode none
ip link set vni1 type bridge_slave neigh_suppress on learning off
ip link set vni1 up
ip link set br1 up
cat >/etc/frr/frr.conf<<END
frr version 8.4.2
frr defaults traditional
hostname cloud-to-onprem1
log syslog informational
vni 100
no ipv6 forwarding
service integrated-vtysh-config
!
router bgp 65550
 bgp router-id $eth0_ip
 no bgp ebgp-requires-policy
 no bgp hard-administrative-reset
 no bgp graceful-restart notification
 neighbor ibgp_mesh peer-group
 neighbor ibgp_mesh remote-as 65550
 neighbor ibgp_mesh update-source $eth0_ip
 neighbor ibgp_mesh capability extended-nexthop
END
for i in cloud_to_onprem1 ap_west_gtw ca_central_gtw ap_southeast_gtw us_southeast_gtw us_east_gtw eu_west_gtw ap_south_gtw eu_central_gtw
do if [[ $i != $(hostname | sed 's/-/_/g') ]] ; then ip route add ${!i} via $default_gw; 
printf " neighbor ${!i} peer-group ibgp_mesh\n bgp listen range ${!i}/32 peer-group ibgp_mesh\n" >> /etc/frr/frr.conf
fi ; done
cat >>/etc/frr/frr.conf<<END
 !
 address-family l2vpn evpn
  neighbor ibgp_mesh activate
  advertise-all-vni
 exit-address-family
exit
END
ip=$(ip --br addr show dev eth1 | awk {'print $3'})
ip addr del $ip dev eth1
ip addr add $ip dev br1
;;
$ap_west_app)
hostnamectl set-hostname $( echo ap_west_app | sed 's/_/-/g')
;;
$ca_central_app)
hostnamectl set-hostname $( echo ca_central_app | sed 's/_/-/g')
;;
$ap_southeast_app)
hostnamectl set-hostname $( echo ap_southeast_app | sed 's/_/-/g')
;;
$us_southeast_app)
hostnamectl set-hostname $( echo us_southeast_app | sed 's/_/-/g')
;;
$eu_west_app)
hostnamectl set-hostname $( echo eu_west_app | sed 's/_/-/g')
;;
$ap_south_app)
hostnamectl set-hostname $( echo ap_south_app | sed 's/_/-/g')
;;
$eu_central_app)
hostnamectl set-hostname $( echo eu_central_app | sed 's/_/-/g')
;;

esac 