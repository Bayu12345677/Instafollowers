@import util/IO.SYSTEM.var
@import util/IO.FUNC util/IO.TYPE
@import util/operator util/io.class

: '

		               pyreq

merupakan salah satu perpustakaan yg berfungsi untuk mengakses 
library requests di python menggunakan bash

example :

var modul : "

data = {
	....
}

head = {
	...
}

res = req.get("proto://example.com", headers=head, data=data).text
"
-note : variable harus berupa res agar bisa di baca oleh perpustakaan ini

'

class __pyreq__;
{
	public: app = req;
	public: app = request;
}; {
	def: __pyreq__::req(){
		declare __pack__="$@"
			
		if ! (ambil: __pack__ in "res" &> /dev/null); then
			Tulis.strN "warning : Line ${BASH_LINENO[0]} Source ${BASH_SOURCE[1]}"
			Tulis.strN "message : nama variable harus berupa res agar bisa di baca oleh perpustakaan"; exit 23
		fi;

		echo -e "
import requests as req
${__pack__}
try:
	print(res)
except:	pass" | python
	};
		def: __pyreq__::request(){
                global: __pack__ = "$@"

                if ! (ambil: __pack__ in "res" &> /dev/null); then
                        Tulis.strN "warning : Line ${BASH_LINENO[0]} Source ${BASH_SOURCE[1]}"
                        Tulis.strN "message : nama variable harus berupa res agar bisa di baca oleh perpustakaan"; exit 23
                fi;

                echo -e "import requests as request\n${__pack__}\nif not res:\n      res='uoi'\nprint(res)"
        };
shopt -s expand_aliases
#alias python.req="system::req"
};
