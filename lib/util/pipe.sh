@import util/io.class util/IO.FUNC
@import text_display/IO.ECHO text_display/colorama
@import util/IO.TYPE util/IO.SYSTEM.log

Namespace: util/pipe
# author : polygon
# projects : open source

<<_EOF_
-------------------------------
		system pipe
-------------------------------
_EOF_

class __pipe__; (:)
{
	public: app = command
	public: app = vars

	# definisi system pipe
	def: __pipe__::command(){
		read __name__
		echo "$__name__" | $@
	};

	def: __pipe__::vars(){
		read __name__; namevars="$@"

		# verify variable
		global: get = $(declare -p "$namevars" 2> /dev/null)

		if [[ -z "$get" ]]; then {
			println_err " error syntax into Line (${BASH_LINENO[1]}) Files (${BASH_SOURCE[0]})"
			println_err " variable not found"
			__e__="Continue ☕"; throw
		}; fi; local perintah;
		__perintah__=$(@return: $@)
		echo "$__name__" | eval $__perintah__
	};
}; class.new: __pipe__ name

shopt -s expand_aliases

#def: system.name(){
#	if [[ -z "$@" ]]; then
#		println_err " Line ${BASH_LINENO[1]} Files ${BASH_SOURCE[0]}"
#		println_err " pipe not found"
#		__e__="Continue ☕"; throw
#	fi
#}

def: system.capture(){
	read -t 0.1 string
	global: app = "$string"
	echo "$app"
}

alias pipe.command:="system.capture | name.command"
alias pipe.vars:="system.capture | name.vars"
