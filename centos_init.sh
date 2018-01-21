#!/bin/bash -ev

# I use export, so must use source
if [[ ! $0 =~ "bash" ]]; then
	echo "Use source to execute this script!"
	return 1
fi

# use aliyun mirrors
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -L http://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache

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

# use `git difftool`
git config --global diff.tool vimdiff
git config --global difftool.prompt No

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

[[ -d /Code/lfoot ]] || git clone git@github.com:lvshaco/lfoot.git /Code/lfoot
[[ -d /Code/lvvim ]] || git clone git@github.com:lvshaco/lvvim.git /Code/lvvim

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
if [[ ! "$GOPATH" =~ "$HOME/go" ]]; then
	export GOPATH=$HOME/go
	echo export GOPATH=\$HOME/go >> ~/.bash_profile
fi
if [[ ! "$PATH" =~ "$HOME/go/bin:$GOROOT/bin" ]]; then
	export PATH=$HOME/go/bin:$GOROOT/bin:$PATH
	echo export PATH=\$HOME/go/bin:\$GOROOT/bin:\$PATH >> ~/.bash_profile
fi

#
if [ ! -e ~/bin ]; then
    ln -s /Code/lfoot ~/bin
fi
if [ ! -e ~/code ]; then
    ln -s /Code ~/code
fi

cd /code/lvvim && make && cd -
cp ~/gitdiffwrap /usr/bin/
cp ~/svndiffwrap /usr/bin/
