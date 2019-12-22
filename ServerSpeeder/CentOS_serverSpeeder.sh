#!/bin/bash

function Welcome()
{
clear
echo -n""&& date "+%F [%T]";
echo "            ======================================================";
echo "            |                                                    |";
echo "            |                    serverSpeeder                   |";
echo "            |                                                    |";
echo "            ======================================================";
echo "";
rootness;
mkdir -p /tmp
cd /tmp
}

a=$(lsb_release -i)
a=${a:16:6}
b=$(uname -r)
c=$(lsb_release -r)
c=${c:9:1}

function Check_Kernel()
{
if [ "$a" != "CentOS" ];then
   echo "当前系统不是CentOS"
   exit 1
fi

if [ "$b" == "2.6.32-504.3.3.el6.x86_64" ];then
   echo "内核已更换！"
elif [ "$b" == "3.10.0-229.1.2.el7.x86_64" ];then
   echo "内核已更换！" 
else Install_Kernel
fi
}

function rootness()
{
if [[ $EUID -ne 0 ]]; then
   echo "错误：脚本必须以root权限运行！" 1>&2
   exit 1
fi
}

#安装内核
function Install_Kernel()
{
if [ "$c" == "6" ];then
   echo "开始更换内核......"
   echo "请稍等！"
   wget --no-check-certificate https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/Kernel/CentOS%206/kernel-2.6.32-504.3.3.el6.x86_64.rpm
   wget --no-check-certificate https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/Kernel/CentOS%206/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm
   sleep 2
   rpm -ivh kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm --force
   sleep 2   
   rpm -ivh kernel-2.6.32-504.3.3.el6.x86_64.rpm --force  
   
   echo "内核更换完成,需要重启!"  
   while true
         do
	         read -r -p "现在重启? [Y/N] " input
	         case $input in
	         [yY][eE][sS]|[yY])
			   reboot
			   exit 1
			   ;;
	        [nN][oO]|[nN])
			   exit 1	       	
			   ;;
	         *)
			   ;;
         esac
   done

elif [ "$c" == "7" ];then
   echo "开始更换内核......"
   echo "请稍等！"
   wget --no-check-certificate https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/Kernel/CentOS%207/kernel-3.10.0-229.1.2.el7.x86_64.rpm
   sleep 2
   rpm -ivh kernel-3.10.0-229.1.2.el7.x86_64.rpm --force  
   
   echo "内核更换完成,需要重启!"  
   while true
         do
	         read -r -p "现在重启? [Y/N] " input
	         case $input in
	         [yY][eE][sS]|[yY])
			   reboot
			   exit 1
			   ;;
	        [nN][oO]|[nN])
			   exit 1	       	
			   ;;
	         *)
			   ;;
         esac
   done

else
   echo "当前系统不是CentOS 6/7"
   exit 1
fi
}

function pause()
{
read -n 1 -p "请按回车键继续..." INP
if [ "$INP" != '' ] ; then
echo -ne '\b \n'
echo "";
fi
}

function Check()
{
echo '准备工作...'
apt-get >/dev/null 2>&1
[ $? -le '1' ] && apt-get -y -qq install grep unzip ethtool >/dev/null 2>&1
yum >/dev/null 2>&1
[ $? -le '1' ] && yum -y -q install which sed grep awk unzip ethtool >/dev/null 2>&1
[ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
[ -f /etc/os-release ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
[ -f /etc/lsb-release ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)
KNB=$(getconf LONG_BIT)
ifconfig >/dev/null 2>&1
[ $? -gt '1' ] && echo -ne "无法运行'ifconfig'! \n请检查您的系统，然后重试! \n\n" && exit 1;
[ ! -f /proc/net/dev ] && echo -ne "找不到网络设备! \n\n" && exit 1;
[ -n "$(grep 'eth0:' /proc/net/dev)" ] && Eth=eth0 || Eth=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet' |awk 'NR==1 {print $0}'`
[ -z "$Eth" ] && echo "找不到服务器公共以太网! " && exit 1
URLKernel='https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/serverSpeeder.txt'
AcceVer=$(wget --no-check-certificate -qO- "$URLKernel" |grep "$KNA/" |grep "/x$KNB/" |grep "/$KNK/" |awk -F'/' '{print $NF}' |sort -n -k 2 -t '_' |tail -n 1)
MyKernel=$(wget --no-check-certificate -qO- "$URLKernel" |grep "$KNA/" |grep "/x$KNB/" |grep "/$KNK/" |grep "$AcceVer" |tail -n 1)
[ -z "$MyKernel" ] && echo -ne "内核不匹配! \n请手动更改内核, 然后再试一次! \n\n查看serverSpeeder.txt以获取详细信息! \n\n\n" && exit 1
pause;
}

function SelectKernel()
{
KNN=$(echo $MyKernel |awk -F '/' '{ print $2 }') && [ -z "$KNN" ] && Uninstall && echo "错误，未匹配! " && exit 1
KNV=$(echo $MyKernel |awk -F '/' '{ print $5 }') && [ -z "$KNV" ] && Uninstall && echo "错误，未匹配! " && exit 1
wget --no-check-certificate -q -O "/tmp/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" "https://github.com/xiyangdiy/TCP/raw/master/ServerSpeeder/$MyKernel"
[ ! -f "/tmp/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" ] && Uninstall && echo "下载错误，找不到 acce-$KNV-[$KNA_$KNN_$KNK]! " && exit 1
}

function Install()
{
Welcome;
Check_Kernel;
Check;
ServerSpeeder;
dl-Lic;
bash /tmp/appex/install.sh
rm -rf /tmp/appex* >/dev/null 2>&1
clear
bash /appex/bin/serverSpeeder.sh status
exit 0
}

function Uninstall()
{
chattr -R -i /appex >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc*.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/init.d/lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc*.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc*.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/init.d/lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc*.d/*lotServer >/dev/null 2>&1
rm -rf /etc/lotServer.conf >/dev/null 2>&1
rm -rf /etc/serverSpeeder.conf >/dev/null 2>&1
[ -f /appex/bin/lotServer.sh ] && bash /appex/bin/lotServer.sh uninstall -f >/dev/null 2>&1
[ -f /appex/bin/serverSpeeder.sh ] && bash /appex/bin/serverSpeeder.sh uninstall -f >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
rm -rf /tmp/appex* >/dev/null 2>&1
echo -ne 'serverSpeeder 已被移除! \n\n\n'
exit 0
}

function dl-Lic()
{
chattr -R -i /appex >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
mkdir -p /appex/etc
mkdir -p /appex/bin
MAC=$(ifconfig "$Eth" |awk '/HWaddr/{ print $5 }')
[ -z "$MAC" ] && MAC=$(ifconfig "$Eth" |awk '/ether/{ print $2 }')
[ -z "$MAC" ] && Uninstall && echo "找不到MAC地址!" && exit 1
wget --no-check-certificate -q -O "/appex/etc/apx.lic" "https://moeclub.azurewebsites.net/lic?mac=$MAC"
[ "$(du -b /appex/etc/apx.lic |awk '{ print $1 }')" -ne '152' ] && Uninstall && echo 错误!无法生成许可证,请稍后再试." && exit 1
echo ""许可证成功生成!"
[ -n $(which ethtool) ] && rm -rf /appex/bin/ethtool && cp -f $(which ethtool) /appex/bin
}

function ServerSpeeder()
{
[ ! -f /tmp/appex.zip ] && wget --no-check-certificate -q -O "/tmp/appex.zip" "https://raw.githubusercontent.com/xiyangdiy/TCP/master/ServerSpeeder/appex.zip"
[ ! -f /tmp/appex.zip ] && Uninstall && echo "错误！未找到appex.zip! " && exit 1
mkdir -p /tmp/appex
unzip -o -d /tmp/appex /tmp/appex.zip
SelectKernel;
APXEXE=$(ls -1 /tmp/appex/apxfiles/bin |grep 'acce-')
sed -i "s/^accif\=.*/accif\=\"$Eth\"/" /tmp/appex/apxfiles/etc/config
sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$APXEXE\"/" /tmp/appex/apxfiles/etc/config
}

[ $# == '1' ] && [ "$1" == 'install' ] && KNK="$(uname -r)" && Install;
[ $# == '1' ] && [ "$1" == 'uninstall' ] && Welcome && pause && Uninstall;
[ $# == '2' ] && [ "$1" == 'install' ] && KNK="$2" && Install;
echo -ne ""用法:\n     bash $0 [install |uninstall |install '{serverSpeeder的内核版本}']\n"
