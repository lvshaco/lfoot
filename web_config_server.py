#!/usr/bin/python
# -*- coding: UTF-8 -*-

import MySQLdb
import sys
import getpass

if len(sys.argv) < 3:
    print "Usage: %s fu_id server_ip"%(sys.argv[0])
    sys.exit(1)

password= getpass.getpass("qzadmin password:")
#---------------------------
# config
fu_id=int(sys.argv[1]) # 服id
server_ip=sys.argv[2]
server_port=18002
server_code=2000+fu_id
server_name="一区%d服"%fu_id
#---------------------------

platform_id=3
server_type=2
server_status=0 # 关闭
real_status=3 # 维护
is_new=0
recommend=0

dbip=server_ip

#---------------------------
# config
dbport=3306
qzd="qzd"
qzlog="qzlog"

commonip="42.51.11.104"
qzdcommon="qzdcommon"
#---------------------------

# server config
server_info = {
        'platform_id': platform_id,
        'server_code': server_code,
        'server_name': server_name,
        'ip':          server_ip,
        'port':        server_port,
        'server_type': server_type,
        'status':      server_status,
        'real_status': real_status,
        'is_new':      is_new,
        'recommend':   recommend,
        }
db = MySQLdb.connect("42.51.11.196", "qzadmin", password, "qz_data_centre")
cursor = db.cursor()

print("Server: %s %s:%d"%(server_name, server_ip, server_port))
n=cursor.execute('SELECT id FROM qdc_server WHERE server_code=%d'%(server_code))
lvalues=[]
for k, v in server_info.items(): 
    lvalues.append('%s="%s"'%(k,v))
sql='insert into qdc_server set %s'%( ','.join(lvalues))
sys.stdout.write("=> "+sql)
if n==0:
    cursor.execute(sql)
    db.commit()
    sys.stdout.write(" [done]\n")
    server_order_id=cursor.lastrowid
else:
    sys.stdout.write(" [pass]\n")
    server_order_id = cursor.fetchone()[0]

# db config
server_order_id=17
serverdb_info = [
        { 'server_id': server_order_id, 'type_name': 'game',  'db_type': 0,   'db_ip': dbip,  'db_name': qzd,     'db_port': dbport },
        { 'server_id': server_order_id, 'type_name': 'game',  'db_type': 1,   'db_ip': dbip,  'db_name': qzd,     'db_port': dbport },
        { 'server_id': server_order_id, 'type_name': 'log',   'db_type': 0,   'db_ip': dbip,  'db_name': qzlog,   'db_port': dbport },
        { 'server_id': server_order_id, 'type_name': 'log',   'db_type': 1,   'db_ip': dbip,  'db_name': qzlog,   'db_port': dbport },
        { 'server_id': server_order_id, 'type_name': 'common','db_type': 0,   'db_ip': commonip,  'db_name': qzdcommon,'db_port': dbport },
]
for one in serverdb_info:
    n=cursor.execute('SELECT *FROM qdc_server_mysql_info WHERE server_id=%d AND type_name="%s" AND db_type=%d'%(server_order_id, one['type_name'], one['db_type']))
    lvalues=[]
    for k, v in one.items(): 
        lvalues.append('%s="%s"'%(k,v))
    sql='insert into qdc_server_mysql_info set %s'%( ','.join(lvalues))
    sys.stdout.write("=> "+sql)
    if n==0:
        cursor.execute(sql)
        db.commit()
        sys.stdout.write(" [done]\n")
    else:
        sys.stdout.write(" [pass]\n")
db.close()
print("ok")
