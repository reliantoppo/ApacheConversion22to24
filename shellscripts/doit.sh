LDFLAGS=-L/usr/local/lib64 ./configure \
--enable-layout=Apache \
--prefix=/web/apache/2.4.29 \
--enable-modules='deflate proxy rewrite ssl vhost-alias auth-digest authn-alias authn-anon authn-dbd authn-dbm authnz-ldap authz-dbm authz-owner cache dav disk-cache expires ext-filter file-cache headers info ldap lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic lbmethod_byheartbeat logio mem-cache mime-magic proxy_ajp proxy_balancer proxy_connect proxy_express proxy_hcheck proxy_http proxy_fcgi proxy_fdpass proxy_ftp proxy_scgi proxy_wstunnel slotmem_shm speling socache_shmcb usertrack watchdog' \
--enable-mods-shared='deflate proxy rewrite ssl vhost-alias' \
--enable-mods-static='so' \
--with-ldap \
--with-included-apr \
--with-ssl=/usr/local/openssl-1.0.2n \
--with-pcre=/usr/local/pcre \
--with-mpm=event \
--with-port=80
