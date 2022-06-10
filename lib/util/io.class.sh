@import text_display/IO.ECHO util/IO.SYSTEM.var
@import util/IO.SYSTEM.log
@import util/IO.TYPE util/IO.FUNC

var DEFCLASS : ""
var CLASS : ""
var THIS : 0

class() {
  DEFCLASS="$1"
  eval CLASS_${DEFCLASS}_VARS=""
  eval CLASS_${DEFCLASS}_FUNCTIONS=""
}

static() {
  return 0
}

public:() {
  if [[ $1 == app ]]; then
		funcname=${FUNCNAME[*]}
  else
  		println_err " command not found"
  		println_err " Line [${BASH_LINENO[0]}][${BASH_SOURCE[1]}]"
  		println_err " error -> $1"; exit 23
  fi;
  	if [[ "$2" == "=" ]]; then
  		local varname="CLASS_${DEFCLASS}_FUNCTIONS"
  		eval "$varname=\"\${$varname}$3 \""
  	else
  		println_info " Line [${BASH_LINENO[0]}] [${BASH_SOURCE[1]}]"
  		println_info " -> $2 not defined"; exit 21
  	fi
}

inst.var() {
  local varname="CLASS_${DEFCLASS}_VARS"
  eval $varname="\"\${$varname}$1 \""
}

loadvar() {
  eval "varlist=\"\$CLASS_${CLASS}_VARS\""
  for var in $varlist; do
    eval "$var=\"\$INSTANCE_${THIS}_$var\""
  done
}

loadfunc() {
  eval "funclist=\"\$CLASS_${CLASS}_FUNCTIONS\""
  for func in $funclist; do
    eval "${func}() { ${CLASS}::${func} \$*; return \$?; }"
  done
}

savevar() {
  eval "varlist=\"\$CLASS_${CLASS}_VARS\""
  for var in $varlist; do
    eval "INSTANCE_${THIS}_$var=\"\$$var\""
  done
}

typeof() {
  eval echo \$TYPEOF_$1
}

class.new:() {
  local class="$1"
  local cvar="$2"
  local id=$(echo $(($RANDOM%250+2)) | tr "0-9" "a-z")
  shift
  shift
  eval TYPEOF_${id}=$class
  eval $cvar=$id
  local funclist
  eval "funclist=\"\$CLASS_${class}_FUNCTIONS\""
  for func in $funclist; do
    eval "${cvar}.${func}() { local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar; loadfunc; ${class}::${func} \$@; rt=\$?; savevar; CLASS=\$c; THIS=\$t; return $rt; }"
    #alias ${cvar}.${func}="local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar; loadfunc; ${class}::${func} \$@; rt=\$?; savevar; CLASS=\$c; THIS=\$t; return $rt"
  done || eval "${cvar}.${class} \$@"||true
}

class.sys:() {
  local class="$1"
  local cvar="$2"
  local id=$(echo $(($RANDOM%250+2)) | tr "0-9" "a-z")
  shift
  shift
  eval TYPEOF_${id}=$class
  eval $cvar=$id
  local funclist
  eval "funclist=\"\$CLASS_${class}_FUNCTIONS\""
  for func in $funclist; do
    #eval "${cvar}.${func}() { local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar; loadfunc; ${class}::${func} \$@; rt=\$?; savevar; CLASS=\$c; THIS=\$t; return $rt; }"
    alias ${cvar}.${func}="t=$THIS; THIS=$id;CLASS=$class; loadvar; loadfunc; savevar; ${class}::${func}"
  done || eval "${cvar}.${class} \$@"||true
}

const:(){
  local cl="$1"
  local cv="$3"
#  export CV="${cv}"

  if (test "$2" != "="); then
    echo "Error di Line ${BASH_LINENO[0]}; karakter ${2}"; exit
  fi

  class.sys: ${cl} ${cv}
}
