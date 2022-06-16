# depencies
@import minimist/args util/operator
#import fungsi class
const: __minimist__ = ARGS

class __curlopt__;
{
	public: app = Session
	public: app = options
	public: app = Curl
	public: app = exec_opt

	def: __curlopt__::Session()
	{
		ARGS.get_arg ["$1"]; # nama roti
		ARGS.get_arg ["${2:-null}"]; # opsi
		echo -e "${options} --cookie-jar ${Jar} --cookie ${Jar} --insecure --compressed"|base64|tr -d "\n"
	}

	def: __curlopt__::options()
	{
		ARGS.get_arg ["${1:-n}"]; # opsi
		echo -e "${options}"|base64|tr -d "\n"
	}

	def: __curlopt__::Curl()
	{
		ARGS.get_arg ["$1"]; # ch
		ARGS.get_arg ["$2"]; # url
		var __ch__ : $(@return: ch|base64 -d)
		if (ambil: __ch__ in "--url" &> /dev/null); then
			var __opt__ : "curl $__ch__"
		else
			var __opt__ : "curl $__ch__ --url \"${url}\""
		fi

		if (test -z "$__opt__"); then
			echo "None"|base64|tr -d "\n"
		else
			@return: __opt__|base64|tr -d "\n"
		fi
	}
	
	def: __curlopt__::exec_opt()
	{
		ARGS.get_arg ["$1"]; #conf
		var __parse__ : $(@return: config|base64 -d)
		if (test "$__parse__" == "None"); then
			@return: __parse__
		else
			eval "$__parse__"
		fi
	}
}
