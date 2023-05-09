alias ipv6_filter='egrep "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"'
alias ip_sort='sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias ip_filter="grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'"
alias ip_range_filter="grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\-[0-9]\{1,3\}'"
alias ip_sub_filter="grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\/..'"
alias gp=gitpush
neofetch
gitpush () {
	git add .
	git commit -m "$*"
	git push
}
export PROMPT='%(!.%{%F{yellow}%}.)$USER@%{$fg[white]%}%M ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
cheat () {
	curl cheat.sh/$1
}
export PAGER=most

latency_test () {
fping -g $1 -c5 |& grep min  | awk {'print $1,$NF'} | sed 's/\// /g' | awk {'print $1,$2'} | sort -k2n | awk {'print $1, "latency:" $2'}
}