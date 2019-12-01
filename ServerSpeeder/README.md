# serverSpeeder


## 用户安装
### Centos 6/7 安装
```
wget --no-check-certificate -O CentOS_serverSpeeder.sh https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/CentOS_serverSpeeder.sh && chmod +x CentOS_serverSpeeder.sh && bash CentOS_serverSpeeder.sh install
```

### 常规自动安装
```
wget --no-check-certificate -O serverSpeeder.sh https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh && chmod +x serverSpeeder.sh && bash serverSpeeder.sh install
```

### 指定内核安装
```
wget --no-check-certificate -O serverSpeeder.sh https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh && chmod +x serverSpeeder.sh && bash serverSpeeder.sh install <Kernel Version>
```
#### 查看当前内核版本
```
uname -r
```
#### 内核列表
```
https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.txt
```

## 完全卸载
```
wget --no-check-certificate -O serverSpeeder.sh https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh && chmod +x serverSpeeder.sh && bash serverSpeeder.sh uninstall
```

## 用法
### 启动命令：
```
/serverspeeder/bin/serverSpeeder.sh start
```
### 停止加速：
```
/serverspeeder/bin/serverSpeeder.sh stop
```
### 状态查询：
```
service serverSpeeder status
```
    

  
