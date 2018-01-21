#!/bin/bash -ev

# I use export, so must use source
if [[ ! $0 =~ "bash" ]]; then
	echo "Use source to execute this script!"
	return 1
fi
if [ $# -lt 1 ]; then
	echo "Need type param!"
	return 1
fi
remoteinit() {
	itype=$1
	echo "*Copy sshkey file to remote host*"
	read -p "host:" host
	read -p "sshkey file:" sshkey_file
	ssh-copy-id -i ~/.ssh/$sshkey_file.pub $host

	scp ~/.ssh/id_rsa_lvshaco ~/.ssh/config $host:~/.ssh/

	ssh $host "yum install -y git && \
		mkdir -pv /Downloads && \
		mkdir -pv /Code && \
		cd /Code && \
		git clone git@github.com:lvshaco/lfoot.git && \
		git clone git@github.com:lvshaco/lvvim.git"

	scp ~/Downloads/go1.9.2.linux-amd64.tar $host:/Downloads/

	ssh $host "source ~/.bash_profile && source /Code/lfoot/${itype}_init.sh"
}

remoteinit $1
