echo '停止udp2raw 和openvpn客户端'
ps -ef | grep udp2raw_amd64 | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep openvpn | grep -v grep | awk '{print $2}' | xargs kill -9
#------------------------------------------------------------------------------------

echo '启动dnsmasq'
echo 'nameserver 114.114.114.114' > /etc/resolv.conf
systemctl restart dnsmasq
echo '执行完成'
