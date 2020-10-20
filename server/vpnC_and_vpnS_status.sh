#!/usr/bin/bash
ps -ax | grep 'udp2raw_amd64 -s' | grep -v grep 1>/dev/null 2>&1
if [ $? -ne 0 ];then
        /root/server_vpn.sh
        echo "`date` The VPN server was stopped, exec the server_vpn.sh script ! " >>/var/log/udp2raw.log
else
  echo "The VPN server is running...! " 1>/dev/null 2>&1
fi
ps -ax | grep 'udp2raw_amd64 -c' | grep -v grep 1>/dev/null 2>&1
if [ $? -ne 0 ];then
        /root/client_vpn.sh
        echo "`date` The VPN client was stopped, exec the client_vpn.sh script ! " >>/var/log/udp2raw.log
else
  echo "The VPN client is running...! " 1>/dev/null 2>&1
fi
