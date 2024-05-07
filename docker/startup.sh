#! /bin/bash

while true; do
    echo "请选择需要部署的镜像: "
    echo "1. Ubuntu"
    echo "2. ROS2"
    read -p "输入选择(1/2): " image_choice

    case $image_choice in
    1)
        echo "即将部署Ubuntu镜像"
        image="stellauto"
        workdir="dev"
        break
        ;;
    2)
        echo "即将部署ROS2镜像"
        image="stellauto-ros2"
        workdir="stellauto-sim"
        break
        ;;
    *)
        echo "无效的输入。请输入 '1' 或 '2'。"
        ;;
    esac
done

set -e
# 判断本地是否存在docker镜像ycrad/$image:latest
if [ -z "$(docker images -q ycrad/$image:latest 2>/dev/null)" ]; then
    # 不存在镜像，则拉取该镜像
    echo "不存在镜像ycrad/$image:latest，正在拉取..."
    docker pull ycrad/$image:latest
fi

# 判断本地是否存在使用该镜像的容器
if [ -z "$(docker ps -a --filter ancestor=ycrad/$image:latest --format '{{.ID}}')" ]; then
    # 不存在容器，则新建一个名为$image的容器
    echo "不存在使用镜像ycrad/$image:latest的容器，正在新建..."
    xhost +
    docker run -it -d -u stella --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name $image ycrad/$image:latest
    docker exec -it -u stella $image /bin/bash -c "cd ~ && mkdir workspace && mkdir workspace/$workdir"
fi

# 获取容器的ID
container_id=$(docker ps -a --filter ancestor=ycrad/$image:latest --format '{{.ID}}')
# 判断容器是否在运行
if [ "$(docker inspect -f '{{.State.Running}}' $container_id)" = "true" ]; then
    # 容器在运行，则直接启动该容器
    echo "容器$container_id 已经在运行，无需启动"
else
    # 容器不在运行，则启动该容器
    echo "容器$container_id 不在运行，正在启动..."
    docker start $container_id
fi
