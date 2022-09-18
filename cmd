#!/bin/bash
echo 清除SVN未版控文件
echo "svn st | grep '^?' | awk '{print $2}' | xargs rm -rf"
