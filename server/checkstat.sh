#!/usr/bin/bash
udp2raw_count="`ps aux|grep udp2raw_amd64|grep -v 'grep'|wc -l`"
if [ $udp2raw_count -ne 3 ];then
  ps -ef | grep '/root/udp2raw/udp2raw_amd64' | grep -v grep | awk '{print $2}' | xargs kill -9
  /root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50000 -r 127.0.0.1:1198 --raw-mode faketcp -k huayu888 --fix-gro --cipher-mode xor --auth-mode simple &
  /root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50001 -r 127.0.0.1:1199 --raw-mode faketcp -k huayu888 --fix-gro --cipher-mode xor --auth-mode simple &
  /root/udp2raw/udp2raw_amd64 -s -l0.0.0.0:50002 -r 127.0.0.1:1120 --raw-mode faketcp -k huayu888 --fix-gro --cipher-mode xor --auth-mode simple &
  echo "udp2raw stopped,Start udp2raw! `date`" >>/var/log/udp2raw.log
else
  #echo $udp2raw_count
  echo "udp2raw is up and running...!  `date`" 1>/dev/null 2>&1
fi
