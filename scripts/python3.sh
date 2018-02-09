#!/usr/bin/env bash
tn='Python-3.7.0b1'; url='http://www.python.org/ftp/python/3.7.0/Python-3.7.0b1.tar.xz';
set_source 'tar';
if [ $only_dw == 1 ];then return;fi

if [ ! -f $CUST_INST_PREFIX/bin/python3 ]; then
	if [[ $os_r == 'Ubuntu' ]];then
		apt-get autoremove -yq --purge python3
	elif [ $os_r == 'openSUSE'] && [ $stage == 1 ];then
		echo 'possible? zypper rm -y python3';
	fi
fi
configure_build  --with-system-expat --with-system-ffi --enable-unicode --with-ensurepip=install --with-computed-gotos --enable-shared --enable-optimizations --enable-ipv6 --with-lto  --with-signal-module  --with-pth --with-pymalloc --with-fpectl  --prefix=$CUST_INST_PREFIX;   #
do_make;do_make install;
if [ -f $CUST_INST_PREFIX/bin/python3 ]; then
	rm /usr/bin/py3; ln -s $CUST_INST_PREFIX/bin/python3 /usr/bin/py3;
	echo $CUST_INST_PREFIX/lib/python3 > $LD_CONF_PATH/python3.conf;
	py3 -m ensurepip; rm /usr/bin/py3_pip; ln -s $CUST_INST_PREFIX/bin/pip3 /usr/bin/py3_pip;
fi

ldconfig
if [ -f $CUST_INST_PREFIX/bin/py3_pip ]; then
	
	rm -r ~/.cache/pip 

	py3_pip install --upgrade setuptools
	py3_pip install --upgrade pip
	py3_pip install --upgrade setuptools

	py3_pip install --upgrade cffi 
	py3_pip install --upgrade greenlet
	py3_pip install --upgrade psutil deepdiff
	py3_pip install --upgrade xlrd lxml	
	py3_pip install --upgrade pycrypto 
	py3_pip install --upgrade cryptography
	py3_pip install --upgrade pyopenssl #LDFLAGS="-L$CUST_INST_PREFIX/ssl/lib" CFLAGS="-I$CUST_INST_PREFIX/ssl/include" 

	py3_pip install --upgrade pycparser
	
	py3_pip install --upgrade h2 #https://github.com/python-hyper/hyper-h2/archive/master.zip
	py3_pip install --upgrade urllib3 dnspython
	py3_pip install --upgrade https://github.com/eventlet/eventlet/archive/v0.19.0.zip # https://github.com/eventlet/eventlet/archive/master.zip #eventlet
	echo '' > "/usr/local/lib/python2.7/site-packages/eventlet/green/OpenSSL/rand.py"
	sed -i "1s;^;import OpenSSL.SSL\nfor n in dir(OpenSSL.SSL):\n    exec(n+'=getattr(OpenSSL.SSL, \"'+n+'\")')\n;" /usr/local/lib/python2.7/site-packages/eventlet/green/OpenSSL/SSL.py
	sed -i 's/from OpenSSL.SSL import \*//g' /usr/local/lib/python2.7/site-packages/eventlet/green/OpenSSL/SSL.py;
	sed -i "1s;^;import OpenSSL.crypto\nfor n in dir(OpenSSL.crypto):\n    exec(n+'=getattr(OpenSSL.crypto, \"'+n+'\")')\n;" /usr/local/lib/python2.7/site-packages/eventlet/green/OpenSSL/crypto.py

   
	py3_pip install --upgrade msgpack-python
	py3_pip install --upgrade Wand
	py3_pip install --upgrade weasyprint                 
	py3_pip install --upgrade pylzma rarfile  #zipfile pysnappy
	py3_pip install --upgrade guess_language
	py3_pip install --upgrade paypalrestsdk #pygeocoder python-google-places
	py3_pip install --upgrade josepy acme

	py3_pip install --upgrade https://github.com/kashirin-alex/libpyhdfs/archive/master.zip

fi
