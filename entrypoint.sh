echo "nameserver 8.8.8.8" > /etc/resolv.conf
freeswitch -nc -nonat ; tail -f /usr/local/freeswitch/log/freeswitch.log
