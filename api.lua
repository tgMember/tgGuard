package.path = package.path..';.luarocks/share/lua/5.2/?.lua;.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath..';.luarocks/lib/lua/5.2/?.so'

local URL = require "socket.url"
local https = require "ssl.https"
local serpent = require "serpent"
local json = (loadfile "JSON.lua")()
local token = '000000000:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'  --[[Enter tokn here]]
local url = 'https://api.telegram.org/bot' .. token
local offset = 0
local SUDO = 000000000   --[[Enter your id here]]
local redis = require('redis')
local redis = redis.connect('127.0.0.1', 6379)
function is_mod(chat,user)
	sudo = {158955285,279700027,180191663,000000000,000000000}  --[[Enter your id and cli bot id here]]
 local var = false
  for v,_user in pairs(sudo) do
    if _user == user then
      var = true
    end
  end
 local hash = redis:sismember(SUDO..'owners:'..chat,user)
 if hash then
 var = true
 end
 local hash2 = redis:sismember(SUDO..'mods:'..chat,user)
 if hash2 then
 var = true
 end
 return var
 end
local function getUpdates()
  local response = {}
  local success, code, headers, status  = https.request{
    url = url .. '/getUpdates?timeout=20&limit=1&offset=' .. offset,
    method = "POST",
    sink = ltn12.sink.table(response),
  }

  local body = table.concat(response or {"no response"})
  if (success == 1) then
    return json:decode(body)
  else
    return nil, "Request Error"
  end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function sendmsg(chat,text,keyboard)
if keyboard then
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text=' ..URL.escape(text)..'&parse_mode=html'
end
https.request(urlk)
end
 function edit( message_id, text, keyboard)
  local urlk = url .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end
function settings(chat,value) 
local hash = SUDO..'settings:'..chat..':'..value
  if value == 'file' then
      text = 'فیلتر فایل'
   elseif value == 'keyboard' then
    text = 'فیلتردرون خطی(کیبرد شیشه ای)'
  elseif value == 'link' then
    text = 'قفل ارسال لینک(تبلیغات)'
  elseif value == 'game' then
    text = 'فیلتر انجام بازی های(inline)'
    elseif value == 'username' then
    text = 'قفل ارسال یوزرنیم(@)'
   elseif value == 'pin' then
    text = 'قفل پین کردن(پیام)'
    elseif value == 'photo' then
    text = 'فیلتر تصاویر'
    elseif value == 'gif' then
    text = 'فیلتر تصاویر متحرک'
    elseif value == 'video' then
    text = 'فیلتر ویدئو'
    elseif value == 'audio' then
    text = 'فیلتر صدا(audio-voice)'
    elseif value == 'music' then
    text = 'فیلتر آهنگ(MP3)'
    elseif value == 'text' then
    text = 'فیلتر متن'
    elseif value == 'sticker' then
    text = 'قفل ارسال برچسب'
    elseif value == 'contact' then
    text = 'فیلتر مخاطبین'
    elseif value == 'forward' then
    text = 'فیلتر فوروارد'
    elseif value == 'persian' then
    text = 'فیلتر گفتمان(فارسی)'
    elseif value == 'english' then
    text = 'فیلتر گفتمان(انگلیسی)'
    elseif value == 'bot' then
    text = 'قفل ورود ربات(API)'
    elseif value == 'tgservice' then
    text = 'فیلتر پیغام ورود،خروج افراد'
	elseif value == 'groupadds' then
    text = 'تبلیغات'
    end
		if not text then
		return ''
		end
	if redis:get(hash) then
  redis:del(hash)
return text..'  غیرفعال شد.'
		else 
		redis:set(hash,true)
return text..'  فعال شد.'
end
    end
function fwd(chat_id, from_chat_id, message_id)
  local urlk = url.. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id
  local res, code, desc = https.request(urlk)
  if not res and code then --if the request failed and a code is returned (not 403 and 429)
  end
  return res, code
end
function sleep(n) 
os.execute("sleep " .. tonumber(n)) 
end
local day = 86400
local function run()
  while true do
    local updates = getUpdates()
    vardump(updates)
    if(updates) then
      if (updates.result) then
        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
		if q.from.id == 000000000 or q.from.id == 000000000 then
		--[[Enter       cli bot id       and        your id   ]]
            if q.query:match('%d+') then
              local chat = '-'..q.query:match('%d+')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'تنظیمات گروه', callback_data = 'groupsettings:'..chat} --,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = 'پشتیبانی ربات تلگرام گارد', callback_data = 'supportbot:'..chat},{text = 'تبلیغات شما', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'اطلاعات گروه', callback_data = 'groupinfo:'..chat},{text = 'tgGuard راهنمای', callback_data = 'helpbot:'..chat}
				}
							}
            answer(q.id,'settings','Group settings',chat,'به بخش اصلی تلگرام گارد خوش آمدید.\nاز منوی زیر انتخاب کنید:',keyboard)
            end
            end
						end
          if msg.callback_query then
            local q = msg.callback_query
						local chat = ('-'..q.data:match('(%d+)') or '')
						if is_mod(chat,q.from.id) then
             if q.data:match('_') and not (q.data:match('next_page') or q.data:match('left_page')) then
                Canswer(q.id,">برای مشاهده راهنمای بیشتر این بخش عبارت\n/help\nرا ارسال کنید\n>تیم پشتیبانی:[@tgMessageBot]\n>کانال پشتیبانی:[@tgMember]\n>کانال فروش:[@sajjad_021]",true)
					elseif q.data:match('lock') then
							local lock = q.data:match('lock (.*)')
							TIME_MAX = (redis:get(SUDO..'floodtime'..chat) or 3)
              MSG_MAX = (redis:get(SUDO..'floodmax'..chat) or 5)
							local result = settings(chat,lock)
							if lock == 'photo' or lock == 'audio' or lock == 'video' or lock == 'gif' or lock == 'music' or lock == 'file' or lock == 'link' or lock == 'sticker' or lock == 'text' or lock == 'pin' or lock == 'username' or lock == 'hashtag' or lock == 'contact' then
							q.data = 'left_page:'..chat
							elseif lock == 'muteall' then
								if redis:get(SUDO..'muteall'..chat) then
								redis:del(SUDO..'muteall'..chat)
									result = "فیلتر تمامی گفتگو ها غیرفعال گردید."
								else
								redis:set(SUDO..'muteall'..chat,true)
									result = "فیلتر تمامی گفتگو ها فعال گردید!"
							end
						 q.data = 'next_page:'..chat
							elseif lock == 'spam' then
							local hash = redis:get(SUDO..'settings:flood'..chat)
						if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         			spam_status = 'مسدود سازی(کاربر)'
							redis:set(SUDO..'settings:flood'..chat,'ban')
              elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              spam_status = 'سکوت(کاربر)'
							redis:set(SUDO..'settings:flood'..chat,'mute')
              elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              spam_status = '🔓'
							redis:del(SUDO..'settings:flood'..chat)
              end
          else
          spam_status = 'اخراج سازی(کاربر)'
					redis:set(SUDO..'settings:flood'..chat,'kick')
          end
								result = 'عملکرد قفل ارسال هرزنامه : '..spam_status
								q.data = 'next_page:'..chat
								elseif lock == 'MSGMAXup' then
								if tonumber(MSG_MAX) == 40 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [40] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) + 1
								redis:set(SUDO..'floodmax'..chat,MSG_MAX)
								q.data = 'next_page:'..chat
							  result = MSG_MAX
								end
								elseif lock == 'MSGMAXdown' then
								if tonumber(MSG_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) - 1
								redis:set(SUDO..'floodmax'..chat,MSG_MAX)
								q.data = 'next_page:'..chat
								result = MSG_MAX
							end
								elseif lock == 'TIMEMAXup' then
								if tonumber(TIME_MAX) == 5 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [5] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) + 1
								redis:set(SUDO..'floodtime'..chat,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
								elseif lock == 'TIMEMAXdown' then
								if tonumber(TIME_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) - 1
								redis:set(SUDO..'floodtime'..chat,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
								elseif lock == 'welcome' then
								local h = redis:get(SUDO..'status:welcome:'..chat)
								if h == 'disable' or not h then
								redis:set(SUDO..'status:welcome:'..chat,'enable')
         result = 'ارسال پیام خوش آمدگویی فعال گردید.'
								q.data = 'next_page:'..chat
          else
          redis:set(SUDO..'status:welcome:'..chat,'disable')
          result = 'ارسال پیام خوش آمدگویی غیرفعال گردید!'
								q.data = 'next_page:'..chat
									end
								else
								q.data = 'next_page:'..chat
								end
							Canswer(q.id,result)
							end
							-------------------------------------------------------------------------
							if q.data:match('firstmenu') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'تنظیمات گروه', callback_data = 'groupsettings:'..chat} --,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = 'پشتیبانی تی جی گارد', callback_data = 'supportbot:'..chat},{text = 'تبلیغات شما', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'اطلاعات گروه', callback_data = 'groupinfo:'..chat},{text = 'راهنما-help', callback_data = 'helpbot:'..chat}
				}
							}
            edit(q.inline_message_id,'`به بخش اصلی tgGuard خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('supportbot') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'تیم فنی', callback_data = 'teamfani:'..chat},{text = 'واحد فروش', callback_data = 'fahedsale:'..chat}
                },{
				 {text = 'گزارش مشکل', callback_data = 'reportproblem:'..chat},{text = 'انتقادات و پیشنهادات', callback_data = 'enteqadvapishnehad:'..chat}
				 },{
				 {text = 'سوالات متداول', callback_data = 'soalatmotadavel:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'به بخش پشتیبانی خوش آمدید.\nاز منوی زیر انتخاب کنید:',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('teamfani') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش ارتباط با بخش فنی خوش آمدید.`\n`در صورت وجود مشکل در ربات به ما پیغام ارسال کنید:`\n[ارسال پیغام](https://telegram.me/tgMessageBot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('reportproblem') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش گزارش مشکل خوش آمدید.`\n`در صورت وجود مشکل در کارکرد سرویس شما به ما اطلاع دهید:`\n[گزارش مشکل](https://telegram.me/tgMessageBot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('fahedsale') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'تمدید سرویس انتخابی', callback_data = 'tamdidservice:'..chat},{text = 'درخواست ربات به صورت رایگان', callback_data = 'salegroup:'..chat}

                },{
				{text = 'گزارشات مالی', callback_data = 'reportmony:'..chat}

                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش درخواست گروه،تمدید سرویس،گزارش مالی خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('tamdidservice') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`طرح انتخابی [شما دائمی/مادام العمر(نامحدود روز)] میباشد و نیاز به تمدید طرح ندارید!`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('reportmony') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش، متاسفانه این سیستم تا اطلاع ثانوی غیرفعال میباشد.`',keyboard)
            end
			------------------------------------------------------------------------
							if q.data:match('enteqadvapishnehad') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش انتقادات و پیشنهادات خوش آمدید.`\n`هرگونه انتقاد،پیشنهاد را با در میان بگذارید:`\n[ارسال انتقاد،پیشنهاد](https://telegram.me/tgMessageBot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('soalatmotadavel') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش، متاسفانه این سیستم تا اطلاع ثانوی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('youradds') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`جهت ثبت و درخواست تبلیغات به سازنده ربات به آیدی @sajjad_021 مراجعه کنید.`',keyboard)
            end
							------------------------------------------------------------------------
							--[[if q.data:match('groupinfo') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'با عرض پوزش، متاسفانه این سیستم تا اطلاع ثانوی غیرفعال میباشد.',keyboard)
            end]]
							------------------------------------------------------------------------
							if q.data:match('helpbot') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'راهنمای فارسی', callback_data = 'helptext:'..chat}
                },{
				 {text = 'english help', callback_data = 'enhelp:'..chat},{text = 'راهنمای تصویری', callback_data = 'videohelp:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش راهنمای ربات تلگرام گارد خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('helptext') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'صفحه بعد', callback_data = 'twohelp:'..chat},{text = 'صفحه قبلی', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'>[بخش راهنمای فارسی ربات tgGuard)](https://telegram.me/tgGuard)\n🔃راهنمای قفل اسپم و فلود ربات :\n\nقفل اسپم از ارسال پیام های بلند و طولانی جلوگیری میکند !\nحساسیت آن قابل تنظیم است و واحد آن کاراکتر ( حرف ) میباشد !\nدستور تنظیم آن به طور زیر میباشد :\n|تنظیم اسپم [ 40 - به بالا ]|\n➖➖\nمثلا شما میخواهید پیام های طولانی تر از 80 حرف پاک بشوند باید از دسور |تنظیم اسپم 80| استفاده نمایید !\nقفل فلود از ارسال چندین پیام پشت سر هم جلوگیری میکند !\n➖➖\nحساسیت و وضعیت آن قابل تنظیم است !\nوضعیت آن 2 حالت میباشد !\n⬅️ حالت اول : \nاگر کسی شروع به ارسال پیام پشت سر هم بکند ، تمامی پیام های او پاک خواهد شد و تا 5 ثانیه نمیتواند پیامی ارسال کند !\nدستور فعال سازی این وضعیت :\n|وضعیت فلود حذف پیام|\n➖➖\n⬅️ حالت دوم : \nاگر کسی شروع به ارسال پیام پشت سر هم بکند ، تمامی پیام های او پاک خواهد شد و از گروه هم ریموو خواهد شد !\n|وضعیت فلود اخراج|\n➖➖\n⬅️حساسیت آن هم به حد پیام تکراری قابل تنظیم است !\n|تنظیم فلود [ 1 - به بالا ]|\n\n🔃 راهنمای قفل های اصلی تلگرام گارد :\n⬅️ قفل اسپم :\nفعال سازی :\n|قفل اسپم|\nغیرفعال سازی :\n|بازکردن اسپم|\n➖➖\n⬅️ قفل لینک :\nفعال سازی :\n|قفل لینک|\nغیرفعال سازی :\n|بازکردن لینک|\n➖➖\n️⬅️ قفل آدرس اینترنتی :\nفعال سازی :\n|قفل صفحات اینترنتی|\nغیرفعال سازی :\n|بازکردن صفحات اینترنتی|\n➖➖\n⬅️ قفل تگ :\nفعال سازی :\n|قفل تگ|\nغیرفعال سازی :\n|بازکردن تگ|\n➖➖\n️⬅️ قفل هشتگ :\nفعال سازی :\n|قفل هشتگ|\nغیرفعال سازی :\n|بازکردن هشتگ|\n➖➖\n⬅️ قفل فروارد :\nفعال سازی :\n|قفل فوروارد|\nغیرفعال سازی :\n|بازکردن فوروارد|\n➖➖\n⬅️ قفل ورود ربات :\nفعال سازی :\n|قفل ربات ها|\nغیرفعال سازی :\n|بازکردن ربات ها|\n➖➖\n️⬅️ قفل ویرایش پیام :\nفعال سازی :\n|قفل ویرایش پیام|\nغیرفعال سازی :\n|بازکردن ویرایش پیام|\n➖➖\n️⬅️ قفل مدل نشانه گذاری :\nفعال سازی :\n|قفل مدل نشانه گذاری|\nغیرفعال سازی :\n|بازکردن مدل نشانه گذاری|\n➖➖\n️⬅️ قفل سنجاق پیام :\nفعال سازی :\n|قفل سنجاق پیام|\nغیرفعال سازی :\n|بازکردن سنجاق پیام|\n➖➖\n⬅️ قفل دکمه شیشه ایی :\nفعال سازی :\n|قفل دکمه شیشه ایی|\nغیرفعال سازی :\n|یازکردن دکمه شیشه ای|\n➖➖\n⬅️ قفل نوشتار فارسی :\nفعال سازی :\n|قفل فارسی|\nغیرفعال سازی :\n|بازکردن فارسی|\n➖➖\n⬅️ قفل نوشتار انگلیسی :\nفعال سازی :\n|قفل انگلیسی|\nغیرفعال سازی :\n|بازکردن انگلیسی|\n➖➖\n️⬅️ قفل سرویس تلگرام :\nفعال سازی :\n|قفل سرویس تلگرام|\nغیرفعال سازی :\n|بازکردن سرویس تلگرام|\n➖➖\n⬅️ قفل فلود :\nفعال سازی :\n|قفل فلود|\nغیرفعال سازی :\n|بازکردن فلود|\n⬅️ حساسیت فلود :\n|تنظیم فلود [ 2 - به بالا ]|\n➖➖\n️⬅️ حساسیت اسپم :\n|تنظیم اسپم [ 40 - به بالا ]|\n\n🔃راهنمای قفل های رسانه :\n\n⬅️ قفل متن [ چت ] :\nفعال سازی :\n|قفل متن|\nغیرفعال سازی :\n|بازکردن متن|\n➖➖\n⬅️ قفل عکس :\nفعال سازی :\n|قفل عکس|\nغیرفعال سازی :\n|بازکردن عکس|\n➖➖\n⬅️ قفل فیلم :\nفعال سازی :\n|قفل فیلم|\nغیرفعال سازی :\n|بازکردن فیلم|\n➖➖\n⬅️ قفل گیف :\nفعال سازی :\n|قفل گیف|\nغیرفعال سازی :\n|بازکردن گیف|\n➖➖\n⬅️ قفل موزیک :\nفعال سازی :\n|قفل موزیک|\nغیرفعال سازی :\n|بازکردن موزیک|\n➖➖\n⬅️ قفل ویس :\nفعال سازی :\n|قفل ویس|\nغیرفعال سازی :\n|بازکردن ویس|\n➖➖\n قفل فایل :\nفعال سازی :\n|قفل فایل|\nغیرفعال سازی :\n|بازکردن فایل|\n➖➖\n⬅️ قفل استیکر :\nفعال سازی :\n|قفل استیکر|\nغیرفعال سازی :\n|بازکردن استیکر|\n➖➖\n⬅️ قفل ارسال مخاطب :\nفعال سازی :\n|قفل مخاطب|\nغیرفعال سازی :\n|بازکردن مخاطب|\n➖➖\n️⬅️ قفل موقعیت مکانی :\nفعال سازی :\n|قفل موقعیت مکانی|\nغیرفعال سازی :\n|بازکردن موقعیت مکانی|\n\n',keyboard)
            end
							
							------------------------------------------------------------------------
							if q.data:match('twohelp') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helptext:'..chat}
				}
							}
              edit(q.inline_message_id,'🔃راهنمای مدیران برای ارتقا یا عزل مقام یک کاربر :\n\n روش اول : \nروی یکی از پیام های کاربر مورد نظر ریپلای کنید و دستور |ارتقا مقام| را ارسال کنید !\n➖➖\n⬅️ روش دوم : \nدستور |ارتقا مقام| را بنویسید و جلوی دستور آیدی عددی فرق مورد نظر را بنویسید !\nمثال :\n|ارتقا مقام 123456789|\n➖➖\n⬅️ روش سوم :\nدستور |ارتقا مقام| را بنویسید و جلوی آن یوزرنیم کاربر مورد نظر را بنویسید !\nمثال :\n|ارتقا مقام @Userid|\n➖➖\n⬅️ برای عزل مقام یک نفر کافیست مراحل بالا را تنها با تفاوت اینکه به جای دستور |ارتقا مقام| دستور |عزل مقام| را جایگزین کنید.\nمثال :\n|عزل مقام @Userid|\n➖➖\n⬅️ ممنوعیت های ربات: \n برای فیلتر کردن و بان کی مون یک کلمه \n⬅️ ممنوع کردن کلمه یا حروف: فیلتر [کلمه] \n⬅️ حذف کلمه از ممنوعیت: حذف فیلتر [کلمه] \n⬅️ دستور کلمات ممنوع :|لیست فیلتر| \n ➖➖\n⬅️ زبان ربات : \n برای تغییر ساعت تابستانی بازگشت زبان \n⬅️ دستور انگلیسی کردن: |تنظیم زبان| EN \n⬅️ دستورفارسی کردن: |تنظیم زبان| FA \n ➖➖\n ⬅️  حذف پیام بصورت کلی: \n برای حذف پیام ها بصورت کلی \n⬅️ دستور حذف پیام : |حذف| [1 - 99] \n\n🔃راهنمای تنظیم و دریافت لینک گروه :\n\n⬅️ ابتدا دستور |تنظیم لینک| را وارد کنید !\n➖➖\n⬅️ سپس لینک گروه را داخل خود گروه ارسال کنید تا ثبت شود !\n➖➖\n⬅️ پس از ثبت شدن میتوانید با دستور |لینک| آن را هر زمان که خواستید دریافت کنید !\n\n🔃راهنمای وضعیت های ربات :\n➖➖\n⬅️حالت سختگیرانه \nحالتی است که اگر فعال باشد ، کسی که لینک ارسال کند را از گروه ریموو میکند !\nفعال سازی :\n|قفل حالت سختگیرانه|\nغیرفعال سازی :\n|بازکردن حالت سختگیرانه|\n➖➖\n⬅️حالت قفل کلی گروه : \nحالتی است که از ارسال هر گونه پیام توسط کاربران عادی جلوگیری میکند !\nفعال سازی :\n|قفل همه|\nغیرفعال سازی :\n|بازکردن همه|\n\nبرای فعال سازی به صورت زمان دار میتوانید به شکل زیر عمل کنید :\nفعال سازی برای مدت یک ساعت :\n|قفل گروه 1|\nفعال سازی به مدت دو ساعت :\n|قفل گروه 2|\nو الی آخر ...\n➖➖\n⬅️ حالت عدم جواب : \nبعضی از دستورات همگانی هستند ، یعنی به کاربر عادی هم پاسخ داده میشود ، اگر این حالت فعال باشد به آنها پاسخ نخواهد داد !\nفعال سازی :\n|قفل حالت عدم جواب|\nغیرفعال سازی:\n|بازکردن حالت عدم جواب|\n\n🔃 راهنمای امکانات جانبی ربات تلگرام گارد :\n\nبرای دریافت مشخصات خود میتوانید از دستور id استفاده کنید !\n➖➖\nاگر میخواهید ربات مشخصات شما را همراه با عکس پروفایل شما ارسال کند ، دستور |وضعیت دریافت آیدی photo را ارسال کنید ! برای بازگشت به حالت ساده دستور ||وضعیت دریافت آیدی simple را ارسال نمایید !\n➖➖\nدستور |اطلاعات من| برای دریافت شناسه عددی و مقام شما میباشد !\n➖➖\nبرای دریافت شناسه عددی یک فرد میتوانید از 2 روش استفاده کنید.\n⬅️ روش اول : \nریپلای کردن یک پیام فرد مورد نظر و ارسال دستور |آیدی|\n➖➖\n⬅️ روش دوم :\nنوشتن دستور |آیدی| و جلوی آن گذاشتن یوزرنیم فرد مورد نظر\nمثال :\n|آیدی| @Userid\n➖➖\nبرای دریافت عکس های پروفایل خود میتوانید از دستور زیر استفاده کنید.\n|عکس پروفایلم [ 1 - 10 ]|\nمثال : \nعکس پروفایلم 2\n➖➖\nبرای سنجاق کردن یک پیام توسط ربات میتوانید پیام مورد نظر را ریپلای کنید سپس دستور |سنجاق کن| را ارسال کنید.\nبرای خارج کردن پیام از حالت سنجاق میتوانید از دستور |حذف سنجاق| استفاده کنید.\nبرای مجدد سنجاق کردن پیام سابق میتوانید از دستور |سنجاق مجدد| استفاده نمایید.\n➖➖\n⬅️ لیست های لغو کردن :\n برای پاک کردن لیست از عنوان ها:\n ⬅️ دستور شروع نمایش لیست لغو: پاک کردن\n = رباتها / banlist / modlist / filterlist / mutelist (*) (*.)\n➖➖\nبرای این دستورات پیش نمایش نیاز نیست❗️\n\n\n➖➖➖➖➖\n  ➖➖➖\n    ➖➖➖➖➖\n      ➖➖➖\n        ➖\n        `develop by @sajjad_021`\n        tgChannel : @tgMembe',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('videohelp') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'>[فیلم های آموزشی ما در آپارات](https://aparat.com/tgMember)\n\n*فیلم های آموزشی ما را در کانال آپارات دنبال کنید*\nhttps://aparat.com/tgMember',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('enhelp') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'>[tgGuard english help](https://telegram.me/tgGuard)\ntgGuard General Options\n\n➡️ Group Enable Settings :\nTo Lock General Options \n➡️ Command : Lock (.*)\n(.*) = Spam/Links/Webpage/Tag/Hashtag/Fwd/Bots/Edit/Markdown/Mention/Pin/Inline/Farsi/English/Tgservice/Flood\n➡️ Example : Lock Links\n➖➖\n➡️ Group Disable Settings :\nTo Unlock General Options \n➡️ Command : Unlock (.*)\n(.*) = Spam/Links/Webpage/Tag/Hashtag/Fwd/Bots/Edit/Markdown/Mention/Pin/Inline/Farsi/English/Tgservice/Flood\n➡️ Example : Unlock Links\n\nflood settings \n\n🔃Bot Flood & Spam :\n\n➡️ Set Spam Char :\nSet A Number For Spam Check And Then More Than That Number Of Word Char Has Been Delete\n➡️ Command : Setspam [More Than 40]\n➡️ Example : Setspam 60\n➖➖\n➡️ Flood Status :\nSet Flood Status To Kick Or Del User Or Just Msg\n1 - Command : Setstatus del\n|To Del Msg|\n2 - Command : Setstatus kick\n|To Kick User|\n➖➖\n➡️ Flood Check Time :\nSet A Time That Bot Check Flooding\n➡️ Command : Setflood [1 Or More]\n➡️ Example : Setflood 5\n\n🔃Bot Media Options:\n\n➡️ Group Enable Settings For Media :\nTo Lock Media Options \n➡️ Command : Lock (.)\n(.) = Text/Photo/Video/Gif/Music/Voice/File/Sticker/Contact/Location\n➡️ Example : Lock photo\n➖➖\n➡️ Group Disable Settings For Media :\nTo Unlock Media Options \n➡️ Command : Unlock (.)\n(.) = Text/Photo/Video/Gif/Music/Voice/File/Sticker/Contact/Location\n➡️ Example : Unlock photo\n\n\n🔃Set Gpinfo Options:\n\n➡️ Set Group Information\nUse These Simple Commands To Set Link Rules and ...\n➡️ Command : Setlink\n➡️ Command : Link\n➡️ Command : Setrules\n➡️ Command : Rules\n➡️ Command : Note (Msg)\n➡️ Command : Getnote\n➡️ Command : Setphoto\n➡️ Command : Expire\n➡️ Command : Del (Num)\n➡️ Command : Welcome on\n➡️ Command : Welcome Off\n➡️ Command : Set welcome (Text)\n➡️ Command : Del welcome\n➡️ Command : Get welcome\n\nBot Conditions :\n➡️ Strict :\nThe Condition That The Wrongdoer User Has Been Remove From GP.\nEnable : Lock strict\nDisable : Unlock strict\n➖➖\n➡️ Group Lock All :\nThe Condition That Any Body Cant Chat And This is Like Mute all\nEnable : Lock all\nDisable : Unlock all\n➖➖\n➡️ No Answer To Users :\nThe Bot Does Not Answer To User Commands\nEnable : Lock cmd\nDisable : Unlock cmd\n➖➖\n➡️ Group Lock Time :\nSet Timer For Unlock Group Chat and ...\nCommand : Lock gtime [Time]\nExample : Lock gtime 2\nFor 2Hours\n\n🔃tgGuard Lateral Options :\n\n➡️ Group /User Info  :\nTo Get Group/User Information \n➡️ Command : id\n➡️ Command : me\n➡️ Command : id @userid\n➖➖\n➡️ User Profile :\nTo Get User Profile Photos \n➡️ Command : Getpro [1 - 10]\n➡️ Example : Getpro 3\n➖➖\n➡️ Group Notify :\nTo Pin Or Unpin Or Repin a Msg By Bot\n➡️ Command : Pin\n➡️ Command : Unpin\n➡️ Command : Repin\n➖➖\n➡️ Online Status :\nTo See Bot Status\n➡️ Command : Ping\n➖➖\n➡️ Filtering :\nTo Filter And Ban A Word\n➡️ Command : Filter [Word]\n➡️ Command : Unfilter [Word]\n➡️ Command : Filterlist\n➖➖\n➡️ Bot Lang :\nTo Change Bot Return Language\n➡️ Command : Setlang en\n➡️ Command : Setlang fa\n➖➖\n➡️ Del Msgs :\nTo Remove Msgs\n➡️ Command : Del [1 - 99]\n\n➖➖➖➖➖\n  ➖➖➖\n    ➖➖➖➖➖\n      ➖➖➖\n        ➖\n        `develop by @sajjad_021`\n        tgChannel : @tgMembe',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('groupinfo') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'لیست مالکین', callback_data = 'ownerlist:'..chat},{text = 'لیست مدیران', callback_data = 'managerlist:'..chat}
                },{
				 {text = 'مشاهده قوانین', callback_data = 'showrules:'..chat},{text = 'لینک ابرگروه', callback_data = 'linkgroup:'..chat}
				 },{
				 {text = 'کاربران مسدود شده', callback_data = 'banlist:'..chat},{text = 'کلمات فیلتر شده', callback_data = 'filterlistword:'..chat}
				  },{
				 {text = 'کاربران حالت سکوت', callback_data = 'silentlistusers:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش اطلاعات گروه خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('managerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'mods:'..chat)
          local t = '`>لیست مدیران گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>مدیریت برای این گروه ثبت نشده است.`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده مدیران', callback_data = 'showmanagers:'..chat},{text = 'حذف لیست مدیران', callback_data = 'removemanagers:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showmanagers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('ownerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'owners:'..chat)
          local t = '`>لیست مالکین گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست مالکان گروه خالی میباشد!`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده مالکین', callback_data = 'showowners:'..chat},{text = 'حذف لیست مالکین', callback_data = 'removeowners:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showrules') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local rules = redis:get(SUDO..'grouprules'..chat)
          if not rules then
          rules = '`>قوانین برای گروه تنظیم نشده است.`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'حذف قوانین', callback_data = 'removerules:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, 'قوانین گروه:\n `'..rules..'`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('linkgroup') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local links = redis:get(SUDO..'grouplink'..chat) 
          if not links then
          links = '`>لینک ورود به گروه تنظیم نشده است.`\n`ثبت لینک جدید با دستور زیر امکان پذیر است:`\n*/setlink* `link`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'حذف لینک ابرگروه', callback_data = 'removegrouplink:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`لینک ورود به ابرگروه:`\n '..links..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('banlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers(SUDO..'banned'..chat)
          local t = '`>لیست افراد مسدود شده از گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست افراد مسدود شده از گروه خالی میباشد.`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده کاربران', callback_data = 'showusers:'..chat},{text = 'حذف لیست', callback_data = 'removebanlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showusers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('silentlistusers') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers(SUDO..'mutes'..chat)
          local t = '`>لیست کاربران حالت سکوت` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست کاربران حالت سکوت خالی میباشد!`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده کاربران', callback_data = 'showusersmutelist:'..chat},{text = 'حذف لیست', callback_data = 'removesilentlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showusersmutelist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('filterlistword') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'filters:'..chat)
          local t = '`>لیست کلمات فیلتر شده در گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '`>لیست کلمات فیلتر شده خالی میباشد`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removefilterword:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							--########################################################################--
							if q.data:match('removemanagers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'bgdbdfddhdfhdyumrurmtu:'..chat},{text = '✅بله', callback_data = 'hjwebrjb53j5bjh3:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست مدیران گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('hjwebrjb53j5bjh3') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del(SUDO..'mods:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست مدیران گروه با موفقیت بازنشانی شد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('bgdbdfddhdfhdyumrurmtu') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard)
            end
						--########################################################################--
						if q.data:match('removeowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'ncxvnfhfherietjbriurti:'..chat},{text = '✅بله', callback_data = 'ewwerwerwer4334b5343:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست مالکین گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ewwerwerwer4334b5343') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'owners:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست مالکین گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncxvnfhfherietjbriurti') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removerules') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'as12310fklfkmgfvm:'..chat},{text = '✅بله', callback_data = '3kj5g34ky6g34uy:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'showrules:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل متن قوانین تنظیم شده گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('3kj5g34ky6g34uy') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'grouprules'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>قوانین گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('as12310fklfkmgfvm') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removegrouplink') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del(SUDO..'grouplink'..chat) 
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'linkgroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لینک ثبت شده با موفقیت بازنشانی گردید.`',keyboard)
            end
							--########################################################################--
								if q.data:match('removebanlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'sudfewbhwebr9983243:'..chat},{text = '✅بله', callback_data = 'erwetrrefgfhfdhretre:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست کاربران مسدود شده از گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('erwetrrefgfhfdhretre') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'banned'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست کاربران مسدود شده از گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('sudfewbhwebr9983243') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
								if q.data:match('removesilentlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'sadopqwejjbkvw90892:'..chat},{text = '✅بله', callback_data = 'ncnvdifeqrhbksdgfid47:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست کاربران حالت سکوت گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncnvdifeqrhbksdgfid47') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'mutes'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست افراد کاربران لیست سکوت با موفقیت حذف گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('sadopqwejjbkvw90892') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removefilterword') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'ncxvbcusxsokd9374uid:'..chat},{text = '✅بله', callback_data = 'erewigfuwebiebfjdskfbdsugf:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'filterlistword:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست تمامی کلمات فیلترشده گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('erewigfuwebiebfjdskfbdsugf') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'filters:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>تمامی کلمات فیلتر شده با موفقیت حذف گردیدند.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncxvbcusxsokd9374uid') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							--#####################################################################--
							if q.data:match('salegroup') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = 'مدیریت معمولی گروه', callback_data = 'normalmanage:'..chat}
                },{
				{text = 'مدیریت پیشرفته گروه', callback_data = 'promanage:'..chat}
                },{
				{text = 'مدیریت حرفه ای گروه', callback_data = 'herfeiimanage:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`در این بخش شما میتوانید نسبت به درخواست ربات جدید و رایگان اقدام کنید.`\n`سرویس مورد نظر خود را انتخاب کنید:`',keyboard)
            end
			------------------------------------------------------------------------
							if q.data:match('normalmanage') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'tarhvatarefe:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'baresiqabeliyat:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت معمولی گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard) 
            end
							------------------------------------------------------------------------
							if q.data:match('promanage') then
                           local chat = '-'..q.data:match('(%d+)$')
						  --redis:del(SUDO..'filters:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'tarhpro:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'pishrafteberesi:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت پیشرفته گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('herfeiimanage') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'herfetarh:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'qabeliyarherfeii:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت حرفه ای گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard) 
            end
							--********************************************************************--
							if q.data:match('tarhpro') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'promanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *14900*\n`سالانه(365 روز کامل)` > *34000*\n`دائمی/مادام العمر(نامحدود روز)` > *45000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
			------------@@@@@@@@@@@@@@@@@@@@@@@@@@------------------
			if q.data:match('tarhvatarefe') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'normalmanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *9900*\n`سالانه(365 روز کامل)` > *23000*\n`دائمی/مادام العمر(نامحدود روز)` > *35000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
			------------@@@@@@@@@@@@@@@@@@@@@@@@@@------------------
			if q.data:match('herfetarh') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'herfeiimanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *16900*\n`سالانه(365 روز کامل)` > *37500*\n`دائمی/مادام العمر(نامحدود روز)` > *49000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
							----------------------------------بررسی قابلیت ها--------------------------------------
							if q.data:match('pishrafteberesi') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'promanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت بالا در انجام دستورات و موارد تنظیم شده برای گروه خود--دقت در انجام دستورات داده شده: 100%--رابط کاربری فوق العاده و دارای قابلیت و متود های جدید تلگرام(توضیحات بیشتر در پست های بالا موجود میباشد.))',keyboard)
            end
							--********************************************************************--
							if q.data:match('baresiqabeliyat') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'normalmanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت پایین تر نسبت به ربات بالا(به دلیل زیاد شدن آمار گروه های فعال ربات--عمر ربات: 26 ماه)--دقت در انجام دستورات داده شده: 96%--رابط کاربری فوق العاده و دارای قابلیت های پیشرفته و نسبتا جدید)',keyboard)
            end
							--********************************************************************--
							if q.data:match('qabeliyarherfeii') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'herfeiimanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت بالا در انجام دستورات و موارد تنظیم شده برای گروه خود--دقت در انجام دستورات داده شده: 100%--رابط کاربری فوق العاده و دارای قابلیت و متود های جدید تلگرام(توضیحات بیشتر در پست های بالا موجود + مدیریت حرفه ای(دارای پنل مدیریتی خودکار و بدون نیاز به ارسال دستور!)',keyboard)
            end
							--********************************************************************--
							--********************************************************************--
							--********************************************************************--
							------------------------------------------------------------------------
							if q.data:match('groupsettings') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end

local function getsettings(value)
       if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "نامحدود!"
       end
        elseif value == 'muteall' then
				local h = redis:ttl(SUDO..'muteall'..chat)
          if h == -1 then
        return '🔐'
				elseif h == -2 then
        return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
					local hash = redis:get(SUDO..'status:welcome:'..chat)
        if hash == 'enable' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
        local hash = redis:get(SUDO..'settings:flood'..chat)
        if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         return 'اخراج(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              return 'مسدود سازی(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              return 'سکوت(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
              local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
                 {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = 'فیلتر تصاویر', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = 'فیلتر ویدئو', callback_data = chat..'_video'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock audio'}, {text = 'فیلتر صدا', callback_data = chat..'_audio'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = 'فیلتر تصاویر متحرک', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock music'}, {text = 'فیلتر آهنگ', callback_data = chat..'_music'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = 'فیلتر فایل', callback_data = chat..'_file'}
                },{
                  {text=getsettings('link'),callback_data=chat..':lock link'},{text = 'قفل ارسال لینک', callback_data = chat..'_link'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = 'فیلتر برچسب', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = 'فیلتر متن', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = 'قفل پیغام پین شده', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = 'فیلتر یوزرنیم', callback_data = chat..'_username'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = 'فیلتر مخاطبین', callback_data = chat..'_contact'}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = '▶️ صفحه بعدی', callback_data = 'next_page:'..chat}
                }
							}
            edit(q.inline_message_id,'تنظیمات-ابرگروه(فیلترها):',keyboard)
            end
			------------------------------------------------------------------------
            if q.data:match('left_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
 end
local function getsettings(value)
       if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "نامحدود!"
       end
        elseif value == 'spam' then
        local hash = redis:get(SUDO..'settings:flood'..chat)
        if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         return 'اخراج(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              return 'مسدود سازی(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              return 'سکوت(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
							local keyboard = {}
							keyboard.inline_keyboard = {
									{
                 {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = 'فیلتر تصاویر', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = 'فیلتر ویدئو', callback_data = chat..'_video'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock audio'}, {text = 'فیلتر صدا', callback_data = chat..'_audio'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = 'فیلتر تصاویر متحرک', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock music'}, {text = 'فیلتر آهنگ', callback_data = chat..'_music'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = 'فیلتر فایل', callback_data = chat..'_file'}
                },{
                  {text=getsettings('link'),callback_data=chat..':lock link'},{text = 'قفل ارسال لینک', callback_data = chat..'_link'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = 'فیلتر برچسب', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = 'فیلتر متن', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = 'قفل پیغام پین شده', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = 'فیلتر یوزرنیم', callback_data = chat..'_username'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = 'فیلتر مخاطبین', callback_data = chat..'_contact'}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = '▶️ صفحه بعدی', callback_data = 'next_page:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(بخش1):',keyboard)
            end
						if q.data:match('next_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
local function getsettings(value)
        if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "نامحدود!"
       end
        elseif value == 'muteall' then
        local h = redis:ttl(SUDO..'muteall'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
        local hash = redis:get(SUDO..'status:welcome:'..chat)
        if hash == 'enable' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
        local hash = redis:get(SUDO..'settings:flood'..chat)
        if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         return 'اخراج(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              return 'مسدود-سازی(کاربر)'
              elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              return 'سکوت-کاربر'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
									local MSG_MAX = (redis:get(SUDO..'floodmax'..chat) or 5)
								local TIME_MAX = (redis:get(SUDO..'floodtime'..chat) or 3)
         		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text=getsettings('forward'),callback_data=chat..':lock forward'},{text = 'فیلتر فوروارد', callback_data = chat..'_forward'}
                },{
                  {text=getsettings('bot'),callback_data=chat..':lock bot'},{text = 'قفل ورود ربات(API)', callback_data = chat..'_bot'}
                },{
                  {text=getsettings('game'),callback_data=chat..':lock game'},{text = 'فیلتر بازی(inline)', callback_data = chat..'_game'}
                },{
                  {text=getsettings('persian'),callback_data=chat..':lock persian'},{text = 'فیلتر گفتمان فارسی', callback_data = chat..'_persian'}
                },{
                  {text=getsettings('english'),callback_data=chat..':lock english'},{text = 'فیلتر گفتمان انگلیسی', callback_data = chat..'_english'}
                },{
                  {text=getsettings('keyboard'),callback_data=chat..':lock keyboard'},{text = 'قفل دکمه شیشه ای', callback_data = chat..'_keyboard'}
                },{
                  {text=getsettings('tgservice'),callback_data=chat..':lock tgservice'},{text = 'فیلتر پیغام ورود،خروج', callback_data = chat..'_tgservice'}
                },{
                 {text=getsettings('muteall'),callback_data=chat..':lock muteall'}, {text = 'فیلتر تمامی گفتگو ها', callback_data = chat..'_muteall'}
                },{
                 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = 'پیغام خودش آمدگویی', callback_data = chat..'_welcome'}
                },{
                 {text=getsettings('spam'),callback_data=chat..':lock spam'}, {text = 'عملکرد قفل ارسال هرزنامه', callback_data = chat..'_spam'}
                },{
                 {text = 'حداکثر زمان ارسال هرزنامه: '..tostring(TIME_MAX)..' ثانیه', callback_data = chat..'_TIME_MAX'}
                },{
									{text='⬇️',callback_data=chat..':lock TIMEMAXdown'},{text='⬆️',callback_data=chat..':lock TIMEMAXup'}
									},{
                 {text = 'حداکثر پیغام ارسال هرزنامه: '..tostring(MSG_MAX)..' پیام', callback_data = chat..'_MSG_MAX'}
                },{
									{text='⬇️',callback_data=chat..':lock MSGMAXdown'},{text='⬆️',callback_data=chat..':lock MSGMAXup'}
									},{
                  {text='تاریخ انقضاء گروه: '..getsettings('charge'),callback_data=chat..'_charge'}
                },{
                  {text = 'صفحه قبلی ◀️', callback_data = 'left_page:'..chat},{text = '▶️ صفحه بعدی', callback_data = 'next_pagee:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه:',keyboard)
            end
            else Canswer(q.id,'شما مالک/مدیر گروه نیستید و امکان تغییر تنظیمات را ندارید!\n>برای درخواست ربات به آیدی زیر مراجعه فرمایید-این ربات رایگان میباشد:\n@sajjad_021',true)
						end
						end
          if msg.message and msg.message.date > (os.time() - 5) and msg.message.text then
     end
      end
    end
  end
    end
end

return run()