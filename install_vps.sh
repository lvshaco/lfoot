#!/bin/bash

yum install -y net-tools

# shadowsocks
yum install -y python-setuptools
easy_install pip
pip install shadowsocks
# 设置 /etc/shadowsocks.json
#{
# "server":"0.0.0.0",
# "local_address": "127.0.0.1",
# "local_port":1080,
# "port_password": {
#        "19001": "pass",
#        "19002": "pass",
#        "19003": "pass",
#        "19004": "pass",
#        "19005": "pass"
#},
# "timeout":300,
# "method":"aes-256-cfb",
# "fast_open": false
#}
ssserver -c /etc/shadowsocks.json -d start
## ssserver -c /etc/shadowsocks.json -d stop

firewall-cmd --zone=public --add-port=19001/tcp --permanent
firewall-cmd --zone=public --add-port=19002/tcp --permanent
firewall-cmd --zone=public --add-port=19003/tcp --permanent
firewall-cmd --zone=public --add-port=19004/tcp --permanent
firewall-cmd --zone=public --add-port=19005/tcp --permanent
firewall-cmd --reload

wget https://sourceforge.net/projects/leanote-bin/files/2.6.1/leanote-linux-amd64-v2.6.1.bin.tar.gz/download
tar -xf download
yum -y install mongodb-server mongodb
systemctl enable mongod
systemctl start mongod
mongorestore -h localhost -d leanote --dir ~/leanote/mongodb_backup/leanote_install_data/
# vi ~leanote/conf/app.conf 修改site.url 改为具体IP, 用浏览器访问注册帐号后再改回去不让访问

# leanote
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload
