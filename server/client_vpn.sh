#!/usr/bin/bash
#
ip rule del from all lookup  5 pri  5 
ip rule add from all lookup  5 pri  5 
#
ip rule del from all lookup 10 pri 10
/root/chnroutes/vpn-down.sh
ip rule add from all lookup 10 pri 10
/root/chnroutes/vpn-up.sh
#
ip rule del from all lookup 15 pri 15
ip rule add from all lookup 15 pri 15
/root/dst_noVPN_route.sh
#
. /root/serverIP.sh
gateway=$(ip route show 0/0 | sed -e 's/^default//')
####### 增加服务器的 iptables 5000 端口的Drop 增加服务器路由到 Table 5 ##################################
for i in "${!server[@]}"
do
        iptables -D INPUT -s ${server[$i]} -p tcp -m tcp --sport 50000 -j DROP
        iptables -I INPUT -s ${server[$i]} -p tcp -m tcp --sport 50000 -j DROP
        ip route del ${server[$i]} $gateway  table 5
        ip route add ${server[$i]} $gateway  table 5
done
#################### '停止udp2raw 和openvpn客户端'  #######################################################
ps -ef | grep '/root/udp2raw/udp2raw_amd64 -c' | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep '/usr/sbin/openvpn /etc/openvpn/client/client.ovpn' | grep -v grep | awk '{print $2}' | xargs kill -9
#######################  #echo '启动第一阶段udp2raw' ##################################################
/root/udp2raw/udp2raw_amd64 -c -r${server[1]}:50000 -l 127.0.0.1:1298 --raw-mode faketcp -k huayu888 --fix-gro --cipher-mode xor --auth-mode simple & 
echo '启动openvpn客户端'
/usr/sbin/openvpn /etc/openvpn/client/client.ovpn >/dev/null &
echo "nameserver 8.8.8.8" >/etc/resolv.conf
echo "nameserver 8.8.4.4" >>/etc/resolv.conf
