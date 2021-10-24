#!/bin/bash
iptables -I FORWARD -d 192.168.69.2 -m comment --comment "Accept to forward traffic" -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -d 192.168.69.2 -m comment --comment "Accept to forward ssh traffic" -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -m comment --comment "Accept to forward return traffic" -s 192.168.69.2 -m tcp -p tcp --sport 80 -j ACCEPT
iptables -I FORWARD -m comment --comment "Accept to forward return traffic" -s 192.168.69.2 -m tcp -p tcp --sport 443 -j ACCEPT
iptables -t nat -I PREROUTING -m tcp -p tcp --dport 80 -m comment --comment "redirect pkts to client machine" -j DNAT --to-destination 192.168.69.2:80
iptables -t nat -I PREROUTING -m tcp -p tcp --dport 443 -m comment --comment "redirect pkts to client machine" -j DNAT --to-destination 192.168.69.2:443
iptables -t nat -I POSTROUTING -m comment --comment "NAT the src ip" -d 192.168.69.2 -o wg0 -j MASQUERADE
