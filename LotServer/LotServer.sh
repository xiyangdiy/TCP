#!/bin/bash

function Welcome()
{
clear
echo "             服务器时间: "&& date "+%F [%T]";
echo "            ======================================================";
echo "            |                                                    |";
echo "            |                      lotServer                     |";
echo "            |                                                    |";
echo "            ======================================================";
echo "";
root_check;
mkdir -p /tmp
cd /tmp
}

function root_check()
{
if [[ $EUID -ne 0 ]]; then
  echo "错误:脚本必须以root用户执行!" 1>&2
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

function dep_check()
{
  apt-get >/dev/null 2>&1
  [ $? -le '1' ] && apt-get -y -qq install sed grep gawk ethtool >/dev/null 2>&1
  yum >/dev/null 2>&1
  [ $? -le '1' ] && yum -y -q install sed grep gawk ethtool >/dev/null 2>&1
}

function acce_check()
{
  local IFS='.'
  read ver01 ver02 ver03 ver04 <<<"$1"
  sum01=$[$ver01*2**32]
  sum02=$[$ver02*2**16]
  sum03=$[$ver03*2**8]
  sum04=$[$ver04*2**0]
  sum=$[$sum01+$sum02+$sum03+$sum04]
  [ "$sum" -gt '12885627914' ] && echo "1" || echo "0"
}

function Install()
{
  Welcome;
  echo '准备安装...'
  Uninstall;
  dep_check;
  [ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
  [ -f /etc/os-release ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
  [ -f /etc/lsb-release ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)
  KNB=$(getconf LONG_BIT)
  [ ! -f /proc/net/dev ] && echo -ne "找不到网络设备! \n\n" && exit 1;
  Eth_List=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet' |awk 'NR==1 {print $0}'`
  [ -z "$Eth_List" ] && echo "找不到服务器公共以太网! " && exit 1
  Eth=$(echo "$Eth_List" |head -n1)
  [ -z "$Eth" ] && Uninstall "错误!找不到有效的以太网."
  Mac=$(cat /sys/class/net/${Eth}/address)
  [ -z "$Mac" ] && Uninstall "错误!找不到MAC地址."
  URLKernel='https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/lotServer.log'
  AcceData=$(wget --no-check-certificate -qO- "$URLKernel")
  AcceVer=$(echo "$AcceData" |grep "$KNA/" |grep "/x$KNB/" |grep "/$KNK/" |awk -F'/' '{print $NF}' |sort -nk 2 -t '_' |tail -n1)
  MyKernel=$(echo "$AcceData" |grep "$KNA/" |grep "/x$KNB/" |grep "/$KNK/" |grep "$AcceVer" |tail -n1)
  [ -z "$MyKernel" ] && echo -ne "内核不匹配! \n请手动更改内核,再重复一次! \n\n请查看链接以获取详细信息: \n"$URLKernel" \n\n\n" && exit 1
  pause;
  KNN=$(echo "$MyKernel" |awk -F '/' '{ print $2 }') && [ -z "$KNN" ] && Uninstall "Error! Not Matched. "
  KNV=$(echo "$MyKernel" |awk -F '/' '{ print $5 }') && [ -z "$KNV" ] && Uninstall "Error! Not Matched. "
  AcceRoot="/tmp/lotServer"
  AcceTmp="${AcceRoot}/apxfiles"
  AcceBin="acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]"
  mkdir -p "${AcceTmp}/bin/"
  mkdir -p "${AcceTmp}/etc/"
  wget --no-check-certificate -qO "${AcceTmp}/bin/${AcceBin}" "https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/${MyKernel}"
  [ ! -f "${AcceTmp}/bin/${AcceBin}" ] && Uninstall "下载错误!找不到${AcceBin}."
  Welcome;
  wget --no-check-certificate -qO "/tmp/lotServer.tar" "https://raw.githubusercontent.com/xiyangdiy/TCP/master/LotServer/lotServer.tar"
  tar -xvf "/tmp/lotServer.tar" -C /tmp
  acce_ver=$(acce_check ${KNV})
  wget --no-check-certificate -qO "${AcceTmp}/etc/apx.lic" "https://api.moeclub.org/lotServer?ver=${acce_ver}&mac=${Mac}"
  [ "$(du -b ${AcceTmp}/etc/apx.lic |cut -f1)" -lt '152' ] && Uninstall "c错误!无法生成许可文件,请稍后再试."
  echo "许可证成功生成!"
  sed -i "s/^accif\=.*/accif\=\"$Eth\"/" "${AcceTmp}/etc/config"
  sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$AcceBin\"/" "${AcceTmp}/etc/config"
  bash "${AcceRoot}/install.sh" -in 1000000 -out 1000000 -t 0 -r -b -i ${Eth}
  rm -rf /tmp/*lotServer* >/dev/null 2>&1
  Welcome;
  if [ -f /appex/bin/serverSpeeder.sh ]; then
    bash /appex/bin/serverSpeeder.sh status
  elif [ -f /appex/bin/lotServer.sh ]; then
    bash /appex/bin/lotServer.sh status
  fi
  exit 0
}

function Uninstall()
{
  AppexName="lotServer"
  [ -e /appex ] && chattr -R -i /appex >/dev/null 2>&1
  if [ -d /etc/rc.d ]; then
    rm -rf /etc/rc.d/init.d/serverSpeeder >/dev/null 2>&1
    rm -rf /etc/rc.d/rc*.d/*serverSpeeder >/dev/null 2>&1
    rm -rf /etc/rc.d/init.d/lotServer >/dev/null 2>&1
    rm -rf /etc/rc.d/rc*.d/*lotServer >/dev/null 2>&1
  fi
  if [ -d /etc/init.d ]; then
    rm -rf /etc/init.d/*serverSpeeder* >/dev/null 2>&1
    rm -rf /etc/rc*.d/*serverSpeeder* >/dev/null 2>&1
    rm -rf /etc/init.d/*lotServer* >/dev/null 2>&1
    rm -rf /etc/rc*.d/*lotServer* >/dev/null 2>&1
  fi
  rm -rf /etc/lotServer.conf >/dev/null 2>&1
  rm -rf /etc/serverSpeeder.conf >/dev/null 2>&1
  [ -f /appex/bin/lotServer.sh ] && AppexName="lotServer" && bash /appex/bin/lotServer.sh uninstall -f >/dev/null 2>&1
  [ -f /appex/bin/serverSpeeder.sh ] && AppexName="serverSpeeder" && bash /appex/bin/serverSpeeder.sh uninstall -f >/dev/null 2>&1
  rm -rf /appex >/dev/null 2>&1
  rm -rf /tmp/*${AppexName}* >/dev/null 2>&1
  [ -n "$1" ] && echo -ne "$AppexName 已被移除! \n" && echo "$1" && echo -ne "\n\n\n" && exit 0
}

if [ $# == '1' ]; then
  [ "$1" == 'install' ] && KNK="$(uname -r)" && Install;
  [ "$1" == 'uninstall' ] && Welcome && pause && Uninstall "Done.";
elif [ $# == '2' ]; then
  [ "$1" == 'install' ] && KNK="$2" && Install;
else
  echo -ne "用法:\n     bash $0 [install |uninstall |install '{Kernel Version}']\n"
fi


