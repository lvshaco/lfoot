#!/bin/bash -ev

# I use export, so must use source
if [[ ! $0 =~ "bash" ]]; then
	echo "Use source to execute this script!"
	return 1
fi
dir=$(cd $(dirname $BASH_SOURCE) && pwd)
source $dir/centos_init.sh

# go path
if [[ ! "$GOPATH" =~ "$MYLIB_PATH" ]]; then
	export GOPATH=$HOME/ddz/Server/tool:$GOPATH
	echo export GOPATH=\$HOME/ddz/Server/tool:\$GOPATH >> ~/.bash_profile
fi

# ddz golang lib
libs=("github.com/golang/protobuf/protoc-gen-go"
"github.com/golang/protobuf/proto")
for lib in ${libs[@]}; do
	go get $lib &&
	cd ~/go/src/$lib  &&
	go build && go install &&
	cd -
done

# ddz
cd ~
if [ ! -e ddz ]; then
	git clone https://github.com/lvshaco/ddz.git
fi
cd ddz && ./foot build
