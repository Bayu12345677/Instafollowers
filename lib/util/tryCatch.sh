#!/bin/bash

Namespace.self: util/tryCatch
{
	set -o pipefail
	shopt -s expand_aliases
	declare -ig __insideTryCatch__=0
	__shell_opts=$-
	# system try
	system.try(){
		[[ "$__insideTryCatch__" -gt 0 ]] || __shell_opts=$(echo $- | sed 's/[is]//g'); __insideTryCatch__+=1; set +e
	}

	# system clean
	system.clean(){
		local exitcod=$?

		exit $exitcod
	};
	# system get last exception
	excep.getlast(){
		echo "${BASH_SOURCE[2]}#./\n${BASH_LINENO[0]}"
	};

	excep.ekstrak(){
		local val=$1

		unset __Tryresult__

		if [[ $val -gt 0 ]]; then
			local IFS=$'\n'
			__EXCEPTION__=( $(excep.getlast) )

			local __LINE__=1
			local __SOURCE__=0
		fi; return 0
	};
	
}

alias try='system.try; ( set -e; true;'
alias catch='); declare __Tryresult__=$?; __insideTryCatch__+=-1; [[ $__insideTryCatch__ -lt 1 ]] || set -${__shell_opts:-e} && excep.ekstrak $__Tryresult__ || '
