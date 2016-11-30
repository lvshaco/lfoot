#!/usr/local/bin/python
#-*- coding: utf-8 -*-

import time
import requests

s = requests.session()
id_number = ''
password = ''

file_object = open('account.txt')
content = file_object.readlines()
id_number = content[0].strip('\n')
password = content[1]

login = s.post("http://www.jppt.com.cn/gzpt/index/login", {'loginType':'1', 'sfzmhm':id_number, 'password':password})
print login.text

info = s.get("http://www.jppt.com.cn/gzpt/")
info = info.text

def cut(tag, n):
    pos1 = info.index(tag)
    pos2 = pos1+len(tag) + n
    return info[pos1:pos2]

print cut(u"<li>总培训时间：<span>", 11)
print cut(u"<li>当日完成学时：<span>", 11)
