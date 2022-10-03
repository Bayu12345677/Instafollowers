setup:
	pkg install curl
	pkg install jq
	pkg install wget
	pkg install ncurses-utils
	pkg install figlet
	python setup.py install
run:
	chmod 0755 enc_12654_.sh
	./enc_12654_.sh
