#!/usr/bin/bash
ps -ef | grep '/root/udp2raw/udp2raw_amd64' | grep -v grep | awk '{print $2}' | xargs kill -9
/root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50000 -r 127.0.0.1:1198 --raw-mode faketcp -k huayu888 --fix-gro &
/root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50001 -r 127.0.0.1:1199 --raw-mode faketcp -k huayu888 --fix-gro &
/root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50002 -r 127.0.0.1:1120 --raw-mode faketcp -k huayu888 --fix-gro &
/root/tc6M_tun0.sh
/root/tc6M_tun1.sh
/root/tc6M_tun2.sh
