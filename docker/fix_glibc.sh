# !/bin/bash

# 该脚本用于修复 glibc 版本问题 (vscode 1.86 版本之后要求 glibc 版本 >= 2.28)
set -e
cd "$(dirname "$0")"

# 输入 docker 容器名称
read -p "请输入 docker 容器名称 [DEFAULT: stellauto]: " container
container=${container:-stellauto}
echo "Docker 容器名称: $container."

# 检查 docker 容器是否存在
result=$(docker inspect --format="{{.State.Running}}" $container 2>/dev/null)
if [ "$result" == "true" ]; then
    echo "Docker 容器 $container 存在且正在运行. 重启容器..."
    docker stop $container
    docker start $container
elif [ "$result" == "false" ]; then
    echo "Docker 容器 $container 存在但未运行. 启动容器..."
    docker start $container
else
    echo "Docker 容器 $container 不存在."
    exit 0
fi

# 复制 glibc (2.28) 到 docker 容器
docker cp resource/glibc-2.28.tar.gz $container:/home/stella/
# 复制 patchelf 到 docker 容器
docker cp resource/patchelf $container:/home/stella/

# 复制 fix.sh 到 docker 容器
docker cp resource/fix.sh $container:/home/stella/

# 进入 docker 容器并执行 fix.sh
docker exec -it $container /bin/bash /home/stella/fix.sh

echo "修复完成."
