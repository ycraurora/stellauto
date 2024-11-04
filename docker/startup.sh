#! /bin/bash

while true; do
    echo "请选择需要部署的镜像: "
    echo "1. Ubuntu"
    echo "2. ROS2"
    echo "3. Xmake"
    read -p "输入选择(1-3): " image_choice

    case $image_choice in
    1)
        echo "即将部署 Ubuntu 镜像"
        image="stellauto"
        local_dir="/home/stella/workspace/dev/stellauto"
        break
        ;;
    2)
        echo "即将部署 ROS2 镜像"
        image="stellauto-ros2"
        local_dir="/home/stella/workspace/dev/stellauto-sim"
        break
        ;;
    3)
        echo "即将部署 Xmake 镜像"
        image="stellauto-xmake"
        local_dir="/home/stella/workspace/dev/stellauto-xmake"
        break
        ;;
    *)
        echo "无效的输入. 请输入 1-3."
        ;;
    esac
done

while true; do
    echo "请输入容器的名称: "
    read -p "输入容器名称[default: stellauto]: " container_name
    container_name=${container_name:-stellauto}
    # 判断容器名称是否存在(严格相等, 存在多个部分名称的容器需要逐个判断)
    echo ${PED} | sudo docker inspect $container_name -f '{{.Name}}' >/dev/null
    if [ $? -eq 0 ]; then
        echo "容器名称 $container_name 已经存在, 请重新输入."
    else
        echo "容器名称 $container_name 可用."
        break
    fi
done

set -e
# 判断本地是否存在docker镜像ycrad/$image:latest
if [ -z "$(docker images -q ycrad/$image:latest 2>/dev/null)" ]; then
    # 不存在镜像, 则拉取该镜像
    echo "不存在镜像 ycrad/$image:latest, 正在拉取..."
    docker pull ycrad/$image:latest
fi

# 不存在容器, 则新建一个名为$container_name的容器
echo "正在新建容器 $container_name..."
xhost +
docker run -it -d -u stella \
    --device=/dev/input/event7:/dev/input/event7 \
    --net=host -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $local_dir:/home/stella/workspace/stellauto \
    --name $container_name \
    ycrad/$image:latest

# 获取容器的ID
container_id=$(docker ps -a --filter ancestor=ycrad/$image:latest --format '{{.ID}}')
# 判断容器是否在运行
if [ "$(docker inspect -f '{{.State.Running}}' $container_id)" = "true" ]; then
    # 容器在运行, 则直接启动该容器
    echo "容器 $container_id 已经在运行, 无需启动"
else
    # 容器不在运行, 则启动该容器
    echo "容器 $container_id 不在运行, 正在启动..."
    docker start $container_id
fi
