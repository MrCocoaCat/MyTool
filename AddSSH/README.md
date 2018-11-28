### 概述
为远程主机添加ssh密钥，使用前需要安装expect

```
apt-get install expect
```

###add1、add2root

* 脚本add.sh
* 地址文件list.txt

### 使用方式
1. add1: 将add.sh批处理脚本与配置文件list.txt 放置在同一目录下。
list.txt为需要添加的IP地址，该列表中用户名密码均相同
2. add2root:  脚本将可实现root 账号的免密登陆。
即将key复制到root账号目录下
### 参数

脚本需要两个参数
分别为远程主机的账号及密码

>示例
```
sh add.sh user pass
```

### add3 
add3可以为不同密码的主机添加ssh秘钥
该脚本需将IP 用户名 密码写入list.txt中
以空格进行分割

