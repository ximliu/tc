sleep 1
#
server1='1.1.1.1'
server2='2.2.2.2'
server3='3.3.3.3'
server4='4.4.4.4'
server5='5.5.5.5'
gateWay=$(ip route show 0/0 | sed -e 's/^default//')
#------------------------------------------------------------------------------------
#udp2raw需要做的
ServerList=("$server1" "$server2" "$server3" "$server4" "$server5")
for p in "${ServerList[@]}"
do
        iptables -D INPUT -s $p -p tcp -m tcp --sport 50000 -j DROP
        iptables -I INPUT -s $p -p tcp -m tcp --sport 50000 -j DROP
done
echo '停止udp2raw 和openvpn客户端'
ps -ef | grep udp2raw_amd64 | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep openvpn | grep -v grep | awk '{print $2}' | xargs kill -9
#------------------------------------------------------------------------------------
echo '启动第一阶段udp2raw'
/root/udp2raw/udp2raw_amd64 -c -r$server1:50000 -l 127.0.0.1:1198 --raw-mode faketcp  -k huayu888 &
/root/udp2raw/udp2raw_amd64 -c -r$server2:50000 -l 127.0.0.1:1199 --raw-mode faketcp  -k huayu888 &
echo '启动openvpn客户端'
/usr/sbin/openvpn /etc/openvpn/client/client.ovpn >/dev/null &
echo '启动dnsmasq'
echo 'nameserver 127.0.0.1' > /etc/resolv.conf
systemctl restart dnsmasq
echo '启动第二阶段udp2raw'
/root/udp2raw/udp2raw_amd64 -c -r$server4:50000 -l 127.0.0.1:1120 --raw-mode faketcp -k huayu888 &
/root/udp2raw/udp2raw_amd64 -c -r$server5:50000 -l 127.0.0.1:1121 --raw-mode faketcp -k huayu888 &
sleep 5
echo '启动第二阶段 openvpn客户端'
/usr/sbin/openvpn /etc/openvpn/client/client2.ovpn >/dev/null &
sleep 6
#确定哪些地址走第二阶段
#ip rule add from 192.168.74.0/24 table 20 pri 20
#tun1 的默认路由到openvpn服务器
/usr/sbin/ip route add default via 172.16.2.1 dev tun1 table 20
#
echo '执行完成'
echo "`date` 重新启动了mutiUDP2raw.sh " >> /var/log/udp2raw.log
