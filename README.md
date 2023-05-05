# linux
git clone git@github.com:pmediset/linux.git 
bash ./linux/debian.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cat ./linux/zshrc >>~/.zshrc; source ~/.zshrc




ip link add gre1 type gre local  key 100
ip link set gre1 up
ip  addr add 10.10.10.1/24 dev gre1

ip link add DEVICE type vxlan id VNI [ dev PHYS_DEV  ] [ { group | remote } IPADDR ] [ local { IPADDR | any } ] [ ttl TTL ] [ tos TOS ] [ df DF ] [ flowlabel FLOWLABEL ] [ dstport PORT ] [
srcport MIN MAX ] [ [no]learning ] [ [no]proxy ] [ [no]rsc ] [ [no]l2miss ] [ [no]l3miss ] [ [no]udpcsum ] [ [no]udp6zerocsumtx ] [ [no]udp6zerocsumrx ] [ ageing SECONDS ] [ maxaddress NUMBER
] [ [no]external ] [ gbp ] [ gpe ] [ [no]vnifilter ]
[no]learning - specifies if unknown source link layer addresses and IP addresses are entered into the VXLAN device forwarding database.

[no]rsc - specifies if route short circuit is turned on.

[no]proxy - specifies ARP proxy is turned on.

[no]l2miss - specifies if netlink LLADDR miss notifications are generated.

[no]l3miss - specifies if netlink IP ADDR miss notifications are generated.

[no]udpcsum - specifies if UDP checksum is calculated for transmitted packets over IPv4.





ip link del gre1
ip link add gre1 type gre local 45.79.125.31 remote 139.144.56.249 
ip link set gre1 up
ip addr add 10.10.20.1/24 dev gre1

ip link del gre1
ip link add gre1 type gre local 139.144.56.249 remote 45.79.125.31
ip link set gre1 up
ip addr add 10.10.20.2/24 dev gre1



ip link del vxlan1222
ip link add vxlan1222 type vxlan id 1222 local 45.79.125.31 remote 139.144.56.249 dstport 4789 dev eth0
ip link set vxlan1222 up
ip addr add 10.10.10.1/24 dev vxlan1222


ip link del vxlan1222
ip link add vxlan1222 type vxlan id 1222 local 139.144.56.249 remote 45.79.125.31 dstport 4789 dev eth0
ip link set vxlan1222 up
ip addr add 10.10.10.2/24 dev vxlan1222



ip link add br0 type bridge 
ip link set vxlan1222 master br0
ip link set eth1 master br0
ip link set br0 up
