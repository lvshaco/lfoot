#!/usr/bin/python
#_*_ coding:utf-8 _*_

# ------------------------------------------------------
# gif转化成png图片
# 例如boss_walk.gif会转化成boss/walk/00.png ~ XX.png列表
# ------------------------------------------------------

import sys
import os

if len(sys.argv) < 3:
    print "Usage: %s input_path output_path" % sys.argv[0]
    sys.exit(1)

input_path = sys.argv[1]
output_path = sys.argv[2]

for f in os.listdir(input_path):
    f_ext = os.path.splitext(f)
    ext = f_ext[-1]
    if ext == ".gif":
        f = os.path.join(input_path, f)
        if not os.path.isdir(f):
            fname = f_ext[0]
            fname_l = fname.split("_")
            out = "/".join(fname_l)
            out = os.path.join(output_path, out)
            if not os.path.exists(out):
                os.makedirs(out)
            cmd = "convert %s %s/%%02d.png"%(f, out)
            print(cmd)
            os.system(cmd)
