*** General Steps to compile Apache and its' modules from source.
+ You can use these articles for reference:
- https://blog.ivanristic.com/2013/08/compiling-apache-with-static-openssl.html
- https://unix.stackexchange.com/questions/66692/apache-installation-configuration-cant-find-pcre-pcre-config-for-libpcre-not
- https://stackoverflow.com/questions/5311515/gcc-fpic-option

+ Take a backup of your current Apache installation. (e.g. tar czf `date +\%Y\%m\%d_Apache22.tar.gz /web/apache/current)
+ As root after untarring | unzipping your source code, look for the directory with the "configure" script in it for your various add-ons (OpenSSL (likely will need to pass -fPIC when configuring), PCRE) and compile them to the desired location using the general syntax below. Then copy the directories (after compilation) into your working Apache directories' "srclib" directory (this assumes the working dir is called "httpd-2.4.29")
- e.g. httpd-2.4.29/srclib/ directory. 
- Then make soft links from version name to generic "current" name.
-- e.g. cd http-2.4.29/srclib; ln -s apr-1.6.3 apr; ln -s apr-util-1.6.1. apr-util; ln -s openssl-1.0.2n openssl; ln -s pcre-8.4.1 pcre.
- This allows you to use the --with option when you go to fully compile Apache with all these pieces.


+ If you mess up or forget something, run 'make clean' prior to running 'make install'as it'll clear out some meta data files.


+Apr
- ./configure --prefix=/usr/local/apr
-- 'make'
-- 'make install' 
--- Confirm the last command executed successfully by running: 'echo $?' which should return with a "0". 

+ Apr-Util (you have to specify the location of the already compiled APR directory)
- ./configure -with-apr=/usr/local/apr
-- 'make'
-- 'make install' 
--- Confirm the last command executed successfully by running: 'echo $?' which should return with a "0". 

+ PCRE
- ./configure -prefix=/usr/local/pcre
-- 'make'
-- 'make install' 
--- Confirm the last command executed successfully by running: 'echo $?' which should return with a "0". 


+ OpenSSL
- './config -fPIC --prefix=/usr/local/openssl-1.0.2n
-- 'make'
-- 'make install' 
--- Confirm the last command executed successfully by running: 'echo $?' which should return with a "0". 


+ Now you are ready to compile Apache by going into your Apache source code directory and employing the "--with" "enable-modules=" operator(s). 

+ You can either run the script called "doit.sh" in place of the "configure" step or run all this manually with something like the following: './configure --enable-layout=Apache --prefix=/web/apache/2.4.29 --enable-modules='deflate proxy rewrite ssl vhost-alias' --enable-mods-shared='deflate proxy rewrite ssl vhost-alias' --enable-mods-static='so' --enable-auth-digest --enable-slotmem_shm --with-ldap --with-included-apr --with-ssl=/usr/local/openssl-1.0.2n --with-pcre=/usr/local/pcre --with-mpm=event --with-port=80
- 'make clean'
- 'make install'
-- Confirm the last command executed successfully by running: 'echo $?' which should return with a "0". 

Assuming you compiled without errors the finished product will be in the "/web/apache/2.4.29" directory.

+ Now you'll want to run the "ApacheConversion_22to24.sh" script as a post compile step.
+ To stop the old version of Apache, and change the symlink to the new version run the "cutover.sh -v [22|24]"
+ Now you should be ready to start the web server: '/web/apache/current/bin/httpd -k start'


*** Reversion Steps
+ Run 'cutover.sh -v 22'
+ Restart Apache using the "current" directory path e.g. /web/apache/current/bin/httpd -k restart
- Test


*** Test
+ 'openssl s_client -connect edgepark.com:443 -tls1_2'
- If you get the certificate chain and the handshake you know the system in question supports TLS 1.2. If you don’t see the certificate chain, and something similar to “handshake error” you know it does not support TLS 1.2.
+ 'telnet qa-edgepark.assuramed.com 443'
- When you get connected and the escape character message type in: "HEAD HTTP/1.1" press enter and you should the Server: Apache/2.4.29 (Unix) OpenSSL/1.0.2n

Download locations for your reference:
http://httpd.apache.org/download.cgi#apache24
https://apr.apache.org/download.cgi
https://www.openssl.org/source/
