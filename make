#!/bin/bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$THIS_DIR"

function logo() {
    declare -A logo
    seconds="0.002"
logo[0]="_____           ______  ___                  ______                "
logo[1]="__  /________ _ ___   |/  /_____ _______ ___ ___  /_ _____ ________"
logo[2]="_  __/__  __  / __  /|_/ / _  _ \__  __  __ \__  __ \_  _ \__  ___/"
logo[3]="/ /_  _  /_/ /  _  /  / /  /  __/_  / / / / /_  /_/ //  __/_  /    "
logo[4]="\__/  _\__, /   /_/  /_/   \___/ /_/ /_/ /_/ /_.___/ \___/ /_/     "
logo[5]="      /____/                                                       "
logo[6]=""
logo[7]="Channel : @tgMember"
logo[8]="Develop by @sajjad_021"
printf "\e[38;5;154m\n\e[38;7;27m\t"
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
  sudo chmod +x make
}

lualibs=(
'luasec'
'lbase64'
'luafilesystem'
'luasocket'
'lua-term'
'dkjson'
'multipart-post'
'lanes'
'ltn12'
'lgi'
'Lua-cURL'
'luaexpat'
'redis-lua'
'lua-cjson'
'fakeredis'
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
'lua5.1'
'lua5.1-dev'
'lua-socket'
'curl'
'libcurl4-gnutls-dev'
'screen'
'tmux'
'libstdc++6'
)

today=`date +%F`

get_sub() {
    local flag=FALSE c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c; do
        if $flag; then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]; then
                count=0
            else
                ((count++))
                if ((count > 1)); then
                    flag=TRUE
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
        sudo luarocks install ${lualibs[$i]} &>> .logluarocks.txt
    done
    sleep 0.2
    cd ..; rm -rf luarocks-2.2.2*
}

function configure() {
    dir=$PWD
     wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz &>>/dev/null
      tar zxpf luarocks-2.2.2.tar.gz &>>/dev/null
      cd luarocks-2.2.2
      ./configure &>>/dev/null
	sudo make bootstrap &>>/dev/null
    if [[ ${1} != "--no-download" ]]; then
        download_libs_lua
       rm -rf luarocks*
	wget "https://valtman.name/files/telegram-cli-1222" 2>&1 | get_sub &>> .make.txt
	mv telegram-cli-1222 telegram-cli; chmod +x telegram-cli
    fi
   for ((i=0;i<101;i++)); do
        printf "\rConfiguring... [%i%%]" $i
        sleep 0.007
    done
}

installation() {
		for i in $(seq 1 100); do
 	sudo apt-get install ${pkg[$i]} -y --force-yes &>> .is1.out
   sleep 1
    if [ $i -eq 100 ]; then
        echo -e "XXX\n100\nInstall Luarocks and Download Libs\nXXX"
    elif [ $(($i % 3)) -eq 0 ]; then
        let "is = $i / 3"
       echo -e "XXX\n$i\n${pkg[is]}\nXXX"
	sudo apt-get install ${pkg[is]} -y --force-yes &>> .is2.out
   else
        echo $i
    fi 
done | whiptail --title 'TeleGram Guard bot Install and Configuration' --gauge "${pkg[0]}" 6 60 0
}

if [ "$1" = "config" ]; then
  ./telegram-cli -s tgGuard
fi

api() {
	nohup lua Api.lua &>> nohup.out &
}

if [ ! -f telegram-cli ]; then
logo
	echo -e "\n\033[1;31mPlease Waite ... \033[0;00m\n"
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y  &>> .make.txt
sudo apt-get autoclean -y  &>> .make.txt
sudo apt-get autoremove -y &>> .make.txt
printf "\e[38;0;0m\t"
	sudo apt-get -y remove lua5.3 &>> .make.txt
	sudo dpkg --configure -a &>> .make.txt
	sudo apt-get -y install -f  &>> .make.txt
 	chmod 777 make
	installation ${@}
	rm -rf README.md
 	configure ${2}
  echo -e "\n\033[1;32mInstall Complete\033[0;00m\n"
 	sudo service redis-server restart &>/dev/null
 	sudo service redis-server start &>/dev/null
elif [ ! -f Config.lua ]; then
	./telegram-cli -s tgGuard.lua
else
api
	COUNTER=0
  while [ $COUNTER -lt 5 ]; do
       tmux kill-session -t cli
           tmux new-session -s cli "./telegram-cli -s tgGuard.lua"
        tmux detach -s cli
    sleep 1
  done
fi
