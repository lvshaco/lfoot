#!/bin/bash

yum install -y net-tools

# shadowsocks
yum install -y python-setuptools
easy_install pip
pip install shadowsocks
cat > /etc/shadowsocks.json << EOF
{
 "server":"0.0.0.0",
 "local_address": "127.0.0.1",
 "local_port":1080,
 "port_password": {
        "19001": "abwiehs82%*&8202!29EFG",
        "19002": "abwiehs82%*&8202!29EFG",
        "19003": "abwiehs82%*&8202!29EFG",
        "19004": "abwiehs82%*&8202!29EFG",
        "19005": "abwiehs82%*&8202!29EFG",
        "18000": "abwiehs82%*&8202!29EFG"
},
 "timeout":300,
 "method":"aes-192-cfb",
 "fast_open": false
}
EOF
cat > /etc/systemd/system/shadowsocks.service << EOF
[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json
[Install]
WantedBy=multi-user.target
EOF
systemctl enable shadowsocks
systemctl start shadowsocks
#ssserver -c /etc/shadowsocks.json -d start
## ssserver -c /etc/shadowsocks.json -d stop

firewall-cmd --zone=public --add-port=19000-19100/tcp --permanent
firewall-cmd --zone=public --add-port=18000-18100/tcp --permanent
firewall-cmd --reload

#----------------------------------------------
# TCP BBR拥塞算法
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y

#更新grub文件并重启
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0
reboot

## 开机后验证
#uname -r
#
## 启动TCP BBR
#echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
#sysctl -p
#
## 验证
#sysctl net.ipv4.tcp_available_congestion_control
#sysctl net.ipv4.tcp_congestion_control
#lsmod | grep bbr

## 无用了 ---------------------
#wget https://sourceforge.net/projects/leanote-bin/files/2.6.1/leanote-linux-amd64-v2.6.1.bin.tar.gz/download
#tar -xf download
#yum -y install mongodb-server mongodb
#systemctl enable mongod
#systemctl start mongod
#mongorestore -h localhost -d leanote --dir ~/leanote/mongodb_backup/leanote_install_data/
## vi ~/leanote/conf/app.conf 修改site.url 改为具体IP, 用浏览器访问注册帐号后再改回去不让访问
#
## leanote
#firewall-cmd --zone=public --add-port=9000/tcp --permanent
#firewall-cmd --reload
#
#cat > /etc/systemd/system/leanote.service << EOF
#[Unit]
#Description=leanote
#[Service]
#TimeoutStartSec=0
#ExecStart=/usr/bin/bash /root/leanote/bin/run.sh
#[Install]
#WantedBy=multi-user.target
#EOF
#systemctl enable leanote
#systemctl start leanote
