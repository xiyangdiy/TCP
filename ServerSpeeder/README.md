# serverSpeeder


## 用户安装
### 常规自动安装
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh) install
```

### 指定内核安装
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh) install <Kernel Version>
```
#### 查看当前内核版本
```
uname -r
```

## 完全卸载
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.sh) uninstall
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
    

  
