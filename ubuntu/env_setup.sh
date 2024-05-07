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
    wget https://sourceforge.net/projects/geographiclib/files/distrib/GeographicLib-2.3.tar.gz
    tar xvf GeographicLib-2.3.tar.gz
    rm -rf GeographicLib-2.3.tar.gz
    cd GeographicLib-2.3
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

# 下载并安装boost
function setup_boost() {
    wget https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.gz
    tar xvf boost_1_84_0.tar.gz
    rm -rf boost_1_84_0.tar.gz
    cd boost_1_84_0
    ./bootstrap.sh --with-libraries=system,serialization
    ./b2
    sudo ./b2 install
    cd $workdir
}

# 下载并安装opencv
function setup_opencv {
    sudo apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev &&
        sudo apt-get install -y libjpeg-dev libpng-dev &&
        git clone https://github.com/opencv/opencv.git -b 3.4.5 &&
        cd opencv &&
        mkdir build && cd build &&
        cmake -DCMAKE_BUILD_TYPE=Release \
            -DBUILD_LIST=videoio,imgcodec,highgui \
            -DWITH_JPEG=ON \
            -DWITH_PNG=ON \
            -DWITH_TIFF=OFF \
            -DWITH_WEBP=OFF \
            -DWITH_OPENJPEG=OFF \
            -DWITH_JASPER=OFF \
            -DWITH_OPENEXR=OFF \
            -DWITH_V4L=OFF \
            -DWITH_FFMPEG=OFF \
            -DWITH_GSTREAMER=OFF \
            -DWITH_MSMF=OFF \
            -DWITH_AVFOUNDATION=OFF \
            -DWITH_1394=OFF \
            -DBUILD_OPENCL=OFF \
            -DBUILD_TESTS=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DBUILD_EXAMPLES=OFF \
            -DBUILD_opencv_apps=OFF \
            -DBUILD_SHARED_LIBS=on \
            -DCMAKE_INSTALL_PREFIX=/usr/local .. &&
        make -j4 &&
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
select option in "Only setup env" "Setup and clean"; do
    case $option in
    "Only setup env")
        run
        break
        ;;
    "Setup and clean")
        run
        clean
        break
        ;;
    *)
        echo "Invalid option."
        ;;
    esac
done
echo "Environment setup done."
exit 1
