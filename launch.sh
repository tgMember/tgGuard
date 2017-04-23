 #!/bin/bash
#Create BY : @sajjad_021

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

#By: @sajjad_021
# Will install luarocks on THIS_DIR/.luarocks
install_luarocks() {
  git clone https://github.com/keplerproject/luarocks.git
  cd luarocks
   sudo apt-get install luarocks
 ./configure; sudo make bootstrap
   make build && make install
 sudo luarocks install luasocket
 sudo luarocks install luasec
 sudo luarocks install redis-lua
 sudo luarocks install lua-term
 sudo luarocks install serpent
 sudo luarocks install dkjson
 sudo luarocks install lanes
 sudo luarocks install Lua-cUR  
  sudo service redis-server start
  git checkout tags/v2.2.2 # Current stable

  PREFIX="$THIS_DIR/.luarocks"

  ./configure --prefix=$PREFIX --sysconfdir=$PREFIX/luarocks --force-config
   sudo apt-get install luarocks
 ./configure; sudo make bootstrap
   make build && make install 
   sudo service redis-server start
  cd ..
  rm -rf luarocks
}
 
install_rocks() {
  ./.luarocks/bin/luarocks install luasocket
 
  ./.luarocks/bin/luarocks install xml
  
  ./.luarocks/bin/luarocks install feedparser
  
 ./.luarocks/bin/luarocks install lua-term

 ./.luarocks/bin/luarocks install dkjson
 
 ./.luarocks/bin/luarocks install lanes
 
 ./.luarocks/bin/luarocks install luasec
  
  ./.luarocks/bin/luarocks install oauth
 
  ./.luarocks/bin/luarocks install redis-lua
 
  ./.luarocks/bin/luarocks install lua-cjson
 
  ./.luarocks/bin/luarocks install fakeredis
 
  ./.luarocks/bin/luarocks install Lua-cURL

  ./.luarocks/bin/luarocks install serpent
	
sudo ./.luarocks/bin/service redis-server start
}

install2() {
declare -A logo
    seconds="0.004"
logo[-1]=" ::::::::::  :::::::      ::     ::  ::::::::  ::     ::  ::::::  :::::::: :::::: "
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
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test 
		sudo apt-get update
	  sudo apt-get upgrade
    sudo apt-get dist-upgrade
		sudo apt-get install g++-4.7 -y c++-4.7 -y
		sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
		sudo apt-get install screen -y
		sudo apt-get install tmux -y
		sudo apt-get install libstdc++6 -y
		sudo apt-get install lua-lgi -y
		sudo apt-get install libnotify-dev -y	
               	sudo apt-get update
	        sudo apt-get upgrade
		install_luarocks
		sudo apt-get update
	  sudo apt-get upgrade
		install_rocks
}

install() {
      sudo apt-get update
	    sudo apt-get upgrade
			install2
			sudo apt-get update
	                sudo apt-get upgrade
			sudo service redis-server start
			wget http://valtman.name/files/telegram-cli-1222
                       mv telegram-cli-1222 telegram-cli
		    chmod 777 telegram-cli
                   chmod 777 anticrash.sh
		  sudo apt-get install python-setuptools python-dev build-essential
                sudo easy_install pip
                sudo pip install redis
	  echo "Was successfully installed"
}

#By: @sajjad_021
if [ "$1" = "install" ]; then
  install
elif [ "$1" = "update" ]; then
  update
else
  if [ ! -f telegram-cli ]; then
    echo -e "\033[38;5;208mError! Tg not found, Please reply to this message:\033[0;00m"
    read -p "Do you want to install starter files? [y/n] = "
	if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
        install
    elif [ "$REPLY" == "n" ] || [ "$REPLY" == "N" ]; then
        exit 1
  fi
fi
sudo service redis-server start
while true; do
  ./telegram-cli -s tgGuard.lua
done
fi
