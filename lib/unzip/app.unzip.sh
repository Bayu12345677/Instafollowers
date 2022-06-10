@import text_display/IO.ECHO text_display/colorama
@import util/IO.FUNC util/io.class
@import util/IO.SYSTEM.var util/IO.SYSTEM.log

# author : polygon

class zip;
{
	public: app = files

	# obj files
	def: zip::files(){
		global: __name__ = "$1"
		global: __call__ = "$2"
		global: __option__ = "${3}"

		if [[ -z "$__name__" ]]; then
			println_err " Please to fill the file name that matches"
			println_err " Line (${BASH_LINENO[1]}) source (${BASH_SOURCE[0]})"
			__e__="Continue☕"; throw
		fi

#		if [[ -z "$__option__" ]]; then
#			println_err " option Not found"
#			println_err " Line ${BASH_LINENO[1]}"
#			exit 2
#		fi

		if [[ -z "$__call__" ]]; then
			if [[ "$__call__" == "password" ]]; then
			   if [[ -z "$3" ]]; then
			   		println_err " password not found"
			   		println_err " Mandatory password in the contents"
			   		println_err " Line ${BASH_LINENO[1]}"
			   		__e__="Continue ☕"; throw
			   	fi; var String_name_pass : "$3"
			 else
			 	String_name_pass=""
			fi
		fi;
			#if [[ -z "$3" ]]; then
			#	println_err " arg not found"
			#	println_err " Line (${BASH_LINENO[1]}) object (${__option__})"
			#	exit 2
			#fi
				# cek
				if [[ -z "$3" ]]; then
					unzip "$1"
				else
					if (unzip -P "$1" "$3" &> /dev/null); then
						Tulis.strN "Done unzip :)"
					else
						Tulis.strN "failed unzip password not found"
					fi
				fi
	}
}; Namespace.self: unzip/unzip
   {
   		class.new: zip unzip
   }; shopt -s expand_aliases
