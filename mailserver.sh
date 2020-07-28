#!/bin/bash

# Add iptables variable
IPTS=(iptables ip6tables)

for IPT in ${IPTS[@]}
do
	# Allow loopback
	$IPT -A INPUT -i lo -j ACCEPT
	$IPT -A OUTPUT -o lo -j ACCEPT

	# Set deafult policies
	$IPT -P INPUT DROP
	$IPT -P OUTPUT DROP
	$IPT -P FORWARD DROP

	# Allow running traffic
	$IPT -A OUTPUT -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
	$IPT -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

	# Allow icmp traffic
	$IPT -A INPUT -p icmp -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

	# Allow SSH IN GENRRAL
	$IPT -A INPUT -p tcp -m conntrack --ctstate NEW --dport 22 -j ACCEPT 

	# Accepted ports for firewall
	PORTS=(25 80 110 143 443 465 587 993 995)

	for PORT in ${PORTS[@]}
	do
		$IPT -A INPUT -p tcp -m conntrack --ctstate NEW --dport $PORT -j ACCEPT
	done
done