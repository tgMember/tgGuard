#!/usr/bin/env bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

logo() {
    declare -A logo
    seconds="0.004"
logo[0]="  .          '||    ||' '||'''|  '||    ||' '||'|.  '||'''|  '||''|."
logo[1]=".||.   ... .  |||  |||   || .     |||  |||   ||  ||  || .     ||   ||"
logo[2]=" ||   || ||   |'|..'||   ||'|     |'|..'||   ||''|.  ||'|     ||''|'"
logo[3]=" ||    |''    | '|' ||   ||       | '|' ||   ||   || ||       ||   |."
logo[4]=" '|.' '|||.  .|. | .||. .||....| .|. | .||. .||..|' .||....| .||.  '|'"
logo[5]="    .|...'"
logo[6]="➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
logo[7]="Channel : @tgMember"
logo[8]="Develop by @sajjad_021"
printf "\e[38;5;213m\t"
    for i in ${!logo[@]}; do
        for x in `seq 0 ${#logo[$i]}`; do
            printf "${logo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
printf "\n"
}

log() {
  echo -e "\033[38;5;105m .               /|\,/ |\,  ,- _~,   /\|,/ \|,   - _,,     ,- _~,  -_ /\,\033[0;00m"
  echo -e "\033[38;5;142m||    _          /| || ||   (' /| /  /| || ||     -/  )   (' /| /   || ,,\033[0;00m"
 echo -e "\033[38;5;099m=||=  / \\        || || ||  ((  ||/=  || || ||    ~||_<   ((  || =  /|| /|.\033[0;00m"
  echo -e "\033[38;5;034m||  || ||        ||=|= ||  ((  ||    ||=|= ||     || |\  (( |||    \||/-\,\033[0;00m"
  echo -e "\033[38;5;406m||  || ||       ~|| || ||   ( / |   ~|| || ||     ,/--||  (   |     ||  \.,\033[0;00m"
  echo -e "\033[38;5;129m||  \|_-|        |, |\,|\,   -____-  |, |\,|\,   _--_-'    -____- _---_-|.\033[0;00m"
         echo -e "\033[38;5;129m||   -_-_\033[0;00m"
            echo -e "\033[38;5;129m,_-_-\.\033[0;00m"
  echo -e "\033[38;5;208m➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\033[0;00m"
  echo '>Channel : '"@tgMember"
  echo '>Develop by '"@sajjad_021"
 }
  
 install_luarocks() {
 echo -e "\e[38;5;142mInstalling LuaRocks\e"
  git clone https://github.com/keplerproject/luarocks.git
  cd luarocks
  git checkout tags/v2.4.2 # Current stable

  PREFIX="$THIS_DIR/.luarocks"

  ./configure --prefix=$PREFIX --sysconfdir=$PREFIX/luarocks --force-config
   make build && make install
cd ..
  rm -rf luarocks
}

install_rocks() {
echo -e "\e[38;5;105mInstall rocks service\e"
rocks="luasocket luasec redis-lua lua-term serpent dkjson Lua-cURL multipart-post lanes"
    for rock in $rocks; do
      sudo luarocks install $rock
    done
}
  
tg() {
echo -e "\e[38;5;099minstall telegram-cli\e"
    rm -rf ../.telegram-cli
    wget https://valtman.name/files/telegram-cli-1222
    mv telegram-cli-1222 telegram-cli
    chmod +x telegram-cli
    chmod +x run.sh
}
  
install2() {
echo -e "\e[38;5;034mInstalling more dependencies\e"
    sudo apt-get install screen -y
    sudo apt-get install tmux -y
    sudo apt-get install upstart -y
    sudo apt-get install libstdc++6 -y
    sudo apt-get install lua-lgi -y
    sudo apt-get install libnotify-dev -y
    install_luarocks
    install_rocks
    py
    tg
    echo -e "\e[38;5;046mInstalling packages successfully\033[0;00m"
    log
    help
}

install() {
echo -e "\e[38;5;035mUpdating packages\e"
  	sudo apt-get update -y
	sudo apt-get upgrade -y

echo -e "\\e[38;5;129mInstalling dependencies\e"
	sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
	sudo apt-get install g++-4.7 -y c++-4.7 -y
	sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
install2
clear
}

py() {
 sudo apt-get install python-setuptools python-dev build-essential 
 sudo easy_install pip
 sudo pip install redis
}

info() {
memTotal_b=`free -b |grep Mem |awk '{print $2}'`
memFree_b=`free -b |grep Mem |awk '{print $4}'`
memBuffer_b=`free -b |grep Mem |awk '{print $6}'`
memCache_b=`free -b |grep Mem |awk '{print $7}'`

memTotal_m=`free -m |grep Mem |awk '{print $2}'`
memFree_m=`free -m |grep Mem |awk '{print $4}'`
memBuffer_m=`free -m |grep Mem |awk '{print $6}'`
memCache_m=`free -m |grep Mem |awk '{print $7}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
uptime=`uptime`
ProcessCnt=`ps -A | wc -l`
memUsed_b=$(($memTotal_b-$memFree_b-$memBuffer_b-$memCache_b))
memUsed_m=$(($memTotal_m-$memFree_m-$memBuffer_m-$memCache_m))
memUsedPrc=$((($memUsed_b*100)/$memTotal_b))
echo ">Server Information"
echo ">Total Ram : $memTotal_m MB  Ram in use : $memUsed_m MB - $memUsedPrc% used!"
echo '>Cpu in use : '"$CPUPer"'%'
echo '>Server Uptime : '"$uptime"
echo -e "\033[38;5;208m➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\033[0;00m"
echo '>Channel : '"@tgMember"
echo '>Develop by '"@sajjad_021"
}



help() {
echo -e "for see help use => \033[38;5;208m./make.sh help\033[0;00m"
echo -e "for install packages use => \033[38;5;208m./make.sh install\033[0;00m"
echo -e "for see your server info use => \033[38;5;208m./make.sh info\033[0;00m"
echo -e "\033[38;5;037mOr\033[0;00m"
echo -e "you can use the => \033[38;5;208m./make.sh\033[0;00m <= command for run your robot."
echo -e "\033[38;5;208m➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\033[0;00m"
echo '>Channel : '"@tgMember"
echo '>Develop by '"@sajjad_021"
}

if [ "$1" = "info" ]; then
info
fi

if [ "$1" = "help" ]; then
help
fi

if [ "$1" = "install" ]; then
install
fi

if [ ! -f ./telegram-cli ]; then
    echo -e "\033[38;5;208mError! telegram-cli not found, Please reply to this message:\033[1;208m"
    read -p "Do you want to install and config? [y/n] = "
	if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
       logo
        install
    elif [ "$REPLY" == "n" ] || [ "$REPLY" == "N" ]; then
        exit 1
  fi
fi
	screen ./run.sh
