#!/bin/bash

sys::valid(){
    if type -a echo>/dev/null 2>&1; then
         return 0
      else
          return 1
    fi
 }

Keyboard::Exit(){
	local status=$?
	
echo "
[**] Error
         <Keyboard stoped>
         <Keyboard Signal Sigint>
         <Keyboadd INT>
         
[Keyboard Exit]
"
exit 1
}

shopt -s expand_aliases

Tulis.strN(){
	{
		printf "${@}${__subject__}"
		echo
	}
};

Tulis.str(){
	{
		printf "${@}${__subject__}"
	}
};

Tulis.length(){
	local jumlah=$(echo "$@" | awk '{print length}')
	echo $((jumlah-1+1))
}

system.char(){
        local __Ascii__="$@"

	[[ -z "$__Ascii__" ]] && read -s __Ascii__
        # system char
        function __char__ {
                local string_ascii="$1";
                for x in $(echo "${string_ascii}"); do
                        awk -v char="$x" 'BEGIN { printf "%c ",char; exit }'; echo "$x"
                done
        }; __char__ "${__Ascii__}"
};

system.ord(){
        declare __Text__="$@"

	[[ -z "$__Text__" ]] && read -s Text

        # system convert
        function __convert__ {
                local string="$1";

                for ((i = 0; i < ${#string}; i++)); do
                        Tulis.str "%d " "'${string:i:1}";
                done
        }; __abs__=$(__convert__ "${__Text__}"); __abs__="${__abs__%% }"; echo "$__abs__"
};

alias @ord="system.ord"
alias @char="system.char"
