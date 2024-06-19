#!/bin/sh

#make sure lsb release is installed
apt-get install -y lsb-release

#operating system details
os_name=$(lsb_release -is)
os_codename=$(lsb_release -cs)
os_mode='unknown'

#cpu details
cpu_name=$(uname -m)
cpu_architecture='unknown'
cpu_mode='unknown'

#set the environment path
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ .$cpu_name = .'x86_64' ]; then
	os_mode='64'
	if [ .$(grep -o -w 'lm' /proc/cpuinfo | head -n 1) = .'lm' ]; then
		cpu_mode='64'
	else
		cpu_mode='32'
	fi
	cpu_architecture='x86'
else
	error "You are using an unsupported cpu '$cpu_name'"
	exit 3
fi

if [ .$cpu_architecture = .'x86' ]; then
	if [ .$os_mode = .'64' ]; then
		verbose "Correct CPU and Operating System detected"
	else
		error "Unknown Operating System mode '$os_mode' is unsupported"
		exit 3
	fi
else
	error "You are using an unsupported architecture '$cpu_architecture'"
	warning "Detected environment was :-"
	warning "os_name:'$os_name'"
	warning "os_codename:'$os_codename'"
	warning "os_mode:'$os_mode'"
	warning "cpu_name:'$cpu_name'"
	exit 3
fi

if [ .$os_name = .'Debian' ]; then
	if [ .$os_codename = .'bookworm' ]; then
		verbose "Correct Operating System"
	else
		error "Unsupported Operating System codename '$os_codename'"
		exit 3
	fi
else
	error "Unsupported Operating System '$os_mode'"
	exit 3
fi