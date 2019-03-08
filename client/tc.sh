#!/bin/sh -x
# 带宽设置,单位为kbits/s
#定义链路带宽
LinkCeilDownSpeed=4000            #链路最大下载带宽
LinkCeilUploadSpeed=4000          #链路最大上传带宽
LinkRateDownSpeed=4000           #链路保障下载带宽
LinkRateUploadSpeed=4000         #链路保障上传带宽

#定义特殊用户，可以是IP，也可以是网段，例如192.168.0.0/24
SpeedIPaddr='192.168.0.100'

UserCeilDownSpeed=4000         #特殊用户最大下载带宽
UserCeilUploadSpeed=4000       #特殊用户最大上传带宽
UserRateDownSpeed=1000        #特殊用户保障下载带宽
UserRateUploadSpeed=1000      #特殊用户保障上传带宽

#定义除了特殊用户外的其他用户
OtherCeilDownSpeed=4000             #其他用户最大下载带宽
OtherCeilUploadSpeed=4000           #其他用户最大上传带宽
OtherRateDownSpeed=3000            #其他用户保障下载带宽
OtherRateUploadSpeed=3000          #其他用户保障上传带宽


# 互联网接口
EXTDEV=tun1

# 加载 IFB
modprobe ifb
ip link set dev ifb1 down

# 清除接口上的队列及 mangle 表
tc qdisc del dev $EXTDEV root    2> /dev/null > /dev/null
tc qdisc del dev $EXTDEV ingress 2> /dev/null > /dev/null
tc qdisc del dev ifb1 root       2> /dev/null > /dev/null
tc qdisc del dev ifb1 ingress    2> /dev/null > /dev/null
iptables -t mangle -F
iptables -t mangle -X QOS

# appending "stop" (without quotes) after the name of the script stops here.
if [ "$1" = "stop" ]
then
        echo "Shaping removed on $EXTDEV."
        exit
fi


#以下是上传限速
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
tc qdisc add dev $EXTDEV root handle 1: htb default 12
tc class add dev $EXTDEV parent 1: classid 1:1 htb rate ${LinkRateUploadSpeed}kbit ceil ${LinkCeilUploadSpeed}kbit
tc class add dev $EXTDEV parent 1:1 classid 1:10 htb rate ${UserRateUploadSpeed}kbit ceil ${UserCeilUploadSpeed}kbit
tc class add dev $EXTDEV parent 1:1 classid 1:12 htb rate ${OtherRateUploadSpeed}kbit ceil ${OtherCeilUploadSpeed}kbit

#被iptables 标记为101 的使用 1:10
tc filter add dev $EXTDEV protocol ip parent 1:0 prio 1 handle 101 fw flowid 1:10

tc qdisc add dev $EXTDEV parent 1:10 handle 20: sfq perturb 10
tc qdisc add dev $EXTDEV parent 1:12 handle 40: sfq perturb 10

#来自$SpeedIPaddr 的流量被标记为101
iptables -t mangle -A POSTROUTING -o $EXTDEV -s $SpeedIPaddr -j MARK --set-mark 101
iptables -t mangle -A POSTROUTING -o $EXTDEV ! -s $SpeedIPaddr -j MARK --set-mark 102


#以下是下载限速

ip link set dev ifb1 up

# HTB classes on IFB with rate limiting
tc qdisc add dev ifb1 root handle 1: htb default 12
tc class add dev ifb1 parent 1: classid 1:1 htb rate ${LinkRateDownSpeed}kbit ceil ${LinkCeilDownSpeed}kbit
tc class add dev ifb1 parent 1:1 classid 1:10 htb rate ${UserRateDownSpeed}kbit ceil ${UserCeilDownSpeed}kbit
tc class add dev ifb1 parent 1:1 classid 1:12 htb rate ${OtherRateDownSpeed}kbit ceil ${OtherCeilDownSpeed}kbit

# 被iptables 标记为 "201" on 使用 class 1:10
tc filter add dev ifb1 parent 1:0 protocol ip handle 201 fw flowid 1:10

# 源地址为 $SpeedIPaddr  下行流量 被标记为 "201"
iptables -t mangle -N QOS
iptables -t mangle -A FORWARD -o $EXTDEV -j QOS
iptables -t mangle -A OUTPUT -o $EXTDEV -j QOS
iptables -t mangle -A QOS -j CONNMARK --restore-mark
iptables -t mangle -A QOS -s $SpeedIPaddr -m mark --mark 0 -j MARK --set-mark 201
iptables -t mangle -A QOS -j CONNMARK --save-mark

# Forward all ingress traffic on internet interface to the IFB device
tc qdisc add dev $EXTDEV ingress handle ffff:
tc filter add dev $EXTDEV parent ffff: protocol ip \
        u32 match u32 0 0 \
        action connmark \
        action mirred egress redirect dev ifb1 \
        flowid ffff:1

exit 0
