@import text_display/IO.ECHO text_display/colorama
@import util/IO.TYPE util/IO.FUNC
@import util/IO.SYSTEM.var util/IO.SYSTEM.log


###################################
#		  tor request			  #
#								  #
# author : polygon				  #
# date   : Tuesday, Feb, 2022	  #
###################################

def: system.torsocks(){
	global: app = "$1"

	function __socket__ {
		if [[ ! -f "__lol__tor.conf" ]]; then
			echo -e "#SOCKSPort 9050\n#SOCKSport 192.168.0.1:9100\n#SOCKSPolicy accept 192.168.0.0/16\n#SOCKSPolicy accept6 FC00::/17\n#SOCKSPolicy reject *\n#Log notice file /data/data/com.termux/files/usr/var/log/tor/notices.log\n#Log debug file /data/data/com.termux/files/usr/var/log/tor/debug.log\n#Log notice syslog\n#Log debug stderr\n#RunAsDaemon 1\n#DataDirectory /data/data/com.termux/files/usr/var/lib/tor\n#ControlPort 9051\n#HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C\n#CookieAuthentication 1\n#HiddenServiceDir /data/data/com.termux/files/usr/var/lib/tor/hidden_service/\n#HiddenServicePort 80 127.0.0.1:80\n\n#HiddenServiceDir /data/data/com.termux/files/usr/var/lib/tor/other_hidden_service/\n#HiddenServicePort 80 127.0.0.1:80\n#HiddenServicePort 22 127.0.0.1:22\n#ORPort 9001\n#ORPort 443 NoListen\n#ORPort 127.0.0.1:9090 NoAdvertise\n#ORPort [2001:DB8::1]:9050\n#Address noname.example.com\n#OutboundBindAddressExit 10.0.0.4\n#OutboundBindAddressOR 10.0.0.5\n#Nickname ididnteditheconfig\n#RelayBandwidthRate 100 KBytes  # Throttle traffic to 100KB/s (800Kbps)\n#RelayBandwidthBurst 200 KBytes # But allow bursts up to 200KB (1600Kb)\n#AccountingMax 40 GBytes\n#AccountingStart day 00:00\n#AccountingStart month 3 15:00\n#ContactInfo 0xFFFFFFFF Random Person <nobody AT example dot com>\n#DirPort 9030\n#DirPort 80 NoListen\n#DirPort 127.0.0.1:9091 NoAdvertise\n#DirPortFrontPage /data/data/com.termux/files/usr/etc/tor/tor-exit-notice.html\n#MyFamily $keyid,$keyid,...\n#ExitRelay 1\n#IPv6Exit 1\n#ReducedExitPolicy 1\n#ExitPolicy accept *:6660-6667,reject *:* # allow irc ports on IPv4 and IPv6 but no more\n#ExitPolicy accept *:119 # accept nntp ports on IPv4 and IPv6 as well as default exit policy\n\n#ExitPolicy accept *4:119 # accept nntp ports on IPv4 only as well as default exit policy\n\n#ExitPolicy accept6 *6:119 # accept nntp ports on IPv6 only as well as default exit policy\n\n#ExitPolicy reject *:* # no exits allowed\n#BridgeRelay 1\n#PublishServerDescriptor 0" > lib/tor__socks__/__lol__tor.conf
		fi; {
			if ((app == 1)); then {
				tor -f "${2}" 2>/dev/null 1>/dev/null &
			};
			elif ((app == 2)); then {
				tor -f lib/tor__socks__/__lol__tor.conf 2>/dev/null 1>/dev/null &
			}; fi
		};
      }; __socket__ "$app" "$2";
}

def: system.setup(){
	if ! (command -v tor &> /dev/null); then
		apt-get install tor torsocks
	fi;
		global: mode = "$1"

		if [[ -z "$mode" ]]; then
			println_info " error in [${BASH_LINENO[0]}] source [${BASH_SOURCE[1]}]";
			println_info " how to use -> my.__tor__: default or my.__tor__: manual [location_config]"; exit 23
		fi;

			if [[ $mode == default ]]; then
				system.torsocks 2
			elif [[ $mode == manual ]]; then
				if [[ ! -f "$2" ]]; then
					println_info " config [${2}] not found"; exit 23
				fi; system.torsocks 1 "$2"
			fi; if ! (curl --socks5-hostname localhost:9050 google.com &> /dev/null); then sleep 22s; fi; if ! (curl -s --socks5-hostname localhost:9050 google.com &> /dev/null); then println_info " connection failed"; exit 5; fi
};

shopt -s expand_aliases

IO.AS "system.setup" to "my.__tor__:";
IO.AS 'if ! (curl --socks5-hostname 127.0.0.1:9050 --url google.com &> /dev/null); then println_info " Failed connection in torsocks how to use its -> my.__tor__: default; curlTor [METHODS] [URL] OPTIONS --help"; exit 23; fi; killall -HUP tor; curl --socks5-hostname localhost:9050 --insecure --compressed' to "curlTor";
