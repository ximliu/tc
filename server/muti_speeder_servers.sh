#!/usr/bin/bash
ps -ef | grep '/root/udp2raw/udp2raw_amd64' | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep '/root/speeder/speederv2_amd64' | grep -v grep | awk '{print $2}' | xargs kill -9
nohup /root/speeder/speederv2_amd64 -s -l 0.0.0.0:50000 -r 127.0.0.1:1198 -f20:5 -i 8 -k huayu888 --mode 1 >/var/log/speederv2.log &
nohup /root/speeder/speederv2_amd64 -s -l 0.0.0.0:50001 -r 127.0.0.1:1199 -f20:5 -i 8 -k huayu888 --mode 1 >/var/log/speederv2.log &
#/root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50000 -r 127.0.0.1:1198 --raw-mode faketcp -k huayu888 --fix-gro &
#/root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50001 -r 127.0.0.1:1199 --raw-mode faketcp -k huayu888 --fix-gro &
/root/tc6M_tun0.sh
/root/tc6M_tun1.sh
