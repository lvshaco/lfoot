#!/bin/bash -ev

# I use export, so must use source
if [ $0 != "-bash" ]; then
	echo "Use source to execute this script!"
	exit 1
fi

# install base
yum install -y epel-release
yum update -y
yum upgrade -y
yum install -y man \
	man-pages.noarch \
	man-pages-overrides.noarch \
	net-tools \
	telnet \
	wget \
	vim \
	tmux \
	git \
	gcc-c++ \
	make \
	cmake \
	file \
	python-devel \
	ctags \
	cscope

# 将硬件时钟调整为与本地时钟一致, 0 为设为 UTC 时间
timedatectl set-local-rtc 1
# 设置系统时区为上海
timedatectl set-timezone Asia/Shanghai

## install protobuf
#PB_PKG=/Downloads/protobuf-2.6.1.tar
#tar -xf $PB_PKG -C /tmp
#cd /tmp/protobuf-2.6.1 
#./configure && make && make install 
#rm -rf protobuf-2.6.1 
#cd -

mkdir -pv /Downloads
mkdir -pv /Code
mkdir -pv /Code/go

# install golang
GO_PKG=/Downloads/go1.9.2.linux-amd64.tar
GO_WORK=/Code/go
tar -C /usr/local -xf $GO_PKG
mkdir -pv $GO_WORK 
if [ ! -e ~/go ]; then
    ln -s $GO_WORK ~/go
fi

if [[ ! "$GOROOT" =~ "/usr/local/go" ]]; then
	export GOROOT=/usr/local/go
	echo export GOROOT=/usr/local/go >> ~/.bash_profile
fi
if [[ ! "$GOPATH" =~ "\$HOME/go" ]]; then
	export GOPATH=\$HOME/go
	echo export GOPATH=\$HOME/go >> ~/.bash_profile
fi
if [[ ! "$PATH" =~ "\$GOROOT/bin" ]]; then
	export PATH=\$GOROOT/bin:\$PATH
	echo export PATH=\$GOROOT/bin:\$PATH >> ~/.bash_profile
fi

#
if [ ! -e ~/bin ]; then
    ln -s /Code/lfoot ~/bin
fi
if [ ! -e ~/code ]; then
    ln -s /Code ~/code
fi
