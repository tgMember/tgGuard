
# [tgGuard v8.0](https://t.me/tgGuard) 
```TeleGram Guard Inline Version```


## _frist telegram anti spam and group moderation whit :_

- #### *full power* 
- #### *fast speed*
- #### *low space* 
- #### *99% online* 
- #### *whit out crash or bug*
- #### *Inline with out config*


***


<p align="center"> <img class="td" style="vertical-align: middle;" src="https://tgmemberplus.000webhostapp.com/tgguard.jpg" alt="" width="320" height="320" /></p>



[![http://t.me/sajjad_021](https://img.shields.io/badge/Telegram-sajjad__021-blue.svg)](http://t.me/sajjad_021)

[![https://github.com/tgMember/tGuard](https://img.shields.io/badge/%F0%9F%92%AC_GitHub-tGuard-green.svg)](https://github.com/tgMember/tGuard)

[![http://tgmember.cf](https://img.shields.io/badge/webpage-tgMember-ff69b4.svg)](http://tgmember.cf)

[![https://t.me/tgMember](https://img.shields.io/badge/%F0%9F%92%AC_Telegram-tgMember-blue.svg)](https://t.me/tgMember)


***


### _Instruction_ 

first goto botfather and create a robot

trun on inline mode, inline location and change Inline feedback to 100%

revoke token


***


## _Install Bot_


test with Ubuntu 16.04 x64:
```bash
git clone https://github.com/tgMember/tgGuard.git && cd tgGuard && bash make.sh
```

for install press key's "y" then "enter"


***


## _Set Configuratin_

##### *After install compelet, you must edit `api.lua` and `tgGuard.lua` with belove command*

_every where write `api bot id` you must insert robot api id created with botfather._

_every where write `cli bot id` you must insert telegram account id._

_every where write `your id` or `owner` you must insert your acoount id._


   - #### *Edit api.lua*


```
nano api.lua
```

replase your information in:

  line 8 = api bot token
 
  line 11 = your id (owner)
  
  line 15 = your id & cli bot id & other sudo user's
  
  line 165 =  #Cli Bot Id   -   #Your Id
 
for save press key's

 "ctrl+x" 
 
 "y" 
  
 "enter"



   - #### *Edit tgGuard.lua*

```
nano tgGuard.lua
```

edit and replace

 line 25 = cli bot id 
 
 line 26 = cli bot id 

 line 27 = your id (owner)

 line 28 = your id & cli bot id & other sudo user's
 
 line 35 = api bot id

 line 5946 = api bot id


for save press key's

 "ctrl+x" 
 
 "y" 
  
 "enter"


***


## _Run API Robot_

###### *From cli robot account, start api bot (created with botfather)*

Now send command to server:

```
./make.sh api
```

close server.


***


## _Launch Cli Bot_

open server and send belove command:


```bash
cd tgGuard
screen -S nohup ./make.sh bot
    # Will ask you for robot phone number & confirmation code.
```


***


## _Help and commands_ 

##### *Now you must go to your telegram account and add cli bot to super group and send :*

#### settings

##### *for see inline settings and help*
   
   
- _Don't use_  ! , # , /   _before command_.


***


# [Creator](https://telegram.me/sajjad_021)
# [Channel](https://telegram.me/tgMember)
