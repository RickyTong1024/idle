# IDLE服务端开发环境配置
## IDE选择
我一般使用pycharm 打开项目并把server文件夹和gs文件夹设为Sources Root

遇到一些格式警告 非必要的可以Alt+Enter 忽略错误

有些错误需要setting-Editor-Inspections搜索忽略

除去动态导入和命名警告 其他警告不要忽略 代码格式可能写的不完美 尽量完美化

也推荐emacs（如果你愿意花时间去学习的话 win下支持比较差Ui也比较丑）

## 安装python3.7.3

在python官网下载win安装包

双击安装 记得勾选add path

安装完毕

## IDLE环境配置

IDLE主要用到了四个库 打开cmd 输入一下命令

pip install tornado==6.0.2

pip install zmq==0.0.0

pip install protobuf==3.6.1

pip install pymysql

pip install django==2.1.4

pip install oss2

## 数据库环境配置
在mysql官网下载mysql-installer-community-5.7.26.0.msi（我现在使用的版本）
双击安装 我一般选择full安装
账号root密码root（这里参考项目server/conf文件里面的server.json）
安装好以后win命令行输入net mysqld start启动数据库
数据库具体安装以及操作参考官网文档

## IDLE游戏启动

创建新的数据库IDLE（可以用navicat连接控制数据库）

在common中找到make_db.bat 双击 创建相应的数据库字段

找到gate.py 双击启动

找到gs.py 双击启动

## pip常用命令集合

pip install ***    安装某个库

pip uninstall ***  卸载某个库

pip list 展示已在本机安装的库

python -m pip install --upgrade pip 更新pip到最新的版本