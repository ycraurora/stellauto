# stellauto
StellaAutonomous System 脚本工具

## 用法
使用git下载脚本至本地
```
git clone https://github.com/ycraurora/stellauto.git
```

### Ubuntu配置脚本(WIP)

### docker配置脚本
- Windows
于官网中下载docker desktop安装文件并安装。
下载ycrad/stellauto:1.0.0镜像，并创建容器。
使用vscode, WSL2, dev container连接容器。
- Ubuntu
在docker文件夹中存在两个shell脚本文件，其中install_docker.sh用于安装并配置docker，startup.sh用于拉取镜像并启动容器。
```
sudo chmod a+x install_docker.sh
./install_docker.sh
sudo chmod a+x startup.sh
./startup.sh
```
之后使用vscode与dev container插件连接镜像即可。
