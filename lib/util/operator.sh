@import text_display/IO.ECHO text_display/colorama
@import util/IO.SYSTEM.log util/IO.TYPE
@import util/IO.FUNC
# author : polygon

system.ambil(){
	local __opsi__="$2"
	local __params__="$3"

	if [[ "$__opsi__" == "in" ]]; then
		dummy=
	else
		println_err " File ${BASH_SOURCE[1]} Line ${BASH_LINENO[0]}"
		println_err " into ${2}"
		println_err " not defined"; exit 2
	fi

	if [[ -z "$(@return: $1)" ]]; then
		println_err " File ${BASH_SOURCE[1]} Line ${BASH_LINENO[0]}"
		println_err " ${1} not defined"
		exit 2
	fi

	if [[ -z "$__params__" ]]; then
		println_err " not found"
		println_err " Line ${BASH_LINENO[0]}"
		exit 2
	fi

	if [[ -z $(echo "$(@return: $1)" | grep -o "$3") ]]; then
	    return 10
	else
		return 0
	fi
}

sys.return()
{
	global: __text__ = "$@"

	var __testing__ : "${text:-None}"
	var __subject__ : "${__text__}"
}

shopt -s expand_aliases
alias @return="sys.return"
alias ambil:="system.ambil"
