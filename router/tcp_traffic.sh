#捕获通过tun0出去的流量，按照数据包对目的IP拍卖，10.8.0.5 需要修改为你实际VPN的网卡地址
tcpdump -i tun0 -nn -c 1000 > aaa.txt
cat aaa.txt | awk '{print $5}' | grep -v '10.8.0.5' | sort | uniq -c | sort -nr
