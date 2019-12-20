# lotServer


## 用户安装
### 常规自动安装
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/LotServer.sh) install
```

### 指定内核安装
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/LotServer.sh) install <Kernel Version>
```
##### Ubuntu 16.04
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/LotServer.sh) install 4.4.0-142-generic
```
#### 查看当前内核版本
```
uname -r
```

## 完全卸载
```
bash <(wget --no-check-certificate -qO- https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/LotServer.sh) uninstall
```

## 用法
### 启动命令 
```
/appex/bin/lotServer.sh start
```
### 停止加速
```
/appex/bin/lotServer.sh stop
```
### 状态查询
```
/appex/bin/lotServer.sh status
```
### 重新启动
```
/appex/bin/lotServer.sh restart
```

  
