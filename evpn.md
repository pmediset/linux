for i in "in-gateway 1" "in-app-vm1 11" "in-app-vm2 12" ; do 
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region ap-west \
  --type g6-standard-1 \
  --label  ${i% *} \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.${i#* }/24"
done


for i in "us-gateway 2" "us-app-vm1 21" "us-app-vm2 22" ; do 
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region us-southeast \
  --type g6-standard-1 \
  --label  ${i% *} \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.${i#* }/24"
done

for i in "eu-gateway 3" "eu-app-vm1 31" "eu-app-vm2 32" ; do 
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region eu-west \
  --type g6-standard-1 \
  --label  ${i% *} \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.${i#* }/24"
done


for i in "ap-gateway 4" "ap-app-vm1 41" "ap-app-vm2 42" ; do 
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region ap-south \
  --type g6-standard-1 \
  --label  ${i% *} \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.${i#* }/24"
done


step1: (update evpn.sh)
lll | ip_filter

lll | ip_filter| sed 's/.*/lil &/g' | ntab; exit

git clone git@github.com:pmediset/linux.git 
bash ./linux/evpn.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cat ./linux/zshrc >>~/.zshrc; source ~/.zshrc

fping -ag -c1 172.22.1.0/26  |& grep min




