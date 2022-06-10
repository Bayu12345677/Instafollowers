#!/bin/bash

ll_ij="\e[92m"
ll_bi="\e[94m"
ll_me="\e[91m"
ll_ku="\e[94m"
ll_cy="\e[96m"
ll_st="\e[00m"
sys::@file(){
	local __ll__str_arg="$(pwd)/lib/$1"

#    local patch__ll__=$( cd "$(pwd)/${BASH_SOURCE[0]%/*}" )

#	if [[ ! -f "${__ll__str_arg}" ]]; then
#	   echo "[**] Sepertinya tidak ada module $1"
#	   exit 1
#	 fi
   for file in $(echo "$__ll__str_arg" | sed -e 's/.sh/''/g'); do
     if [[ ! -f "${file}.sh" ]]; then
        echo "[**] Sepertinya tidak ada module $@"
        exit 2
    fi
       file=$(echo "${file}.sh")
#	 source "$file" "$@">/dev/null 2>&1 || {
#	 	echo -e "[**] Error\n\t<Source Not found>\n\t<Source no indetifikasi>\n[ErrorSource]> sepertinya library tidak cocok dengan bash"
##	 	exit 44
#	 }
	 builtin source "$file" "$@"
  done
	 __ll__str_arg=(${__ll__str_arg})
}

shopt -s expand_aliases
#trap "Exception::err;echo;echo;/data/data/com.termux/files/usr/libexec/termux/command-not-found \"$1\"" ERR

#if [[ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]]; then
@system::require(){
	local file_patch="$1"

	if [[ -d "$file_patch" ]]; then
	    if [[ ${reloading} != true ]] && [[ ! -z "${file_patch}" ]] && builtin source "$file_patch" || { echo "Nothing"; exit 5; }; then
	       return 2
	    fi
	  else
	      source $(pwd)/${file_patch}
	   fi
}
#fi

system::import(){
	for libPatch in "$@"; do
	   sys::@file "$libPatch"
	done
    	
}

system::handle(){
	local handlePatch
	for handlePatch in "$@"; do
	    sys::@file "$handlePatch"
	done
}

system.url(){
	local url="$1"
	if [[ -z "$url" ]]; then
		echo -e "\e[93m[\e[91m•\e[92m•\e[93m]\e[0m url not found"
		exit 23
	fi; 
		if (type -a curl &> /dev/null); then
			builtin source <(curl -sL --retry 3 --fail --url "$url") || { __e__="cannot import $url"; throw; }
		else
			builtin wget <(wget -t 3 -O - -o /dev/null "$url") || { __e__="connot import $url"; throw; }
		fi
}

system.call(){
        declare -g func=${1}
        declare -g option=${2}
        declare -g param=${@:3}

        #regex_param=$(echo "$param"|sed 's;(; ;g'|sed 's;";'';g'|sed 's;);'';g')

        if [[ "$option" == "->" ]]; then
                eval "${func} ${param}"
        else
                return 1
        fi
}

throw(){ eval 'echo -e "\e[96m[\e[91m•\e[92m•\e[96m]\e[00m $(cat <<< $__e__)"; read -s'; }

Namespace.self:(){ :; }
alias Bash.import:="system::import"
alias @require="reloading=true @system::require"
alias begin:="{"
alias __bash__="};"
alias DEBUG=": #"
alias DEBUG=": "
alias %%="#"
alias @import="system::handle"
alias Bash::url="system.url"
alias call:-="system.call"
