#!/usr/bin/env bash
#Create BY : @sajjad_021

install() {
  declare -A logo
    seconds="0.004"
logo[-1]=" ::::::::::  :::::::      ::     ::  ::::::::  ::     ::  ::::::  :::::::: ::::::  "
logo[0]="     +:     :+    :+:    :+:+   +::+ +:       :+:+   +:+: +:   :+ +:       +:   :+ "
logo[1]="     :+     +:           :+ +:+:+ :+ :+       :+ +:+:+ :+ :+   +: :+       :+   +: "
logo[2]="     ++     :#           ++  +:+  ++ +++++#   ++  +:+  ++ #+++++  +++:+#   +++++#  "
logo[3]="     ++     +#  +#+#+    #+   +   #+ #+       #+   +   +# #+   +# #+       #+   +# "
logo[4]="     +#     #+     +#    +#       +# +#       +#       #+ +#    # +#       +#    #+"
logo[5]="     ##      #######     ##       ## ######## ##       ## ####### ######## ##    ##"
    printf "\033[32;4;208m\t"
    for i in ${!logo[@]}; do
        for x in `seq 0 ${#logo[$i]}`; do
            printf "${logo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
printf "\n"
sudo apt-get autoclean
sudo apt-get autoremove
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -f
sudo dpkg -a --configure
sudo apt-get dist-upgrade
sudo dpkg --configure -a
sudo sudo apt-get dist-upgrade
sudo apt-get update
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson* libpython-dev make autoconf unzip git redis-server g++ -y —force-yes
sudo apt-get install libreadline-dev libssl-dev lua5.2 liblua5.2-dev git make unzip redis-server curl libcurl4-gnutls-dev
wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
tar zxpf luarocks-2.2.2.tar.gz
cd luarocks-2.2.2
./configure; sudo make bootstrap
sudo luarocks install luasec
sudo luarocks install luasocket
sudo luarocks install redis-lua
sudo luarocks install lua-term
sudo luarocks install serpent
sudo luarocks install dkjson
sudo luarocks install Lua-cURL
cd ..
rm -rf luarocks-2.2.2.tar.gz
sudo apt-get install lua-lgi
sudo apt-get install libnotify-dev
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev
sudo apt-get install lua50
sudo apt-get install lua5.1
sudo apt-get install lua5.2
sudo apt-get install lua5.3
wget http://www.member-adder.ir/tg
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo ppa-purge
sudo service redis-server restart
chmod +x tgGuard.lua
chmod +x tg
memTotal_b=`free -b |grep Mem |awk '{print $2}'`
memFree_b=`free -b |grep Mem |awk '{print $4}'`
memBuffer_b=`free -b |grep Mem |awk '{print $6}'`
memCache_b=`free -b |grep Mem |awk '{print $7}'`
memTotal_m=`free -m |grep Mem |awk '{print $2}'`
memFree_m=`free -m |grep Mem |awk '{print $4}'`
memBuffer_m=`free -m |grep Mem |awk '{print $6}'`
memCache_m=`free -m |grep Mem |awk '{print $7}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
hdd=`df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`
uptime=`uptime`
time=`date` 
calendar=`cal` 
ProcessCnt=`ps -A | wc -l`
memUsed_b=$(($memTotal_b-$memFree_b))
memUsed_m=$(($memTotal_m-$memFree_m))
memUsedPrc=$((($memUsed_b*100)/$memTotal_b))
f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'

echo -e "$f2 ONLINE OPERATION OF THE ROBOT BEGAN$rst"
echo ""
sleep 1
echo -e "\e[1mOperation : \e[96mStarting Bot\e[0m"
echo -e "\e[1mSource : \e[94m tgGuard Version 5 On Apr 2017\e[0m"
echo -e "\e[38;5;82mDeveloper : \e[38;5;226mSajjad_021 @tgMember\e[0m"
echo -e "\e[1m**********************************\e[0m"
sleep 2
echo -e "\e[1mTime : \e[45m$time\e[0m \e[1"
echo -e "\e[1mCalendar : $calendar\e[0m"
echo -e "\e[1m**********************************"
echo -e "Total Ram :\e[96m $memTotal_m MB \e[296m\e[0m"
sleep 0.5
echo -e "\e[1m**********************************"
echo -e "Ram Used : \e[91m$memUsed_m MB  =  $memUsedPrc%\e[0m"
sleep 0.5
echo -e "\e[1m**********************************"
echo -e "CPU Used : \e[92m""$CPUPer""%\e[0m"
sleep 0.5
echo -e "\e[1m**********************************"
echo -e 'Hard : \e[33m'"$hdd"'%\e[291m\e[0m'
sleep 0.5
echo -e "\e[1m**********************************"
echo -e "\e[40;38;5;82mProcess : \e[30;48;5;82m ""$ProcessCnt\e[0m"
sleep 0.5
echo -e "\e[1m**********************************\e[0m"
echo -e "\e[92m     >>>> Launching Bot <<<<\e[0m"
sleep 2
}


if [ "$1" = "install" ]; then
  install
fi


COUNTER=0
while [  $COUNTER -lt 5 ]; do
./tg -s tgGuard.lua
sleep 1
#let COUNTER=COUNTER+1 
done
