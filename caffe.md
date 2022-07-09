caffe centos7 安装
===
环境： conda -n create caffe tensorflow=1 python=2.7.5

yum install -y epel-release
yum install -y leveldb-devel protobuf-devel snappy-devel opencv-devel boost-devel hdf5-devel atlas-devel
yum install -y gflags-devel glog-devel lmdb-devel
yum install -y openblas-devel
yum install -y gcc gcc-c++

git clone https://github.com/BVLC/caffe.git

cd caffe
mv Makefile.config.example Makefile.config
```
vi Makefile.config
去掉CPU_ONLY :=1前面#号
```

make all -j8

安装pycaffe
yum install -y python-pip
yum install -y python-devel
进入caffe/python目录: pip install -r requirements.txt
make pycaffe

配置环境变量

#export PYTHONPATH=/home/{user}/caffe/python:$PYTHONPATH
#LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/usr/lib64:$LD_LIBRARY_PATH

#python
>>Import caffe

问题
===
1. 找不到google/protobuf/port_def.inc文件
```
protobuf版本不对，yum install protobuf-devel安装的是2.5，需要2.6
wget https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.7.0.tar.gz
tar xvf v3.7.0.tar.gz
cd protobuf-3.7.0
./configure
make -j8
make check
make install
```
2. #error This file requires compiler and library support for the ISO C++ 2011 standard. This support is currently experimental, and must be enabled with the -std=c++11 or -std=gnu++11 compiler options.
Makefile中COMMON_FLAGS后加入-std=c++11

3. 找不到 -lcblas -latlas
先确定Makefile.config里面是否有配置了 BLAS_LIB 和BLAS_INCLUDE ，去掉前面的#号。并且检查atlas路径是否和配置文件的路径一致（可以通过whereis atlas查看所在路径）
然后确认atlas路径下是否包含libcblas.so和libatlas.so如果没有是因为 ATLAS现在的名称变了，要新建一下软连
#ln -sv libsatlas.so.3.10 libcblas.so
#ln -sv libsatlas.so.3.10 libatlas.so
一般是以下路径
BLAS_INCLUDE := /usr/include/atlas
BLAS_LIB := /usr/lib64/atlas

4. make pycaffe出错：python/caffe/_caffe.hpp:8:31: fatal error: numpy/arrayobject.h: No such file or directory
因为numpy没有被找到.
Makefile.config中修改 PYTHON_INCLUDE := /usr/include/python2.7 \
/usr/lib64/python2.7/site-packages/numpy/core/include
