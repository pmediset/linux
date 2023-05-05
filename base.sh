linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region us-southeast \
  --type g6-standard-1 \
  --label  america2 \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" 

linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region ap-west \
  --type g6-standard-1 \
  --label  india2 \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM"


git clone git@github.com:pmediset/linux.git 
bash ./linux/debian.sh
hostnamectl hostname india

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cat ./linux/zshrc >>~/.zshrc; source ~/.zshrc





ip link add vxlan1 type vxlan id 1 local 172.232.83.17 remote 45.79.208.27 dstport 4789 dev eth0 
ip link set vxlan1 up
ip addr add 1.1.1.1/24 dev vxlan1

ip link add gre1 type gre local 172.232.83.17 remote 45.79.208.27
ip link set gre1 up
ip addr add 2.2.2.1/24 dev gre1

ip link add ipip1 type ipip local 172.232.83.17 remote 45.79.208.27
ip link set ipip1 up
ip addr add 3.3.3.1/24 dev ipip1


ip link add vxlan1 type vxlan id 1 local 45.79.208.27 remote 172.232.83.17 dstport 4789 dev eth0 
ip link set dev vxlan1 up
ip addr add 1.1.1.2/24 dev vxlan1


ip link add gre1 type gre local 45.79.208.27 remote 172.232.83.17
ip link set gre1 up
ip addr add 2.2.2.2/24 dev gre1

ip link add ipip1 type ipip local 45.79.208.27 remote 172.232.83.17
ip link set ipip1 up
ip addr add 3.3.3.2/24 dev ipip1



sed -i 's/ospf=no/ospf=yes/g' /etc/frr/daemons
