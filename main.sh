#!/usr/bin/env bash

# source by Bayu Riski A.M
# tidak ada orang yg menulis script ini kecuali Bayu Riski A.M

# WARNING
# kalo reupload sertakan sumber nya lah bambang
# jadi kita sama sama untung gak untung sebelah aja
# hargai author nya

# plugins bash moderen
. lib/moduler.sh
# depencies
Bash.import: text_display/colorama text_display/IO.ECHO
Bash.import: minimist/args urlib/pyreq
Bash.import: util/operator curl/main

# warna
@require modules/pack.sh
#cursor
var up : $(tput sc)
var down : $(tput rc)
var clear : $(tput ed)

# import class
const: __minimist__ = ARGS
const: __minimist__ = argv
const: __pyreq__ = python
const: __curlopt__ = opt
# class curl
class __curlib__;
{
	public: app = initialize
	public: app = get
	public: app = post
	public: app = Curl

	def: __curlib__::initialize()
	{
		ARGS.get_arg ["$1"]; # url
		ARGS.get_arg ["$2"]; # opsi
		ARGS.get_arg ["$3"]; # methods

		var __url__ : $(@return: uri)
		var __opsi__ : $(@return: opsi)
		var __methods__ : $(@return: methods)
	}

	def: __curlib__::get()
	{
		ARGS.get_arg ["$1"]; # url
		ARGS.get_arg ["$2"]; # opsi
		#ARGS.get_arg ["$3"]; # data
		#ARGS.get_arg ["$1"]
		var opsi : $(echo "$opsi"|sed 's;\\;'';g')
		#__curlib__::initialize uri="$url" opsi="${opsi}"
		# eksekusi
		var opsi2 : "-sL --get"
		eval "curl \${opsi:-${opsi2}} --url \"${url}\" --insecure --compressed"
	}

	def: __curlib__::post()
	{
		ARGS.get_arg ["$1"]; # url
		ARGS.get_arg ["$2"]; # opsi
		var opsi : $(echo "$opsi"|sed 's;\\;'';g')
		#ARGS.get_arg ["$3"]; # data
		# menyimpan data argument
		__curlib__::initialize uri="$url" opsi="$opsi"
		# eksekusi
		var opsi2 : "-sL --request POST"
		eval "curl ${opsi:-${opsi2}} --url \"${url}\" --insecure --compressed"
	}


	def: __curlib__::Curl()
	{
		#echo "$2"; exit
		ARGS.get_arg ["$1"]; # methods
		ARGS.get_arg ["$2"]; # opsi
		ARGS.get_arg ["$3"]; # url
		# menyimpan data minimist
		__curlib__::initialize uri="$url" methods="${methods}"
		# eksekusi
		#local __url__ __opsi__ __methods__
		var opsi : ${opsi/]/}
		if (test -z "$url"); then var __respone__ : "None"
		elif (test -z "$opsi"); then var __respone__ : "None"
		elif (test -z "$methods"); then var __respone__ : "None"
		else
			#var __respone__ : $(eval "curl --request \${methods:-GET} \${opsi} --url \"\${url}\" --insecure --compressed")
			curl --request ${methods:-GET} ${opsi} --url "${url}" --insecure --compressed
			#echo __respone__
		fi; @return: __respone__
	}
};

class __req__;
{
	public: app = headers;
	public: app = Session;

	def: __req__::headers()
	{
		var bersih : $(echo "${@/[/}")
		var bersih : $(echo "${bersih/]/}")

		echo "$bersih" >> header.conf
	}

	def: __req__::Session()
	{
		argv.get_arg ["$1"]; # url
		argv.get_arg ["$2"]; # methods
		argv.get_arg ["$3"]; # data
		var CH : $(opt.Session Jar="cookie.txt" options="-sLX ${methods} ${data} --header @header.conf --insecure --compressed")
		var rp : $(opt.Curl url="$uri" ch="$CH")
		var res : $(opt.exec_opt config="$rp")

		@return: res
	}
	
}

#import object curlopt
const: __req__ = curlopt

class __TorSetup__;
{
        public: app = start
        public: app = address
        public: app = stop

        def: __TorSetup__::start(){
                tor &> /dev/null &
                if (curl -sL --socks5-hostname localhost:9050 "google.com" &> /dev/null); then
                        var status_tor : "on"
                else
                        var status_tor : "off"
                fi
        }

        def: __TorSetup__::address(){
                killall -HUP tor
        }

        def: __TorSetup__::stop(){
                killall tor &> /dev/null
        }
}

const: __curlib__ = req;
#var res : $(Tulis.str $(req.Curl url="https://google.com" opsi="-H \"User-Agent: Google Bot v3\" -sL"))
#req.Curl methods="GET" opsi="-H \"user-agent: Google Bot v3\" -sL" url="https://google.com"
#req.get url="https://google.com" opsi="-v -sL -H \\\"user-agent: Google Bot V3\\\"" methods="GET"
#@return: res

# class sms free
class __ig__;
{
	public: app = initialize;
	public: app = send;

	#var cookies : $(mktemp -t cookie.XXXXX)
	def: __ig__::initialize()
	{
		ARGS.get_arg ["$1"]; # username tumbal
		ARGS.get_arg ["$2"]; # password tumbal
		ARGS.get_arg ["$3"]; # pengguna

		var user : $(
			python.req "
from fake_useragent import UserAgent as Ua
setup=Ua()
try:
	res=setup.random
except:
	pass
"
		)
		var cookie : $(
			req.Curl methods="GET" opsi="-H 'user-agent: ${user}' -sL" url="https://app.followersandlikes.co"
		);
		#@return: cookie
		var get_token : $(curl --silent --location --request GET  --header "user-agent: ${user}" --cookie "${cookies}" --url "https://app.followersandlikes.co/member" --insecure --compressed --cookie-jar cookie.txt)
		var regex : $(@return: get_token|grep -Po '(?<=antiForgeryToken=)[^}.]*')
		var token : "${regex%%\"*}"

		var login : $(
			curl -sL \
				 --request POST \
				 --header "content-type: application/x-www-form-urlencoded; charset=UTF-8" \
				 --header "user-agent: ${user}" \
				 --cookie cookie.txt \
				 --data-raw "username=${User}&password=${pass}&userid=undefined&antiForgeryToken=${token}" \
				 --url "https://app.followersandlikes.co/member" \
				 --insecure --compressed --cookie-jar cookie.txt
		);

		var req_user : $(
			curl --silent \
				 --location \
				 --request GET \
				 --header "user-agent: ${user}" \
				 --url "https://app.followersandlikes.co/tools/send-follower" \
				 --insecure --compressed --cookie cookie.txt --cookie-jar cookie.txt
		)

		#curlopt.headers ["user-agent: Mozilla/5.0 (Linux; Android 10; dandelion Build/QP1A.190711.020;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/91.0.4472.101 Mobile Safari/537.36"]
		#curlopt.headers ["x-requested-with: XMLHttpRequest"]
		#curlopt.headers ["content-type: application/x-www-form-urlencoded"]
		#curlopt.Session uri="https://bigtakipci.com/login/mobileCheck" methods="POST" data="--data-raw 'username=$user&token=&password=$pass'" &> /dev/null
		
		var mencari_id : $(
			curl --silent \
				 --location \
				 --request GET \
				 --header "user-agent: ${user}" \
				 --url "https://www.instagram.com/${Usr}/?__a=1" \
				 --insecure --compressed
		)

		if (@return: mencari_id|jq -r .graphql.user.id &> /dev/null); then
			var __id__ : $(@return: mencari_id|jq -r .graphql.user.id)
		else
			var __id__ : $(
				python.req "
import instaloader as ig

setup=ig.Instaloader()
profile=ig.Profile.from_username(setup.context,'${Usr}')
try:
	res = profile.userid
except:
	pass
	
"
				)
		fi
	}

	def: __ig__::send()
	{
		ARGS.get_arg ["$1"]; # tumbal
		ARGS.get_arg ["$2"]; # pass tumbal
		ARGS.get_arg ["$3"]; # user

		#__ig__::initialize User="$Username" pass="$pw" Usr="$target"
#		echo "$__id__"
		var kirim : $(
			curl --silent \
				 --location \
				 --request POST \
				 --header "user-agent: ${user}" \
				 --cookie cookie.txt \
				 --header "content-type: application/x-www-form-urlencoded" \
				 --header "x-requested-with: XMLHttpRequest" \
				 --data-raw "adet=1&userID=${__id__}&userName=${target}" \
				 --url "https://app.followersandlikes.co/tools/send-follower/${__id__}?formType=send" \
				 --insecure --compressed				 
		)

		#curlopt.Session uri="https://bigtakipci.com/Process/Follow/" methods="POST" data="--data-raw 'senduser=$__id__&usernames=$target&quantity=1'"
		#exit
		var __ID__ : $(@return: kirim|jq -r .users[].instaID)
		var __USER__ : $(@return: kirim|jq -r .users[].userNick)
		var __STATUS__ : $(@return: kirim|jq -r .users[].status)
		var __POINT__ : $(@return: kirim|jq -r .takipKredi)
		
		if (test "$__STATUS__" == "fail"); then
			var __HEAD__ : $(@return: kirim|jq -r .users[].head)
			var __CODE__ : $(@return: __HEAD__|jq -r .http_code)
			var __SIZE__ : $(@return: __HEAD__|jq -r .header_size)
			var __Req__ : $(@return: __HEAD__|jq -r .request_size)
			var __upload__ : $(@return: __HEAD__|jq -r .size_upload)
			var __download__ : $(@return: __HEAD__|jq -r .size_download)
			var __speed__ : $(@return: __HEAD__|jq -r .speed_upload)
			var __spdown__ : $(@return: __HEAD__|jq -r .speed_download)
			var __vhttp__ : $(@return: __HEAD__|jq -r .http_version)
			var __proto__ : $(@return: __HEAD__|jq -r .protocol)
			var __scheme__ : $(@return: __HEAD__|jq -r .scheme)
			var __total__ : $(@return: __HEAD__|jq -r .total_time)
		fi
	}
}

# import class
const: __ig__ = ig;
const: __TorSetup__ = tor;

# banner
def: banner()
{
	var eee : ""
    let fr_a=0
    let fr_b=51
    for ((frame = fr_a; frame <= fr_b; frame++)); do
         if ((frame == fr_a)); then local eee+="${pu}⬥"
         elif ((frame == fr_b)); then local eee+="${pu}⬥"
         elif ((frame == fr_b / 2 + 1)); then local eee+="${ij}⬥"
         elif ((frame > 1)); then local eee+="${me}-"
         fi
    done
	Tulis.str "${ku}"
	figlet -f slant "Instafollowers"
	Tulis.str "$st"
	Tulis.strN "\t\t\t \e[107m${hi}Bot Followers${st}\n"
	Tulis.strN "\t${eee}${st}"
	Tulis.strN "\t\t${ij}[${ku}×${ij}]${pu} Author  ${me}:${pu} Silent || Polygon"
	Tulis.strN "\t\t${ij}[${ku}×${ij}]${pu} Youtube ${me}:${pu} Pejuang Kentang"
	Tulis.strN "\t\t${ij}[${ku}×${ij}]${pu} Github  ${me}:${pu} https://github.com/Speedrun-bash"
	Tulis.strN "\t${eee}${st}\n"
}

class __animasi__;
{
	public: app = initialize;
	public: app = cek;
	public: app = load;
	public: app = bom;

	def: __animasi__::initialize()
	{
		array_color=(${ku} ${me} ${ij} ${bi} ${m} ${cy})
		var random : $(shuf -i 0-5 -n 1)
	}

	def: __animasi__::cek()
	{
		global: Tulis = "$@"
		local frame=("/" "_" "\\" "|")
		for xframe in ${frame[@]}; do
			__animasi__::initialize
			printf "${up}"
			Tulis.str "\r${Tulis} ${array_color[$random]}${xframe}"
			printf "${down}"
			sleep 0.0$(shuf -i 1-10 -n 1)
		done
	}

	def: __animasi__::load()
	{
		global: Tulis = "$@"
		local frame=("⠿" "⠻" "⠽" "⠾" "⠷" "⠯" "⠟")
		for xframe in ${frame[@]}; do
			__animasi__::initialize
			printf "$up"
			Tulis.str "\r${Tulis} ${array_color[$random]}${xframe}"
			printf "$down"
			sleep 0.0$(shuf -i 1-10 -n 1)
		done
	}

	def: __animasi__::bom()
	{
		global: Nulis = "$@"
		__animasi__::cek $Nulis
		printf "$clear"
 	}
}

const: __animasi__ = animasi

def: __main__()
{
	banner
	printf "${up}"
	Tulis.str "${me}[${ij}•${cy}•${me}]${pu} Masukan Username ${ku}(${hi}Tumbal${ku})${m}>${st} "; read tumb
	printf "${down}${clear}"
	printf "$up"
	Tulis.str "${me}[${ij}•${cy}•${me}]${pu} Masukan password ${ku}(${hi}Akun tumbal${ku})${m}>${st} "; read pwtumb
	printf "${down}${clear}"
	printf "$up"
	Tulis.str "${me}[${cy}•${ij}•${me}]${pu} Masukan Username ${ku}(${hi}Akun Ori${ku})${m}>${st} "; read trg
	echo
	#__ig__::initialize User="$Username" pass="$pw" Usr="$target"
#	while true; do
#		animasi.load "${ku}${ku}•${st} Memulai Tor"
#	done &
#	let sig=${!}

#	while true; do
#		tor.start
#		if (test "$status_tor" == "on"); then
#			break
#		else
#			continue
#		fi
#	done
#	kill "${sig}"
#	printf "$clear"
#	Tulis.strN "${ku}• ${pu}Tor telah di mulai ${ij}√${st}"
	tput civis
	while true; do
		animasi.cek "${ku}[${me}•${cy}•${ku}] ${pu}Mencoba login"
	done &
	let sig=${!}
	printf "${clear}"
	ig.initialize User="$tumb" pass="$pwtumb"
	__ig__::initialize User="$tumb" pass="$pwtumb" Usr="$trg"
	kill "$sig"
	if (ambil: login in "success"); then
		Tulis.strN "${me}[${ij}•${ku}•${me}]${pu} Berhasil login ${ij}√${st}"
	else
		Tulis.strN "${ku}•${pu} Gagal Login ${ku}(${hi}Pastikan password dan username akun tumbal benar dan pakaikan foto profile${ku})${st}"
		ct
		#tor.stop
		exit 0
	fi
		def: bar(){ var iii : "${me}┄┄┄┄┄-┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${ku}[\e[100m${cy}•${pu} ${@} ${cy}•${st}${ku}]${me}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${st}"; }
		bar INFORMASI
	Tulis.strN "$iii"
	while true; do
		while true; do
			animasi.load "${ku}[${bi}•${me}•${ku}]${pu} Memulai menyuntikan followers${st}"
		done &
		let sig=${!}
		var user_random : $(echo ${RANDOM}${RANDOM}${RANDOM}|base64|tr -d "\n"|sed 's;=;'';g')
		var pw_random : $(cat /dev/urandom|tr -dc '[a-zA-Z0-9]'|fold -w 20|head -n 1)
	def: ig2()
	{
			python.req "
import time,random,string,sys

headers = {
    'authority': 'instagram.qlizz.com',
    'accept': '*/*',
    'accept-language': 'id,en;q=0.9,en-GB;q=0.8,en-US;q=0.7',
    'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
    # Requests sorts cookies= alphabetically
    # 'cookie': '_ga=GA1.2.684540350.1652173099; _gid=GA1.2.1932374052.1652173099; _gat_gtag_UA_137153197_1=1; __gads=ID=5a201913cb3adcd6-2285e36d20d300f8:T=1652173100:RT=1652173100:S=ALNI_Ma5T99MHBxaAI7ZNxZzKkvhw13pcg; XSRF-TOKEN=eyJpdiI6IitcL21FZlU1XC82WXBRQ1E0ZlNXY0lydz09IiwidmFsdWUiOiJYTm82MGFXQWhHZ1UxQmZZZXI3VTdaQ0syalRhZ3ZEcFVUenI5TmVpTTl6VWMyZHpmNWtFZFlWWWhXVGN2SVlMdFZBR2UwRmcwYnRHeDJhaWxqK045QT09IiwibWFjIjoiZWM1ZjRjMTBlNDQ0NGU3NjgzN2FmMDA1ZTg5NjJiMjBmNTlmMjQ0MDFlNTBlODIxMTkwNGVjYTY5NTk1YTlhMSJ9; laravel_session=eyJpdiI6InNUXC9HUDlQUXdcL3lBdmFQTktWNWJVQT09IiwidmFsdWUiOiI1VEx5T29GR04zZVwvOUlzUVR1T3ZVbG5iK1FQWXcxYlR4ZHhwNkpoK2hzSXRPcEN1c1o3ZWk0SUVKcHpjcGd4bXRnSWVReU1qUURCcG8wUVd1ejA4VGc9PSIsIm1hYyI6ImZkOGNiNmVmNDBkYTFkN2Q4MmY1YmQ1NDFkYTEzMmE5ZWUwNWNmNWQ3NWU2MmU4ODVlZWI5MThmMmVhYjg4M2IifQ%3D%3D',
    'origin': 'https://instagram.qlizz.com',
    'referer': 'https://instagram.qlizz.com/autofollowers',
    'sec-ch-ua': '\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"101\", \"Microsoft Edge\";v=\"101\"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '\"Windows\"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36 Edg/101.0.1210.39',
    'x-requested-with': 'XMLHttpRequest',
}
a = random.choice(string.ascii_letters)
b = random.choice(string.ascii_letters)
c = random.choice(string.ascii_letters)
user = f\"{c}{a}{b}\"
passw = f\"a{c}j{a}wnjn{b}\"
bruh = {
    'username': user,
    'password': passw,
}
s = req.Session()
user = \"${trg}\"
s.post('https://instagram.qlizz.com/login', data=bruh)
alok = s.get('https://instagram.qlizz.com/autofollowers').text
a = alok.split('name=\"_token\" value=\"')[1];
tok = a.split('\"')[0];
data = {
    '_token': tok,
    'link': user,
    'tool': 'autofollowers',
}

res = s.post('https://instagram.qlizz.com/send', headers=headers, data=data).text
			" &> /dev/null
}
		sleep 6
		ig.send Username="$tumb" pw="$pwtumb" target="$trg"
		#echo -e "var user : \"${tumb}\"\nvar pw : \"${pw}\"" > conf.sh
		ig2
		kill "${sig}"
		printf "${clear}"
		var jjj : "${me}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${st}"
		if (test "$__STATUS__" != "fail"); then
			Tulis.strN "${ij}[${me}>${ij}]${pu} id       ${me}:${ku} ${__ID__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} username ${me}:${cy} ${__USER__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} status   ${me}:${ij} ${__STATUS__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} point    ${me}:${hi} ${__POINT__}${st}"
			Tulis.strN "$jjj"
		else
			Tulis.strN "${ij}[${me}>${ij}]${pu} id       ${me}:${ku} ${__ID__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} username ${me}:${cy} ${__USER__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} status   ${me}:${ij} ${__STATUS__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} point    ${me}:${hi} ${__STATUS__}${st}"
			bar INFORMASI BOT
			Tulis.strN "$iii"
			Tulis.strN "${ij}[${me}>${ij}]${pu} http code          ${me}:${pu} ${__CODE__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} ukuran header      ${me}:${pu} ${__SIZE__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} ukuran request     ${me}:${pu} ${__Req__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} ukuran upload      ${me}:${pu} ${__upload__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} ukuran downloads   ${me}:${pu} ${__download__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} kecepatan upload   ${me}:${pu} ${__speed__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} kecepatan download ${me}:${pu} ${__spdown__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} http version       ${me}:${pu} ${__vhttp__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} protocol           ${me}:${pu} ${__proto__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} shceme             ${me}:${pu} ${__scheme__}"
			Tulis.strN "${ij}[${me}>${ij}]${pu} total waktu        ${me}:${pu} ${__total__}${st}"
			Tulis.strN "${jjj}"
		fi
		# validasi masa akun tumbal
		if (test -z "$__ID__"); then
			kill "${sig}"
			Tulis.strN "${me}[${ku}!${me}]${st} Script error siakan ganti akun tumbal kalian"
			Tulis.strN "${me}[${ku}!${me}]${st} dan kasi pp biar gak di kira bot"
			ct
			exit
		fi
	# sengaja gua kasi validasi 2 sampe ke bawah agar script nya gak error cuy
	# tadi saya coba sampe 0 itu point nya gak nambah cuy malah perlu 1 jam agar nambah
	# jadi gua akalin sampe 2 ke bawah itu udah cooldwon, jadi gak usah di ubah cuy biar gak error
	if ((__POINT__ <= 2)) || [[ "$__POINT__" =~ [a-zA-Z]$ ]]; then
	let detik=60
	let menit=39

	while true; do
		if ((detik == 0)); then
			detik=60
			let menit--
		fi
		let detik--

		sleep 01
		printf "$up"
		Tulis.str "\r${ku}[${me}!${ku}]${pu} mengisi ulang point ${cy}${menit}${me}:${ij}${detik} ${st}"
		printf "$down"
		if ((menit == 0)); then
			ig.initialize Username="$tumb" pass="$pwtumb" Usr="$trg"
			break
		fi
	done; printf "$clear"
	fi
done
}

ct(){
	tput sgr0; tput cnorm; kill "${sig}" &> /dev/null; exit
}; trap ct INT SIGINT

#cek ukuran layar
var h : $(tput cols)
var w : $(tput lines)

# hitung validasi layar
if ((h >= 88 && w >= 26)); then let v=1
else let v=0
fi
# validasi layar
if ((v != 1)); then
	clear
	echo -e "
ukuran layar saat ini
h = ${h}
w = ${w}
ukuran layar yg di perlukan
h = 88
w = 26

${ku}[${me}!${ku}]${pu} perkecilkan layar anda untuk melanjutkan ke tools
${ku}[${me}!${ku}]${pu} layar terlalu besar${st}
	";exit
fi; xdg-open "https://youtube.com/channel/UCtu-GcxKL8kJBXpR1wfMgWg"
# gak usah di ubah yg ngubah tanpa izin dapat ganjaran dosa lu sendiri
clear && { __main__; }
