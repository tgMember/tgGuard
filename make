#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$THIS_DIR"

function logo() {
    declare -A logo
    seconds="0.002"
logo[0]="  .          '||    ||' '||'''|  '||    ||' '||'|.  '||'''|  '||''|."
logo[1]=".||.   ... .  |||  |||   || .     |||  |||   ||  ||  || .     ||   ||"
logo[2]=" ||   || ||   |'|..'||   ||'|     |'|..'||   ||''|.  ||'|     ||''|'"
logo[3]=" ||    |''    | '|' ||   ||       | '|' ||   ||   || ||       ||   |."
logo[4]=" '|.' '|||.  .|. | .||. .||....| .|. | .||. .||..|' .||....| .||.  '|'"
logo[5]="    .|...'"
logo[6]=""
logo[7]="Channel : @tgMemberLtd"
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

function update() {
  git pull
  git fetch --all
  git reset --hard origin/master
  git pull origin master
  chmod +x make
}

lualibs=(
'luasec'
'socket'
'luarepl'
'lbase64 20120807-3'
'luafilesystem'
'lub'
'auth'
'lua-term'
'Lua-cURL'
'multipart-post'
'lanes'
'multipart-post'
'luaexpat'
'redis-lua'
'lua-cjson'
'fakeredis'
'xml'
'dkjson'
'feedparser'
'serpent'
)

basepkg="libreadline-dev whiptail libssl-dev lua5.2 luarocks git make unzip redis-server curl libconfig-dev lua-socket lua-sec libevent-dev autoconf g++ wget c++ tmux openssl g++4.7 c++4.7 lua-lgi libnotify-dev"

pkg=(
'libreadline-dev'
'libssl-dev'
'lua5.2'
'luarocks'
'liblua5.2-dev'
'git'
'make'
'unzip'
'redis-server'
'curl'
'libcurl4-gnutls-dev'
'libconfig-dev'
'lua-socket'
'lua-sec'
'lua-expat'
'libevent-dev'
'autoconf'
'g++'
'libjansson-dev'
'libpython-dev'
'expat'
'libexpat1-dev'
'libpcre3-dev'
'wget'
'c++'
'tmux'
'openssl'
'coreutils'
'g++4.7'
'c++4.7'
'fortune-mod'
'fortunes'
'libc6'
'libjansson*'
'lua-lgi'
'libnotify-dev'
'whiptail'
)

today=`date +%F`

function download_libs_lua() {
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgMember: Please Wait ... [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        luarocks install ${lualibs[$i]} &>>/dev/null
    done
    sleep 0.2
}

function configure() {
    if [[ -f "/usr/bin/lua5.3" ]] || [[ -f "/usr/bin/lua5.1" ]] || [[ -f "/usr/local/bin/lua5.3" ]]; then
        apt remove -y lua5.3 &>/dev/null
            apt -y autoremove &>/dev/null
            apt install -y lua5.2 &>/dev/null
      echo -e "\n\033[0;31m tgGuard Download Libs ... \033[0m\n"
     fi
        git clone https://github.com/keplerproject/luarocks.git &>/dev/null
        cd luarocks

        ./configure --force-config >>/dev/null
        make build &>/dev/null
        make install &>/dev/null
        make bootstrap &>/dev/null
        cd ..

    download_libs_lua

    rm -rf luarocks

    for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
    printf "\nDone\n"
}

function installation() {
    local i
    for ((i=0;i<${#pkg[@]};i++)); do
        apt install ${pkg[$i]} -y --force-yes &>>/dev/null
    if [ $i -eq 100 ]; then
        echo -e "XXX\n100\nInstall \nXXX"
    elif [ $(($i % 1)) -eq 0 ]; then
        let "is = $i / 3"
        echo -e "XXX\n$i\n${pkg[is]}\nXXX"
    else
        echo $i
    fi
done | whiptail --title 'Install Telegram Guard & Group Manager API + CLI' --gauge "${pkg[0]}" 6 60 0
}

if [ "$1" = "upgrade" ]; then
update
fi


function api() {
        nohup lua Api.lua &>> nohup.out &
}

function start() {
COUNTER=0
  while [ $COUNTER -lt 55 ]; do
  api
       tmux kill-session -t cli
           tmux new-session -s cli "./telegram-cli -s tgGuard.lua"
        tmux detach -s cli
    sleep 5
  done
}

if [ ! -f "telegram-cli" ]; then
        chmod 777 make
        logo
        echo -e "\n\033[1;34mPlease wait ...\033[0;00m\n"
        apt-get -y update &>/dev/null; apt-get upgrade -y --force-yes &>/dev/null; apt-get dist-upgrade -y --force-yes &>/dev/null; apt-get -y install f &>/dev/null
        installation
        rm -rf README.md
        configure
        wget "https://valtman.name/files/telegram-cli-1222" &>/dev/null
        rm -rd logs
        mv telegram-cli-1222 telegram-cli; chmod +x telegram-cli
        wget http://mirrors.kernel.org/ubuntu/pool/main/r/readline6/libreadline6_6.3-8ubuntu2_amd64.deb
        dpkg -i libreadline6_6.3-8ubuntu2_amd64.deb
        wget http://mirrors.kernel.org/ubuntu/pool/main/r/readline6/libreadline6-dev_6.3-8ubuntu2_amd64.deb
        dpkg -i libreadline6-dev_6.3-8ubuntu2_amd64.deb
        wget http://security.ubuntu.com/ubuntu/pool/main/libe/libevent/libevent-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb
        dpkg -i libevent-2.0-5_2.0.21-stable-2ubuntu0.16.04.1_amd64.deb
        apt install -y libreadline6
        apt install -y libreadline6-dev
        apt install -y libevent-2.0
        apt install -y libevent-dev
        apt install -y tmux libconfig-dev libjansson-dev libssl-dev
        apt autoremove -y
        wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb
        dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb
        apt list --upgradable -a; apt update -y; apt upgrade -y; dpkg --configure -a; apt --fix-broken install -y; apt-get -f install; sync; systemctl daemon-reload; apt autoclean; apt autoremove -y; apt update -y; apt full-upgrade -y
        apt install -y openssh-server -y
    echo -e "\n\033[1;32mInstall Complete\033[0;00m\n"
        rm -rf *.deb
    sleep 2
    service redis-server restart &>/dev/null
    service redis-server start &>/dev/null
    lua tgGuard.lua
    chmod 777 start
    sleep 1
    lua tgGuard.lua
    start
elif [ ! -f "Config.lua" ]; then
    lua tgGuard.lua
    start
else
        start
fi
