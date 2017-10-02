#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$THIS_DIR"

luarocks_version=2.4.2

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

function update() {
  sudo git pull
  sudo git fetch --all
  sudo git reset --hard origin/master
  sudo git pull origin master
  sudo chmod +x TG
}

lualibs=(
'luasec'
'socket'
'lbase64 20120807-3'
'luafilesystem'
'lub'
'auth'
'Lua-cURL'
'luaexpat'
'redis-lua'
'lua-cjson'
'fakeredis'
'xml'
'feedparser'
'serpent'
)

pkg=(
'libreadline-dev'
'libconfig-dev'
'libssl-dev'
'lua5.2'
'liblua5.2-dev'
'libevent-dev'
'lua-sec'
'lua-lgi'
'openssl'
'gcc'
'make'
'unzip'
'git'
'wget'
'redis-server'
'c++'
'g++'
'libjansson-dev'
'libpython-dev'
'libnotify-dev'
'autoconf'
'expat'
'libexpat1-dev'
'luarocks'
)

today=`date +%F`

get_sub() {
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c; do
        if $flag; then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]; then
                count=0
            else
                ((count++))
                if ((count > 1)); then
                    flag=true
                fi
            fi
        fi
    done
}

make_progress() {
exe=`lua <<-EOF
    print(tonumber($1)/tonumber($2)*100)
EOF
`
    echo ${exe:0:4}
}

function download_libs_lua() {
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgMember: wait... [`make_progress $(($i+1)) ${#lualibs[@]}`%%] [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        ./.luarocks/bin/luarocks install ${lualibs[$i]} &>> ./.luarocks/logluarocks_${today}.txt
    done
    sleep 0.2
    rm -rf luarocks-2.2.2*
}

function configure() {
    dir=$PWD
    wget http://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz &>/dev/null
    tar zxpf luarocks-${luarocks_version}.tar.gz &>/dev/null
    cd luarocks-${luarocks_version}
    if [[ ${1} == "--no-null" ]]; then
        ./configure --prefix=$dir/.luarocks --sysconfdir=$dir/.luarocks/luarocks --force-config
	      make bootstrap
				make build
				make install
    else
        ./configure --prefix=$dir/.luarocks --sysconfdir=$dir/.luarocks/luarocks --force-config &>/dev/null
	      make bootstrap &>/dev/null
				make build &>/dev/null
				make install &>/dev/null
    fi
    cd ..; rm -rf luarocks*
    if [[ ${1} != "--no-download" ]]; then
        download_libs_lua
    fi
		for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
}

function installation() {
    local i
    for ((i=0;i<${#pkg[@]};i++)); do
        sudo apt-get install ${pkg[$i]} -y --force-yes &>> .install-log${today}.txt
    sleep 0.25
    if [ $i -eq 100 ]; then
        echo -e "XXX\n100\nInstall Luarocks and Download Libs\nXXX"
    elif [ $(($i % 1)) -eq 0 ]; then
        let "is = $i / 4"
        echo -e "XXX\n$i\n${pkg[is]}\nXXX"
    else
        echo $i
    fi 
done | whiptail --title 'TeleGram Advertising bot Install and Configuration' --gauge "${pkg[0]}" 6 60 0
}

function api() {
echo -e "\n\033[38;5;27mPut your Token\n\033[38;5;208m\n\033[6;48m\n"
read -rp '' TKN
echo "#!/bin/bash
while true; do
	tmux kill-session -t tgGuard
		tmux new-session -s tgGuard './telegram-cli --disable-link-preview -R -C -s tgGuard.lua -p tgGuard --bot=$TKN -L log.txt'
	tmux detach -s tgGuard
done" >> start
}

function cli() {
echo "#!/bin/bash
while true; do
     	tmux kill-session -t tgGuard
		tmux new-session -s tgGuard './telegram-cli -W -R -C -v -s tgGuard.lua -p tgGuard -L log.txt'
	tmux detach -s tgGuard
done" >> start
}

function conf() {
AP="$THIS_DIR"/start
if [ ! -f $AP ]; then
 echo -e "\n\033[1;32mA\033[0;00m for config api \033[1;34m<=API & CLI=>\033[0;00m for config cli bot \033[1;32mC\033[0;00m\n"
read -p "[A/C] = "
if [ "$REPLY" == "a" ] || [ "$REPLY" == "A" ]; then
	api
    elif [ "$REPLY" == "c" ] || [ "$REPLY" == "C" ]; then
	cli
fi
fi
}

if [ "$1" = "upgrade" ]; then
update
fi

start() {
COUNTER=0
  while [ $COUNTER -lt 5 ]; do
	screen -S nohup bash start
    sleep 1200
  done
}

if [ ! -f "telegram-cli" ]; then
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y &>/dev/null
sudo apt-get autoclean -y &>/dev/null
logo
sudo apt-get update -y &>/dev/null
	sudo apt-get -y remove lua5.3 &>/dev/null
	echo -e "\n\033[1;31mPlease Waite ... \033[0;00m\n"
	sudo apt-get -y update &>/dev/null; sudo apt-get upgrade -y --force-yes &>/dev/null; sudo apt-get dist-upgrade -y --force-yes &>/dev/null
	dpkg -a --configure
 	chmod 777 TG
	installation ${@}
	rm -rf README.md
 	configure ${2}
	sudo apt-get -y update &>/dev/null; sudo apt-get upgrade -y --force-yes &>/dev/null; sudo apt-get dist-upgrade -y --force-yes &>/dev/null
	wget "https://valtman.name/files/telegram-cli-1222" 2>&1 | get_sub &>/dev/null
	mv telegram-cli-1222 telegram-cli; chmod +x telegram-cli
  echo -e "\n\033[1;32mInstall Complete\033[0;00m\n"
 	sudo service redis-server restart
 	sudo service redis-server start
  echo -e "\nCreate and Launch bot => \033[1;37mscreen -S nohup ./TG 1~9\033[0;00m\n"
else
	start
fi
