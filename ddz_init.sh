#!/bin/bash -ev

# I use export, so must use source
if [ $0 != "-bash" ]; then
	echo "Use `source` to execute this script!"
	exit 1
fi

dir=`dirname "$0"`
source $dir/centos_init.sh

# go path
MYLIB_PATH="\$HOME/ddz/Server/tool"
if [[ ! "$GOPATH" =~ "$MYLIB_PATH" ]]; then
	export GOPATH=$MYLIB_PATH:\$GOPATH
	echo export GOPATH=$MYLIB_PATH:\$GOPATH >> ~/.bash_profile
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
exit 1
# ddz
cd ~
if [ ! -e ddz ]; then
	git clone https://github.com/lvshaco/ddz.git
fi
cd ddz && ./foot build
