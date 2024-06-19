#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"


#add the includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#send a message
verbose "Configuring IPTables"


#remove ufw
ufw reset
ufw disable
apt-get remove -y ufw
#apt-get purge ufw
iptables --delete-chain ufw-after-forward
iptables --delete-chain ufw-after-input
iptables --delete-chain ufw-after-logging-forward
iptables --delete-chain ufw-after-logging-input
iptables --delete-chain ufw-after-logging-output
iptables --delete-chain ufw-after-output
iptables --delete-chain ufw-before-forward
iptables --delete-chain ufw-before-input
iptables --delete-chain ufw-before-logging-forward
iptables --delete-chain ufw-before-logging-input
iptables --delete-chain ufw-before-logging-output
iptables --delete-chain ufw-before-output
iptables --delete-chain ufw-reject-forward
iptables --delete-chain ufw-reject-input
iptables --delete-chain ufw-reject-output
iptables --delete-chain ufw-track-forward
iptables --delete-chain ufw-track-input
iptables --delete-chain ufw-track-output

#flush iptables
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F

#run iptables commands
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# posgresql
iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
iptables -A INPUT -p udp --dport 5432 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#save iptables to make it persistent
#mkdir /etc/iptables
#iptables-save > /etc/iptables/rules.v4

#answer the questions for iptables persistent and save the iptable rules
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get install -y iptables-persistent
