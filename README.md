# stellauto
StellaAutonomous System 脚本工具

详细环境部署请参看本 repo 的[Wiki](https://github.com/ycraurora/stellauto-env/wiki)

## 用法
使用 git 下载脚本至本地
```
git clone https://github.com/ycraurora/stellauto-env.git
```

### Ubuntu 配置脚本
基于 ubuntu 18.04 desktop 的开发环境配置
1. 在 ubuntu 文件夹中存在 shell 脚本 env_setup.sh：
   ```
   sudo chmod a+x env_setup.sh
   ./env_setup.sh
   ```
2. 使用 vscode 进行项目开发.

- 注意
避免将本项目或脚本放置在`~/workspace/third`中.

### docker 配置脚本
基于 docker 的开发环境配置：
- Windows
1. 于官网中下载 docker desktop 安装文件并安装;
2. 下载 ycrad/stellauto:latest 镜像, 并创建容器;
3. 使用 vscode, WSL2, dev container 连接容器.
- Ubuntu
1. 在 docker 文件夹中存在两个 shell 脚本文件, 其中 install_docker.sh 用于安装并配置 docker, startup.sh 用于拉取镜像并启动容器：
   ```
   sudo chmod a+x install_docker.sh
   ./install_docker.sh
   sudo chmod a+x startup.sh
   ./startup.sh
   ```
2. 使用 vscode 与 dev container 插件连接镜像即可.

- 注：若在 vscode 中使用 clangd, 需要将 clangd path 设置为`/usr/bin/clangd`.

## TCP/UDP 连接
### Windows 部署 client 与 docker
在 Windows 系统下同时部署 client 与 docker, 可直接通过 docker 容器 ip 连接 client与 server.
### Windows 部署 client, 宿主机(ubuntu)部署 docker
在 Windows 系统下部署 client, 在宿主机(ubuntu)中部署 docker, 由于 startup.sh 脚本中创建容器时开启了`--net=host`, 可以直接使用宿主机 ip 连接 client 与 server.
