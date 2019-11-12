#!/bin/sh
OLDGW=$(ip route show 0/0 | sed -e 's/^default//')
#苹果
ip route add 17.128.0.0/9 $OLDGW table 15
#adobe flash
ip route add 47.89.13.219/32 $OLDGW table 15
#微软网盘
ip route add 13.64.0.0/11 $OLDGW table 15
ip route add 13.96.0.0/13 $OLDGW table 15
ip route add 13.104.0.0/14 $OLDGW table 15
#微软自动更新
ip route add 13.107.4.50/32 $OLDGW table 15

#epcchem.com 企业邮箱
ip route add 54.86.81.5 $OLDGW table 15
ip route add 54.88.144.211 $OLDGW table 15
#outlook
ip route add 50.116.65.39 $OLDGW table 15
ip route add 52.98.72.178 $OLDGW table 15
#office365.com
ip route add 40.100.0.0/16 $OLDGW table 15 

#microsoft
ip route add 52.96.0.0/12 $OLDGW table 15

#akamai
ip route add 23.42.224.0/20 $OLDGW table 15

#aliyun_hk
ip route add 47.56.38.0/24  $OLDGW table 15
