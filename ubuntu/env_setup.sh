#! /bin/bash

##!@AUTHOR: ycrad
##!Automatic setup environment requirments for StellaAutonomous System.
set -e

# 下载并安装cmake-3.28.3
function setup_cmake() {
    wget https://github.com/Kitware/CMake/releases/download/v3.28.3/cmake-3.28.3.tar.gz
    tar xvf cmake-3.28.3.tar.gz
    rm -rf cmake-3.28.3.tar.gz
    cd cmake-3.28.3
    ./bootstrap
    make -j4
    sudo make install
    cd $workdir
}

# 下载并安装GeographicLib-1.48
function setup_geolib() {
    wget https://sourceforge.net/projects/geographiclib/files/distrib/GeographicLib-1.48.tar.gz
    tar xvf GeographicLib-1.48.tar.gz
    rm -rf GeographicLib-1.48.tar.gz
    cd GeographicLib-1.48
    mkdir build && cd build
    cmake ..
    make -j4
    sudo make install
    cd $workdir
}

# 下载并安装gflags
function setup_gflags() {
    git clone https://github.com/gflags/gflags.git
    cd gflags
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=on -DGFLAGS_NAMESPACE=google -G "Unix Makefiles" ..
    make -j4
    sudo make install
    cd $workdir
}

# 下载并安装glog
function setup_glog() {
    git clone https://github.com/google/glog.git
    cd glog
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=on -G "Unix Makefiles" ..
    make -j4
    sudo make install
    cd $workdir
}

# 下载并安装boost
function setup_boost() {
    wget https://boostorg.jfrog.io/artifactory/main/release/1.65.1/source/boost_1_65_1.tar.gz
    tar xvf boost_1_65_1.tar.gz
    rm -rf boost_1_65_1.tar.gz
    cd boost_1_65_1
    ./bootstrap.sh
    ./b2
    sudo ./b2 install
    cd $workdir
}

# 下载并安装opencv
function setup_opencv {
    sudo apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
    sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
    git clone https://gitee.com/opencv/opencv.git -b 3.4.5
    cd opencv
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
    make -j4
    sudo make install
    cd $workdir
}

# 执行
function run() {
    sudo apt-get install -y gcc g++ git make gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libpugixml-dev wget unzip libssl-dev build-essential
    cd $defaultdir
    if [ -e workspace ]; then
        cd workspace
    else
        mkdir workspace && cd workspace
    fi
    if [ -e third ]; then
        cd third
    else
        mkdir third && cd third
    fi
    setup_cmake
    setup_geolib
    setup_gflags
    setup_glog
    setup_boost
    setup_opencv
    cd $defaultdir
}

# 清理
function clean() {
    rm -rf ~/workspace/third
}

# 默认路径
defautdir=~
# 工作路径
workdir=~/workspace/third
# 简单的选项菜单
PS3="Enter option: "
select option in "Only setup env" "Setup and clean"
do
    case $option in
    "Only setup env")
    run 
    break ;;
    "Setup and clean")
    run
    clean 
    break ;;
    *)
    echo "Invalid option." ;;
    esac
done
echo "Environment setup done."
exit 1
