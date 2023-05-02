
in-router1 ->CLB1 (4600)
in-router2 ->CLB2 (1500)
us-router1 ->CLB1 (4600)
us-router2 ->CLB2 (1500)

rlab -v fw-clientlab4600.145bw.neteng.akamai.com
rlab -v fw-clientlab1500.145bw.neteng.akamai.com


show configuration | display set | match SWAN | grep address


replace pattern 172.105.39.234 with 172.232.64.79
replace pattern 170.187.207.91 with 170.187.201.174
replace pattern 45.79.117.132 with 172.232.64.88 
replace pattern 170.187.136.15 with 170.187.201.24