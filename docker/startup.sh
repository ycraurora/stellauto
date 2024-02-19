#! /bin/bash

# 判断本地是否存在docker镜像ycrad/stellauto:latest
if [ -z "$(docker images -q ycrad/stellauto:latest 2> /dev/null)" ]; then
  # 不存在镜像，则拉取该镜像
  echo "不存在镜像ycrad/stellauto:latest，正在拉取..."
  docker pull ycrad/stellauto:latest
fi

# 判断本地是否存在使用该镜像的容器
if [ -z "$(docker ps -a --filter ancestor=ycrad/stellauto:latest --format '{{.ID}}')" ]; then
  # 不存在容器，则新建一个名为stellauto的容器
  echo "不存在使用镜像ycrad/stellauto:latest的容器，正在新建..."
  docker run -it -d -u stella -p 23459:23459 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name stellauto ycrad/stellauto:latest
fi

# 获取容器的ID
container_id=$(docker ps -a --filter ancestor=ycrad/stellauto:latest --format '{{.ID}}')
# 判断容器是否在运行
if [ "$(docker inspect -f '{{.State.Running}}' $container_id)" = "true" ]; then
  # 容器在运行，则直接启动该容器
  echo "容器$container_id已经在运行，无需启动"
else
  # 容器不在运行，则启动该容器
  echo "容器$container_id不在运行，正在启动..."
  docker start $container_id
fi
