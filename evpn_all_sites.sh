
for i in "$(paste <(lin regions ls  --no-truncation | grep Vlans | awk {'print $2'}) <(echo {11..18} | tr ' ' '\n'))"; do echo $i; done | while read reg i; do
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region ${reg} \
  --type g6-standard-1 \
  --label  ${reg/-/_}_gtw \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.$i/24"
sleep 2; done


for i in "$(paste <(lin regions ls  --no-truncation | grep Vlans | awk {'print $2'}) <(echo {21..28} | tr ' ' '\n'))"; do echo $i; done | while read reg i; do
linode-cli linodes create \
  --no-defaults \
  --authorized_users 'itoc-netops' \
  --image linode/ubuntu23.04 \
  --region ${reg} \
  --type g6-standard-1 \
  --label  ${reg/-/_}_app \
  --root_pass 'Ev28CVqaZE7ZUqJbMyGTZkjzE7BwqjrY' \
  --booted true \
  --backups_enabled false \
  --private_ip false \
  --interfaces.purpose "public" --interfaces.label "" --interfaces.ipam_address ""\
  --interfaces.purpose "vlan" --interfaces.label "LINODE-TO-AKAM" --interfaces.ipam_address "172.22.1.$i/24"
sleep 2; done

lll | awk {'print $4, $(NF-1)'} | sed 's/ /=/g'




fping -g 172.22.1.0/26 -c5 |& grep min | sort -k 8