#!/usr/bin/env bash

# Author: Neil Aaron Madaczky
# ScriptVersion=1.0

# This script is to automate the conversion of Apache 2.2.23 to 2.4.29. This assumes both versions are installed in "/web/apache/2.2.23/" & "/web/apache/2.4.29/" directories respectively.
# For more detail with regard to the goal of upgrading 2.2 to 2.4 consult Apache documentation https://httpd.apache.org/docs/current/upgrading.html

# Determine which environment and instance number we're working with (QA|PROD 01|02) in order to accurately make updates to the various configuation files.
ENV=$(echo $HOSTNAME -f | cut -c1)
INST=$(echo $HOSTNAME -f | cut -c10)

# This section deals with gathering up the existing artifacts that we'll be using in the upgrade, such as the SSL certs. 
echo "Moving previous Apache (2.2.23) configuration files into new (2.4.29) install directory"
mkdir -p /web/apache/2.4.29/conf.d
cp vhost* /web/apache/2.4.29/conf.d/
cd /web/apache/2.4.29/conf.d
cp /web/apache/2.2.23/htdocs-maint.tgz /web/apache/2.4.29/ && tar zxf /web/apache/2.4.29/htdocs-maint.tgz -C /web/apache/2.4.29/
cp -a /web/apache/2.2.23/conf/ssl /web/apache/2.4.29/conf/
echo -e "..."

# Make global updates to the 'httpd.conf' file which need updated in both QA and PROD.
echo "Applying the special sauce (making adjustments) to the 'httpd.conf' file."
if grep -Fxq "IncludeOptional conf.d/*.conf" /web/apache/2.4.29/conf/httpd.conf;then 
  : 
else
  echo "IncludeOptional conf.d/*.conf" >> /web/apache/2.4.29/conf/httpd.conf
fi

sed -i -e 's|ServerAdmin you@example.com|ServerAdmin unixadmin@edgepark.com|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|User daemon|User webadm|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|Group daemon|Group webadm|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|Listen 80|#Listen 80|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_module modules/mod_proxy.so|LoadModule proxy_module modules/mod_proxy.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_connect_module modules/mod_proxy_connect.so|LoadModule proxy_connect_module modules/mod_proxy_connect.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_ftp_module modules/mod_proxy_ftp.so|LoadModule proxy_ftp_module modules/mod_proxy_ftp.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_http_module modules/mod_proxy_http.so|LoadModule proxy_http_module modules/mod_proxy_http.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so|LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_scgi_module modules/mod_proxy_scgi.so|LoadModule proxy_scgi_module modules/mod_proxy_scgi.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_fdpass_module modules/mod_proxy_fdpass.so|LoadModule proxy_fdpass_module modules/mod_proxy_fdpass.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so|LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_ajp_module modules/mod_proxy_ajp.so|LoadModule proxy_ajp_module modules/mod_proxy_ajp.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_balancer_module modules/mod_proxy_balancer.so|LoadModule proxy_balancer_module modules/mod_proxy_balancer.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_express_module modules/mod_proxy_express.so|LoadModule proxy_express_module modules/mod_proxy_express.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule proxy_hcheck_module modules/mod_proxy_hcheck.so|LoadModule proxy_hcheck_module modules/mod_proxy_hcheck.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so|LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so|LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so|LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule lbmethod_heartbeat_module modules/mod_lbmethod_heartbeat.so|LoadModule lbmethod_heartbeat_module modules/mod_lbmethod_heartbeat.so|g'/web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so|LoadModule socache_shmcb_module modules/mod_socache_shmcb.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule watchdog_module modules/mod_watchdog.so|LoadModule watchdog_module modules/mod_watchdog.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule slotmem_shm_module modules/mod_slotmem_shm.so|LoadModule slotmem_shm_module modules/mod_slotmem_shm.so|g' /web/apache/2.4.29/conf/httpd.conf
sed -i -e 's|#LoadModule ssl_module modules/mod_ssl.so|LoadModule ssl_module modules/mod_ssl.so|g' /web/apache/2.4.29/conf/httpd.conf
echo -e "..."

# Make updates to the vhost & vhost-ssl-enabled.conf file based on Environment and Instance number. e.g. q 2

## QA specific settings
if [ $ENV = q -a $INST = 1 ];then
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.18:8009|ajp://10.228.4.18:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.19:8009|ajp://10.228.4.19:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.18:18009|ajp://10.228.4.18:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.19:18009|ajp://10.228.4.19:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|Listen 192.168.17.210:80|Listen 192.168.17.210:80|g' /web/apache/2.4.29/conf.d/vhost.conf 
  sed -i -e 's|Listen 192.168.17.210:443|Listen 192.168.17.210:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|VirtualHost 192.168.17.210:80|VirtualHost 192.168.17.210:80|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|VirtualHost 192.168.17.210:443|VirtualHost 192.168.17.210:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
elif [ $ENV = q -a $INST = 2 ];then
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.18:8009|ajp://10.228.4.18:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.19:8009|ajp://10.228.4.19:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.18:18009|ajp://10.228.4.18:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.19:18009|ajp://10.228.4.19:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|Listen 192.168.17.210:80|Listen 192.168.17.211:80|g' /web/apache/2.4.29/conf.d/vhost.conf 
  sed -i -e 's|Listen 192.168.17.210:443|Listen 192.168.17.211:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|VirtualHost 192.168.17.210:80|VirtualHost 192.168.17.211:80|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|VirtualHost 192.168.17.210:443|VirtualHost 192.168.17.211:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
fi

## PROD specific settings
if [ $ENV = p -a $INST = 1 ];then
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.18:8009|ajp://10.217.128.31:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.19:8009|ajp://10.217.128.32:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.18:18009|ajp://10.217.128.31:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.19:18009|ajp://10.217.128.32:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|Listen 192.168.17.210:80|Listen 10.217.127.20:80|g' /web/apache/2.4.29/conf.d/vhost.conf 
  sed -i -e 's|Listen 192.168.17.210:443|Listen 10.217.127.20:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|VirtualHost 192.168.17.210:80|VirtualHost 10.217.127.20:80|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|VirtualHost 192.168.17.210:443|VirtualHost 10.217.127.20:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCertificateFile /web/apache/current/conf/ssl/ep_clcert.crt|SSLCertificateFile /web/apache/current/conf/ssl/origin.edgepark.com.pem|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCertificateKeyFile /web/apache/current/conf/ssl/ep_key.crt|SSLCertificateKeyFile /web/apache/current/conf/ssl/origin.edgepark.com.key|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCACertificateFile /web/apache/current/conf/ssl/ep_cacerts.crt|SSLCACertificateFile /web/apache/current/conf/ssl/bundle.pem|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
elif [ $ENV = p -a $INST = 2 ];then
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|qwebhybv01.corp.rghent.com|'$ENV'webhybv0'$INST'.corp.rghent.com|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.18:8009|ajp://10.217.128.31:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.19:8009|ajp://10.217.128.32:8009|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|ajp://10.228.4.18:18009|ajp://10.217.128.31:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|ajp://10.228.4.19:18009|ajp://10.217.128.32:18009|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|Listen 192.168.17.210:80|Listen 10.217.127.21:80|g' /web/apache/2.4.29/conf.d/vhost.conf 
  sed -i -e 's|Listen 192.168.17.210:443|Listen 10.217.127.21:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|VirtualHost 192.168.17.210:80|VirtualHost 10.217.127.21:80|g' /web/apache/2.4.29/conf.d/vhost.conf
  sed -i -e 's|VirtualHost 192.168.17.210:443|VirtualHost 10.217.127.21:443|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCertificateFile /web/apache/current/conf/ssl/ep_clcert.crt|SSLCertificateFile /web/apache/current/conf/ssl/origin.edgepark.com.pem|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCertificateKeyFile /web/apache/current/conf/ssl/ep_key.crt|SSLCertificateKeyFile /web/apache/current/conf/ssl/origin.edgepark.com.key|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
  sed -i -e 's|SSLCACertificateFile /web/apache/current/conf/ssl/ep_cacerts.crt|SSLCACertificateFile /web/apache/current/conf/ssl/bundle.pem|g' /web/apache/2.4.29/conf.d/vhost-ssl-enabled.conf
fi

# Create a symbolic link to redirect the Apache logs into the standard logging directory. Check first to see if the directory already exists, if so remove it as we'll be recreating it.
echo "Creating symbolic link for this installation of Apaches log files to the system log files. e.g. /var/log/httpd24"
if [ -d "/web/apache/2.4.29/logs" ];then 
  rm -rf "/web/apache/2.4.29/logs"
fi

if [ ! -d "/var/log/httpd24" ];then 
  mkdir "/var/log/httpd24"
fi

ln -sfn /var/log/httpd24 /web/apache/2.4.29/logs

echo "Changing User & Group ownership for new Apache installation to 'webadm'."
chown -R webadm:webadm /web/apache/2.4.29
echo -e "..."

# Now check if it all went according to plan.
if [ $? -eq 0 ];then
  echo "Great Success! You should be ready to start the web server."
else
  echo "Uh-oh, call your local 'Ghost Buster' (sysadmin) for help. Alternatively try running this script again with debugging turned on, and possibly the 'root' user. e.g. bash -x ApacheConversion_22to24.sh"
  echo "$?" 
fi
