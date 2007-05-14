menu status {
  $server
  .$style(2) Подключено $uptime(server,1):nill
  .Количество пользователей:{ echo -s Запрос количества пользователей | lusers }
  .Список каналов:list
  .Сообщение:{ echo -s Запрос сообщения сервера | motd }
  .Время на сервере:{ echo -s Запрос времени на сервере | time }
  Автокоманды:runt strings/perform.txt
  -
}

menu query,nicklist {
  Информация
  .В окне:uwho $$1
  .$iif($address($$1,5),$ifmatch):clipboard $address($$1,5)
  .$iif($comchan($$1,0),$style(2) Общих каналов $chr(58) $ifmatch):nill
  .$iif($readini(strings/passes.ini,$1,names),Изменить обращение):{ var %str = $readini(strings/passes.ini,$1,names) | var %num = $$input(Выберите номер изменяемого обращения: $crlf $+ $replace(%str,$chr(1),$crlf),ye,Изменение обращения,1) | %str = $puttok(%str,$$input(Введите новое обращение к $1,ey,Изменение обращения,$gettok(%str,%num,1)),%num,1) | writeini strings/passes.ini $1 names %str }
  .$iif(!$2,Добавить обращение):{ var %txt = $input(Введите строку обращения к $1,ey,Добавление обращения) | if (%txt) { var %str = $readini(strings/passes.ini,$1,names) | if ($istok(%str,$1,1)) { %txt = $input(Такое обращение уже есть,o,Ввод обращения) | halt } | %str = $addtok(%str,%txt,1) | writeini strings/passes.ini $1 names %str } }
  .$iif($readini(strings/passes.ini,$1,names),Удалить обращения):{ var %str = $readini(strings/passes.ini,$1,names) | var %num = $$input(Выберите номер изменяемого обращения: $crlf $+ $replace(%str,$chr(1),$crlf),ye,Удаление обращения,1) | var %txt = $$input(Точно удалить обращение $gettok(%str,%num,1)) $+ ?,%num,1),y,Удаление сообщения) | %str = $deltok(%str,%num,1) | writeini strings/passes.ini $1 names %str }
  Кто:whois $$1
  Призрак:{ $netget(nickserv.call) ghost $$1 $nickget($1,password) | if (!$netget(fastghost)) .timer 1 1 nick $$1 }
  -
  $iif($active != $$1,Открыть приват):query $1
  $iif($menu == nicklist,Обращение):nick.insert $snicks
  Сообщение:msg $$1 $$?="Сообщение для $1 $+ :"
  Нотис:notice $$1 $$?="Сообщение для $1 $+ :"
  CTCP:ctcp $$1 $$?="Сообщение для $1 $+ :"
  CTCP:
  .Ping:ctcp $$1 ping
  .Time:ctcp $$1 time
  .Version:ctcp $$1 version
  .Finger:ctcp $$1 finger
  .-
  .$submenu($menulist($1,ctcp))
  .Настройка:runt strings/ctcp.txt
  DCC
  .Послать файл:dcc send $$1
  .Чат:dcc chat $$1
  -
  Позвать на
  .$submenu($menulist($1,invite))
}

menu nicklist {
  -
  Контроль
  .$iif(($me isop $chan) || ($me ishop $chan),Кик)
  ..Причина:kick $chan $$1 $$input(А смысл?,ey,Причина кика $nick с $chan,Мат)
  ..Случайная причина из файла:kick $chan $$1 $read(strings/kick.txt)
  ..Список
  ...$submenu($menulist($1,kick))
  .Кик через сервис
  ..Через сервис по причине:$netget(chanserv.call) kick $chan $$1 $$input(А смысл?,ey,Причина кика $nick с $chan,Мат)
  ..Через сервис по случайной причине:$netget(chanserv.call) kick $chan $$1 $read(strings/kick.txt)
  ..Список
  ...$submenu($menulist($1,cskick))
  .$iif(($me isop $chan) || ($me ishop $chan),Быстро):kick $chan $$1 Быстрый пинок под зад от $me
  .Быстрый кик через сервис:$netget(chanserv.call) kick $chan $$1 Быстрый пинок под зад от $me
  .$iif($me isop $chan,Бан)
  ..Причина:{ var %tmp = $input(Введите причину,ey,Причина кикбана,Мат) | mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 %tmp }
  ..Случайная причина из файла:{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 $read(strings/kick.txt) }
  ..Список
  ...$submenu($menulist($1,bankick))
  ..Без кика:{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* }
  .$iif($me isop $chan,Быстро):{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 Быстрый банан от $me (нарушение правил) }
  .-
  .$iif(($1 isop $chan) && ($me isop $chan),Деоп) $iif(($1 !isop $chan) && ($me isop $chan),Оп) :mode $chan $iif($1 isop $chan,-,+) $+ ooo $$1-3
  .$iif(($1 isop $chan) && ($netget(cs.op)),Деоп,Оп) через сервис:$netget(chanserv.call) $iif($1 isop $chan,deop,op) $chan $$1
  .$iif(($1 ishop $chan) && (($me isop $chan) || ($me ishop $chan)),Дехоп) $iif(($1 !ishop $chan) && (($me isop $chan) || ($me ishop $chan)),Хоп) :mode $chan $iif($1 ishop $chan,-,+) $+ hhh $$1-3
  .$iif($netget(cs.hop),$iif($1 ishop $chan,Дехоп,Хоп) через сервис):$netget(chanserv.call) $iif($1 ishop $chan,dehalfop,halfop) $chan $$1
  .$iif(($1 isvoice $chan) && (($me isop $chan) || ($me ishop $chan) || ($me == $1)),Девойс) $iif(($1 !isvoice $chan) && (($me isop $chan) || ($me ishop $chan)),Войс) :mode $chan $iif($1 isvoice $chan,-,+) $+ vvv $$1-3
  .$iif($netget(cs.voice),$iif($1 isvoice $chan,Девойс,Войс) через сервис):$netget(chanserv.call) $iif($1 isvoice $chan,devoice,voice) $chan $$1
  .-
  .Настройки
  ..Причины:{ runt strings/kick.txt }
}

menu query,nicklist {
  -
  Игнор
  .Полный временный:ignore -pcntikdu999 $address($$1,0)
  .Полный:ignore -pcntikd $address($$1,0)
  .На приваты:ignore -pntd $address($$1,0)
  .На нотисы:ignore -nt $address($$1,0)
  .На CTCP и DCC:ignore -td $address($$1,0)
  .На цвета:ignore -k $address($$1,0)
  Снять игнор:ignore -r $address($$1,0)
  -
  Группы
  .$iif($cnick($1).color != %colors.n.friend,Записать в друзей):{ .cnick -ans3 $1 %colors.n.friend }
  .$iif($cnick($1).color == %colors.n.friend,Удалить из друзей):{ .cnick -r $1 }
  .-
  .$iif($cnick($1).color != %colors.n.enemy,Записать во врагов):{ .cnick -ans3 $1 %colors.n.enemy }
  .$iif($cnick($1).color == %colors.n.enemy,Удалить из врагов):{ .cnick -r $1 }
  -
}

menu status,channel,query,@Сервисы {
  Сервер:
  .$iif($server,Отключиться,Подключиться):$iif($server,quit,server)
  .-
  .$submenu($menulist($1,servers))
  .-
  -
  Я:
  .$style(2) Ник $me $iif($usermode != +,$ifmatch):nill
  .$style(2) $date - $time:clipboard $date - $time
  .$iif($away,Отсутствую):clipboard $awaymsg
  .IP $ip :clipboard $ip
  -
  Файлы
  .$submenu($menulist($1,files))
  .Папка mIRC:run .
  .-
  .Редактировать:runt strings/files.txt
  -
  $iif($script(logview.ini),Поиск в логах) :nill
  -
  Ники (всего $lines(strings/nicks.txt) $+ )
  .$submenu($menulist($1,nick))
  .Руками:$iif(%prefs.mserver.nick,mcom) nick $$?="Новый ник"
  .-
  .Редактировать:runt strings/nicks.txt
  .$iif(!$read(strings/nicks.ini,w,$me),Добавить текущий):{ write strings/nicks.txt $me | if ($lines(strings/nicks.txt) = %files.join.num) { set %files.nick. [ $+ [ %files.nick.num ] ] $chan | inc %files.nick.num } }
  Идентификация
  .$iif((r !isin $usermode) && ($nickget($me,password)),В сервисе ников):$netget(nickserv.call) identify $nickget($me,password)
  .$iif((r !isin $usermode) && ($nickget($me,password)),Регистрация):$netget(nickserv.call) register $nickget($me,password) $userget(pass.email)
  .$iif($nickget($me,password),Сменить/посмотреть,Установить) пароль:nickset $me password
  Away
  .$iif($away,Ушел $duration($awaytime) назад с причиной $+ $chr(58) $left($awaymsg,10) $+ $iif($len($awaymsg) > 10,...)):clipboard $awaymsg
  .$iif($away,$style(2)) Уйти:$iif(%prefs.mserver.away,mcom) away $$?="Причина"
  .$iif($away,$style(2)) Уйти по причине
  ..$submenu($menulist($1,away))
  ..Ушел в $time:$iif(%prefs.mserver.away,mcom) away ушел $fulltime
  .$iif(!$away,$style(2)) Сменить причину:$iif(%prefs.mserver.away,mcom) away $$input(Введите новую причину,ey,Смена причины отсутствия,$awaymsg)
  .$iif(!$away,$style(2)) Сменить причину
  ..$submenu($menulist($1,away))
  .$iif(!$away,$style(2)) Вернуться:$iif(%prefs.mserver.away,mcom) away
  .$iif(!$away,$style(2)) Вернуться тихо:$iif(%prefs.mserver.away,mcom) raw away
  .-
  .Редактировать:runt strings/away.txt
  -
  Каналы
  .$submenu($menulist($1,join))
  .Руками:j $$?="Название канала"
  .Список каналов:list
  .-
  .Редактировать:runt strings/channels.txt
  .$iif($menu == channel,Добавить текущий) :{ write -s $+ $chan strings/channels.txt $chan | if ($lines(strings/channels.txt) = %files.join.num) { set %files.join. [ $+ [ %files.join.num ] ] $chan | inc %files.join.num } }
  $chan
  .$iif($me !ison $chan,Зайти на канал):j $chan
  .$iif($me !isop $chan,Попросить оп):$netget(chanserv.call) op $chan $me
  .$iif($me isop $chan,Убрать оп):$netget(chanserv.call) deop $chan $me
  .Отправить нотис:notice $chan $$?="Сообщение"
  .-
  .Информация:$netget(chanserv.call) info $chan all
  .Настройки
  ..Цвета ( $+ $iif($changet($chan,colors),$ifmatch,2) $+ ):{ chanset $chan colors $$input(Введите настройку цветов: $crlf $+ 1 - всегда $crlf $+ 2 - согласно ограничениям $crlf $+ 3 - никогда,ey,Настройки $chan,$iif($changet($chan,colors),$ifmatch,2)) }
  ..$iif($changet($chan,aways),Включить,Выключить) сообщения об уходе:{ chanset $chan aways $iif($changet($chan,aways),0,1) }
  -
  Выход
  .$submenu($menulist($1,quit))
  .Руками:$iif(%prefs.mserver.quit,mcom) quit $$?="Сообщение выхода"
  .Редактировать:runt strings/quit.txt
  -
}

menu status,channel,nicklist,query {
  $iif($server,Сервисы)
  .Ники
  ..Регистрация:{ var %pass = $input(Введите пароль для $me,ey,Регистрация ника,$nickget($me,password)) | var %mail $input(Введите ваш почтовый адрес,ye,Регистрация ника,$userget(pass.email)) | if (($netget(ns.reg.mail)) && (*@*.* !iswm %mail)) return $input(В данной сети обязательно использование почты,wo,Регистрация ника отменена) | $netget(NickServ.call) register %pass %mail | if ($input(Сохранить для $me пароль %pass $+ ?,yq,Регистарция)) nickset $me password %pass }
  ..$iif($netget(ns.auth),Подтвердить регистрацию):$netget(NickServ.call) auth $$input(Введите код $+ $chr(44) присланный на почту,ey,Подтверждение регистрации)
  ..$iif($netget(ns.auth),Повторить подтверждение):$netget(NickServ.call) sendauth
  ..Идентификация:$netget(NickServ.call) identify $$input(Введите пароль от $me,ey,Идентификация,$nickget($me,password))
  ..$iif($netget(ns.access),Автоидентификация)
  ...Список адресов:$netget(NickServ.call) access list
  ...Добавить адрес:$netget(NickServ.call) access add $input(Введите маску. Используйте * и ? для указания нескольких/одного любого символа,eo,Добавление маски автоидентификации,$ial($me).user $+ @ $+ $host)
  ...Убрать адрес:$netget(NickServ.call) access del $input(Введите маску. Используйте * и ? для указания нескольких/одного любого символа,eo,Добавление маски автоидентификации,$ial($me).user $+ @ $+ $host)
  ..Снять регистрацию:$netget(NickServ.call) drop $iif($netget(ns.drop.pass),$$input(Введите пароль от $me,ey,Сброс ника,$nickget($me,password)))
  ..-
  ..$iif(!$netget(ns.link.pass),Прилинковать):$netget(NickServ.call) link $$input(Введите новый ник для линковки,ey,Связать ник)
  ..$iif($netget(ns.link.pass),Прилинковать):{ var %nick = $$input(Введите ник для линковки,ey,Связать ник) | var %pass = $$input(Введите пароль от ника,ey,Связать ник,$nickget(%nick,password)) | $netget(NickServ.call) link %nick %pass }
  ..$iif($netget(ns.unlink.pass),Отлинковать):{ var %nick = $input(Введите ваш ник для снятия линковки,ey,Разорвать связь ника) | var %pass | if (%nick) %pass = $$input(Введите пароль от ника,ey,Разорвать связь ника,$nickget(%nick,pass)) | $netget(NickServ.call) unlink %nick %pass }
  ..$iif(!$netget(ns.unlink.pass),Отлинковать):$netget(NickServ.call) unlink $$input(Введите ваш ник для снятия линковки,ey,Разорвать связь ника)
  ..Список линковки:$netget(NickServ.call) listlinks
  ..-
  ..Установки
  ...Пароль:{ var %newpass = $$Input(Введите новый пароль,ye,Смена пароля,$nickget($me,password)) | if ($len(%newpass) <= 4) set %newpass $input(Слишком короткий пароль,wo,Пароль не изменен) | $netget(NickServ.call) set password %newpass | if ($input(Сохранить для $me пароль %newpass $+ ?,yq,Смена пароля)) nickset $me password %newpass }
  ...Язык
  ....Список:$netget(NickServ.call) help set language
  ....Сменить:$netget(NickServ.call) $iif(($$input(Введите номер языка,ey,Язык сервисов,1) isnum 1-11),set language $ifmatch)
  ...Сайт:$netget(NickServ.call) set url $$input(Введите адрес сайта,ey,Ваш URL)
  ...Почта:$netget(NickServ.call) set email $$input(Введите почтовый адрес,ye,Ваш e-mail)
  ...$iif($netget(ns.set.info),Информация):$netget(NickServ.call) set info $$input(Введите текст,ey,Информация о вас)
  ...$iif($netget(ns.set.icqnumber),Номер ICQ):$netget(NickServ.call) set icqnumber $$input(Введите номер ICQ,ey,Номер ICQ)
  ...$iif($netget(ns.set.location),Местоположение):$netget(NickServ.call) set location $$input(Введите местоположение,ey,Информация о местоположении)
  ...Убийство ника
  ....Включить (60 сек):$netget(NickServ.call) set kill on
  ....Ускоренная (20 сек):$netget(NickServ.call) set kill quick
  ....Мгновенная:$netget(NickServ.call) set kill immed
  ....Выключить:$netget(NickServ.call) set kill off
  ...$iif($netget(ns.set.secure),Защита)
  ....Включить:$netget(NickServ.call) set secure on
  ....Выключить:$netget(NickServ.call) set secure off
  ...Приватный
  ....Включить:$netget(NickServ.call) set private on
  ....Выключить:$netget(NickServ.call) set private off
  ...Скрыть
  ....Почту скрывать:$netget(NickServ.call) set hide email on
  ....Почту не скрывать:$netget(NickServ.call) set hide email off
  ....$iif($netget(ns.set.hide.usermask),Маску скрывать):$netget(NickServ.call) set hide usermask on
  ....$iif($netget(ns.set.hide.usermask),Маску не скрывать):$netget(NickServ.call) set hide usermask off
  ....Выход скрывать:$netget(NickServ.call) set hide quit on
  ....Выход не скрывать:$netget(NickServ.call) set hide quit off
  ...$iif($netget(ns.set.timezone),Часовой пояс):$netget(NickServ.call) set timezone $$input(Часовой пояс в формате $crlf +H -H (+3 Московское) $crlf +H:mm (+3:00 Московское) $crlf XXX (GMT по Гринвичу),eqo,Установите часовой пояс,+3)
  ...$iif($netget(ns.set.mainnick),Основной ник):$netget(NickServ.call) set mainnick $$input(Введите основной ник,eqo,Установка основного ника,$me)
  ...-
  ...$iif($netget(ns.unset),Убрать)
  ....Сайт:$netget(NickServ.call) unset url
  ....Информацию:$netget(NickServ.call) unset info
  ..$iif($netget(ns.ajoin),Автозаход)
  ...Добавить канал:$netget(NickServ.call) ajoin add $$input(Введите название канала,eqo,Добавление в список автозахода,$chan)
  ...Убрать канал:$netget(NickServ.call) ajoin del $$input(Введите название канала,eqo,Убрать из списка автозахода,$chan)
  ...Список:$netget(NickServ.call) ajoin list
  ...Сейчас:$netget(NickServ.call) ajoin now
  ..-
  ..Защита ника
  ...Перехватить ник:{ var %nick = $$input(Введите ник,ey,Перехват ника,$gettok($snicks,1,44)) | var %pass = $$input(Пароль от %nick,ey,Перехват ника,$nickget(%nick,password)) | $netget(NickServ.call) recover %nick %pass }
  ...Освободить ник:{ var %nick = $$input(Введите ник,ey,Освобождение ника) | var %pass = $$input(Пароль от %nick,ey,Освобождение ника,$nickget(%nick,password)) | $netget(NickServ.call) release %nick %pass }
  ...Призрак:{ var %nick = $$input(Введите ник,ey,Ghost,$gettok($snicks,1,44)) | var %pass = $$input(Пароль от %nick,ey,Ghost,$nickget(%nick,password)) | $netget(NickServ.call) ghost %nick %pass }
  ..-
  ..Информация:$netget(NickServ.call) info $$input(Введите ник,ey,Информация о пользователе,$iif($chan,$gettok($snicks,1,44),$active)) $iif($input(Полная информация?,qy,Вопрос),all)
  ..Список посетителей:$netget(NickServ.call) list $$input(Введите маску поиска,ey,Поиск пользователей,*@*)
  ..$iif($netget(ns.listemail),Список e-mail):$netget(NickServ.call) listemail $$input(Введите маску поиска,ey,Поиск адресов почты,*@*)
  ..$iif($netget(ns.listchans),Список каналов):$netget(NickServ.call) listchans
  ..Статус ников:$netget(NickServ.call) status $$input(Введите список ников (до 16) $crlf $+ 0 - нету $crlf $+ 1 - не идентифицирован $crlf $+ 2 - идентифицирован по адресу $crlf $+ 3 - идентифицирован по паролю,ey,Проверка ников,$snicks)
  ..-
  ..$iif($netget(ns.help.simple),Помощь,Список команд):$netget(NickServ.call) help
  ..$iif($netget(ns.help.simple),Список команд):$netget(NickServ.call) help commands
  ..Подробный:$netget(NickServ.call) help $$input(Введите команду $+ $chr(44) по которой требуется помощь,ey,Помощь по сервису)
  .Каналы
  ..Регистрация:{ var %chan = $$input(Введите название канала,ey,Регистрация канала,$chan) | var %pass = $$input(Введите пароль от %chan,ey,Регистрация канала,$changet(%chan,password)) | $netget(ChanServ.call) register %chan %pass $$input(Введите описание канала,ey,Регистрация канала) | chanset %chan password %pass }
  ..Идентификация:{ var %chan = $$input(Введите название канала,ey,Идентификация на канале,$chan) | var %pass = $$input(Введите пароль от %chan,ey,Идентификация на канале,$changet(%chan,password)) | $netget(ChanServ.call) identify %chan %pass }
  ..Сброс:{ var %chan = $$input(Введите название канала,ey,Сброс канала,$chan) | $netget(ChanServ.call) drop %chan }
  ..Установки
  ...Владелец:{ var %chan = $$input(Введите название канала,ey,Установка владельца,$chan) | var %nick = $$input(Введите ник владельца,ey,Установка владельца,$gettok($snicks,1,44)) | $netget(ChanServ.call) set %chan founder %nick }
  ...Преемник:{ var %chan = $$input(Введите название канала,ey,Установка преемника,$chan) | var %nick = $$input(Введите ник преемника,ey,Установка преемника,$gettok($snicks,1,44)) | $netget(ChanServ.call) set %chan successor %nick }
  ...Пароль:{ var %chan = $$input(Введите название канала,ey,Установка пароля,$chan) | var %pass = $$input(Введите пароль для %chan,ey,Установка пароля,$changet(%chan,password)) | $netget(ChanServ.call) set %chan password %pass | chanset %chan password %pass }
  ...Описание:{ var %chan = $$input(Введите название канала,ey,Описание канала,$chan) | var %desc = $$input(Введите описание канала,ey,Описание канала) | $netget(ChanServ.call) set %chan desc %desc }
  ...Страничка:{ var %chan = $$input(Введите название канала,ey,Страничка канала,$chan) | var %url = $$input(Введите страницу канала,ey,Страничка канала) | $netget(ChanServ.call) set %chan url %url }
  ...Почта:{ var %chan = $$input(Введите название канала,ey,Установка почты,$chan) | var %mail = $$input(Введите почтовый адрес,ey,Установка почты,) | $netget(ChanServ.call) set %chan email %mail }
  ...Приветствие:{ var %chan = $$input(Введите название канала,ey,Установка приветствия,$chan) | var %msg = $$input(Введите приветствие,ey,Установка приветствия,) | $netget(ChanServ.call) set %chan entrymsg %msg }
  ...$iif($netget(cs.set.topic),Топик):{ var %chan = $$input(Введите название канала,ey,Установка топика,$chan) | var %text = $$input(Введите топик,ey,Установка топика,$chan(#).topic) | $netget(ChanServ.call) set %chan topic %text }
  ...Хранение топика:{ var %chan = $$input(Введите название канала,ey,Хранение топика,$chan) | var %mode = $$input(Введите ON/OFF,ey,Хранение топика,off) | $netget(ChanServ.call) set %chan keeptopic %mode }
  ...Защита топика:{ var %chan = $$input(Введите название канала,ey,Защита топика,$chan) | var %mode = $$input(Введите ON/OFF,ey,Защита топика,OFF) | $netget(ChanServ.call) set %chan topiclock %mode }
  ...Защита режимов:{ var %chan = $$input(Введите название канала,ey,Защита режимов,$chan) | var %mode = $$input(Введите защищенные флаги,ey,Защита режимов,+nt) | $netget(ChanServ.call) set %chan mlock %mode }
  ...Приватность:{ var %chan = $$input(Введите название канала,ey,Приватный канал,$chan) | var %mode = $$input(Введите ON/OFF,ey,Приватный канал,OFF) | $netget(ChanServ.call) set %chan private %mode }
  ...Ограничение:{ var %chan = $$input(Введите название канала,ey,Ограниченный канал,$chan) | var %mode = $$input(Введите ON/OFF,ey,Ограниченный канал,OFF) | $netget(ChanServ.call) set %chan RESTRICTED %mode }
  ...$iif($netget(cs.set.secure),Охрана):{ var %chan = $$input(Введите название канала,ey,Охраняемый канал,$chan) | var %mode = $$input(Введите ON/OFF,ey,Охраняемый канал,OFF) | $netget(ChanServ.call) set %chan secure %mode }
  ...Охрана операторов:{ var %chan = $$input(Введите название канала,ey,Охрана операторов,$chan) | var %mode = $$input(Введите ON/OFF,ey,Охрана операторов,OFF) | $netget(ChanServ.call) set %chan secureops %mode }
  ...Последние операторы:{ var %chan = $$input(Введите название канала,ey,Оставшиеся операторы,$chan) | var %mode = $$input(Введите ON/OFF,ey,Оставшиеся операторы,OFF) | $netget(ChanServ.call) set %chan leaveops %mode }
  ...Нотисы операторам:{ var %chan = $$input(Введите название канала,ey,Операторские нотисы,$chan) | var %mode = $$input(Введите ON/OFF,ey,Операторские нотисы,OFF) | $netget(ChanServ.call) set %chan opnotice %mode }
  ...$iif($netget(cs.set.enforce),Закрепить статусы):{ var %chan = $$input(Введите название канала,ey,Закреплить статусы,$chan) | var %mode = $$input(Введите ON/OFF,ey,Закреплить статусы,OFF) | $netget(ChanServ.call) set %chan enforce %mode }
  ...$iif($netget(cs.set.nolinks),Запретить связи):{ var %chan = $$input(Введите название канала,ey,Запретить связи,$chan) | var %mode = $$input(Введите ON/OFF,ey,Запретить связи,OFF) | $netget(ChanServ.call) set %chan nolinks %mode }
  ...-
  ...$iif($netget(cs.unset),Убрать)
  ....Преемника:{ var %chan = $$input(Введите название канала,ey,Убрать преемника,$chan) | $netget(ChanServ.call) unset %chan successor }
  ....Сайт:{ var %chan = $$input(Введите название канала,ey,Убрать сайт,$chan) | $netget(ChanServ.call) unset %chan url }
  ....Почту:{ var %chan = $$input(Введите название канала,ey,Убрать почту,$chan) | $netget(ChanServ.call) unset %chan email }
  ....Приветствие:{ var %chan = $$input(Введите название канала,ey,Убрать приветствие,$chan) | $netget(ChanServ.call) unset %chan entrymsg }
  ..$iif($netget(cs.topic),Топик):{ var %chan = $$input(Введите название канала,ey,Смена топика,$chan) | var %text = $$input(Введите новый топик,ey,Смена топика,$chan(%chan).topic) | $netget(ChanServ.call) topic %chan %text }
  ..Доступ
  ...Добавить:{ var %chan = $$input(Введите название канала,ey,Добавление записи доступа,$chan) | var %nick = $input(Введите добавляемый ник,ey,Добавление записи доступа,$gettok($snicks,1,44)) | var %level = $$input(Введите уровень доступа,ey,Добавление записи доступа,30) | $netget(ChanServ.call) access %chan add %nick %level }
  ...Убрать:{ var %chan = $$input(Введите название канала,ey,Удаление записи доступа,$chan) | var %nick = $input(Введите удаляемые ники/номера позиций,ey,Удаление записи доступа,$snicks) | $netget(ChanServ.call) access %chan del %nick } 
  ...Список:{ var %chan = $$input(Введите название канала,ey,Просмотр списка доступа,$chan) | var %mask = $input(Введите маску вывода/список позиций,ey,Просмотр списка доступа) | $netget(ChanServ.call) access %chan list %mask }
  ...$iif($netget(cs.access.count),Количество):{ var %chan = $$input(Введите название канала,ey,Просмотр количества записей,$chan) | $netget(ChanServ.call) access %chan count }
  ..$iif($netget(cs.aop),AOP)
  ...Добавить:{ var %chan = $$input(Введите название канала,ey,Добавление в список AOP,$chan) | var %nick = $input(Введите добавляемый ник,ey,Добавление в список AOP,$gettok($snicks,1,44)) | $netget(ChanServ.call) aop %chan add %nick }
  ...Список:{ var %chan = $$input(Введите название канала,ey,Cписок AOP,$chan) | $netget(ChanServ.call) aop %chan list }
  ..$iif($netget(cs.sop),SOP)
  ...Добавить:{ var %chan = $$input(Введите название канала,ey,Добавление в список SOP,$chan) | var %nick = $input(Введите добавляемый ник,ey,Добавление в список SOP,$gettok($snicks,1,44)) | $netget(ChanServ.call) sop %chan add %nick }
  ...Список:{ var %chan = $$input(Введите название канала,ey,Cписок SOP,$chan) | $netget(ChanServ.call) sop %chan list }
  ..Уровни
  ...Описание:$netget(ChanServ.call) HELP LEVELS DESC
  ...Установить:{ var %chan = $$input(Введите название канала,ey,Установка уровня доступа,$chan) | var %name = $input(Введите изменяемый уровень,ey,Установка уровня доступа) | var %level = $$input(Введите уровень доступа,ey,Установка уровня доступа,30) | $netget(ChanServ.call) LEVELS %chan set %name %level }
  ...Отключить:{ var %chan = $$input(Введите название канала,ey,Отключение уровня доступа,$chan) | var %name = $input(Введите отключаемый уровень,ey,Отключение уровня доступа) | $netget(ChanServ.call) LEVELS %chan disable %name }
  ...Список:{ var %chan = $$input(Введите название канала,ey,Просмотр уровней доступа,$chan) | $netget(ChanServ.call) LEVELS %chan list }
  ...Сбросить:{ var %chan = $$input(Введите название канала,ey,Сброс уровней доступа,$chan) | $netget(ChanServ.call) LEVELS %chan reset }
  ..$iif($netget(cs.status),Статус):{ var %chan = $$input(Введите название канала,ey,Просмотр статуса,$chan) | var %nick = $input(Введите ник,ey,Просмотр статуса,$gettok($snicks,1,44)) | $netget(ChanServ.call) status %chan %nick }
  ..-
  ..Смена статусов
  ...Op:{ var %chan = $$input(Введите название канала,ey,Статус оператора,$chan) | var %nick = $input(Введите ник,ey,Статус оператора,$gettok($snicks,1,44)) | $netget(ChanServ.call) op %chan %nick }
  ...Deop:{ var %chan = $$input(Введите название канала,ey,Снять статус оператора,$chan) | var %nick = $input(Введите ник,ey,Снять статус оператора,$gettok($snicks,1,44)) | $netget(ChanServ.call) deop %chan %nick }
  ...$iif($netget(cs.voice),Voice):{ var %chan = $$input(Введите название канала,ey,Статус права голоса,$chan) | var %nick = $input(Введите ник,ey,Статус права голоса,$gettok($snicks,1,44)) | $netget(ChanServ.call) voice %chan %nick }
  ...$iif($netget(cs.voice),Devoice):{ var %chan = $$input(Введите название канала,ey,Снять статус права голоса,$chan) | var %nick = $input(Введите ник,ey,Снять статус права голоса,$gettok($snicks,1,44)) | $netget(ChanServ.call) devoice %chan %nick }
  ...$iif($netget(cs.halfop),Halfop):{ var %chan = $$input(Введите название канала,ey,Статус помошника оператора,$chan) | var %nick = $input(Введите ник,ey,Статус помошника оператора,$gettok($snicks,1,44)) | $netget(ChanServ.call) halfop %chan %nick }
  ...$iif($netget(cs.halfop),Dehalfop):{ var %chan = $$input(Введите название канала,ey,Снять статус помошника оператора,$chan) | var %nick = $input(Введите ник,ey,Снять статус помошника оператора,$gettok($snicks,1,44)) | $netget(ChanServ.call) dehalfop %chan %nick }
  ...$iif($netget(cs.protect),Protect):{ var %chan = $$input(Введите название канала,ey,Статус защищенного,$chan) | var %nick = $input(Введите ник,ey,Статус защищенного,$gettok($snicks,1,44)) | $netget(ChanServ.call) protect %chan %nick }
  ...$iif($netget(cs.protect),Deprotect):{ var %chan = $$input(Введите название канала,ey,Снять статус защищенного,$chan) | var %nick = $input(Введите ник,ey,Снять статус защищенного,$gettok($snicks,1,44)) | $netget(ChanServ.call) deprotect %chan %nick }
  ..$iif($netget(cs.kick),Выбросить):{ var %chan = $$input(Введите название канала,ey,Выбросить с канала,$chan) | var %nick = $$input(Введите ник,ey,Выбросить с канала,$gettok($snicks,1,44)) | var %reas = $input(Введите причину,ey,Выбросить с канала) | $netget(ChanServ.call) kick %chan %nick %reas }
  ..Автовыброс
  ...Добавить:{ var %chan = $$input(Введите название канала,ey,Автовыброс,$chan) | var %mask = $$input(Введите маску выброса,ey,Автовыброс,$gettok($snicks,1,44) $+ !*@*) | var %reas = $input(Введите причину,ey,Автовыброс) | $netget(ChanServ.call) akick %chan add %mask %reas }
  ...Удалить:{ var %chan = $$input(Введите название канала,ey,Автовыброс,$chan) | var %mask = $$input(Введите маску выброса $crlf $+ ALL удалит все маски,ey,Автовыброс,$gettok($snicks,1,44) $+ !*@*) | $netget(ChanServ.call) akick %chan del %mask }
  ...Список:{ var %chan = $$input(Введите название канала,ey,Автовыброс,$chan) | var %mask = $input(Введите маску выброса/список позиций,ey,Автовыброс) | $netget(ChanServ.call) akick %chan list %mask }
  ...$iif($netget(cs.akick.add),Посмотреть):{ var %chan = $$input(Введите название канала,ey,Автовыброс посмотреть,$chan) | var %mask = $input(Введите маску выброса/список позиций,ey,Автовыброс) | $netget(ChanServ.call) akick %chan view }
  ...$iif($netget(cs.akick.add),Сейчас):{ var %chan = $$input(Введите название канала,ey,Автовыброс сейчас,$chan) | $netget(ChanServ.call) akick %chan enforce }
  ...$iif($netget(cs.akick.add),Посчитать):{ var %chan = $$input(Введите название канала,ey,Автовыброс - посчитать,$chan) | $netget(ChanServ.call) akick %chan count }
  ..Очистить
  ...Режимы:{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan modes }
  ...Баны:{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan bans }
  ...$iif($netget(cs.clear.exceptions),Исключения):{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan exceptions }
  ...$iif($netget(cs.clear.invite),Приглашения):{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan invites }
  ...Операторы:{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan ops }
  ...$iif($netget(cs.clear.halfops),Помошники):{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan halfops }
  ...Голоса:{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan voices }
  ...Посетители:{ var %chan = $$input(Введите название канала,ey,Очистка канала,$chan) | $netget(ChanServ.call) clear %chan users }
  ..-
  ..Пригласиться:{ var %chan = $$input(Введите название канала,ey,Пригласиться,$chan) | $netget(ChanServ.call) invite %chan }
  ..Разбаниться:{ var %chan = $$input(Введите название канала,ey,Разбаниться,$chan) | $netget(ChanServ.call) unban %chan }
  ..-
  ..Список:{ var %mask = $$input(Введите маску вывода,ey,Список каналов,$chan) | $netget(ChanServ.call) list %mask }
  ..Информация:{ var %chan = $$input(Введите название канала,ey,Просмотр информации,$chan) | $netget(ChanServ.call) info %chan $iif($netget(cs.info.all),$iif($input(Полная информация?,yq,Просмотр информации),all)) }
  ..-
  ..$iif($netget(cs.help.simple),Помощь,Список команд):$netget(ChanServ.call) help
  ..$iif($netget(cs.help.simple),Список команд):$netget(ChanServ.call) help commands
  ..Подробный:$netget(ChanServ.call) help $$input(Введите команду $+ $chr(44) по которой требуется помощь,ey,Помощь по сервису)
  .Мемо
  ..Послать:$netget(MemoServ.call) send $$input(Введите ник или канал,ey,Получатель,$active) $$input(Введите сообщение,ey,Текст)
  ..Список
  ...Своих:$netget(MemoServ.call) list $input(Введите номера выводимых сообщений $crlf $+ NEW выведет только новые сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Список сообщений,NEW)
  ...Канала:$netget(MemoServ.call) list $$input(Введите название канала,ey,Сообщения канала,$chan) $input(Введите номера выводимых сообщений $crlf $+ NEW выведет только новые сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Список сообщений,NEW)
  ..Прочитать
  ...Своих:$netget(MemoServ.call) read $input(Введите номера выводимых сообщений $crlf $+ LAST выведет последнее сообщение $crlf $+ NEW выведет все новые сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Прочитать сообщения,LAST)
  ...Канала:$netget(MemoServ.call) read $$input(Введите название канала,ey,Сообщения канала,$chan) $input(Введите номера выводимых сообщений $crlf $+ LAST выведет последнее сообщение $crlf $+ NEW выведет все новые сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Прочитать сообщения,LAST)
  ..$iif($netget(ms.forward),Переслать):$netget(MemoServ.call) forward $input(Введите номера пересылаемых сообщений $crlf $+ ALL перешлет все ваши сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 вышлет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Переслать сообщения,ALL)
  ..$iif($netget(ms.save),Сохранить)
  ...Свои:$netget(MemoServ.call) save $input(Введите номера сохраняемых сообщений $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Сохранить сообщения,1)
  ...Канала:$netget(MemoServ.call) save $$input(Введите название канала,ey,Сообщения канала,$chan) $input(Введите номера сохраняемых сообщений $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Сохранить сообщения,1)
  ..Удалить
  ...Свои:$netget(MemoServ.call) del $input(Введите номера удаляемых сообщений $crlf $+ ALL удалит все сообщения $crlf $+ 2-5 $+ $chr(44) $+ 7-9 удалит сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Удалить сообщения,1)
  ...Канала:$netget(MemoServ.call) del $$input(Введите название канала,ey,Сообщения канала,$chan) $input(Введите номера сохраняемых сообщений $crlf $+ 2-5 $+ $chr(44) $+ 7-9 выведет сообщения под номерами 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,Удалить сообщения,1)
  ..Установить
  ...Уведомления
  ....Включить:$netget(MemoServ.call) set notify on
  ....При входе:$netget(MemoServ.call) set notify logon
  ....Новые:$netget(MemoServ.call) set notify new
  ....Выключить:$netget(MemoServ.call) set notify off
  ...Лимит
  ....Свои:$netget(MemoServ.call) set limit $input(Максимальное количество разрешенных сообщений в интервале 0-20,ey,Установка лимита сообщений,20)
  ....Канала:$netget(MemoServ.call) set limit $$input(Введите название канала,ey,Название канала,$chan) $input(Максимальное количество разрешенных сообщений в интервале 0-20,ey,Установка лимита сообщений,20)
  ...$iif($netget(ms.set.forward),Рассылка)
  ....Полная:$netget(MemoServ.call) set forward on
  ....Копия:$netget(MemoServ.call) set forward copy
  ....Выключена:$netget(MemoServ.call) set forward off
  ..$iif($netget(ms.info),Информация):$netget(MemoServ.call) info $input(Введите назкание канала. $crlf $+ Или оставьте строку пустой для просмотра личной информации.,ye,Название канала,$chan)
  ..$iif($netget(ms.ignore),Игнорировать)
  ...Добавить:$netget(MemoServ.call) ignore add $$input(Введите ник/маску для игнорирования,ey,Список игнорирования)
  ...Удалить:$netget(MemoServ.call) ignore del $$input(Введите ник/маску для прекращения игнорирования,ey,Список игнорирования)
  ...Список:$netget(MemoServ.call) ignore list
  ..-
  ..$iif($netget(ms.help.simple),Помощь,Список команд):$netget(MemoServ.call) help
  ..$iif($netget(ms.help.simple),Список команд):$netget(MemoServ.call) help commands
  ..Подробный:$netget(MemoServ.call) help $$input(Введите команду $+ $chr(44) по которой требуется помощь,ey,Помощь по сервису)
  -
}

alias menulist {
  if ($1 == begin) return -
  if ($1 == end) return -
  var %file, %str, %read
  if ($istok(nick,$2,32)) { 
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] : $iif(%prefs.mserver.nick,mcom) $2 %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] 
  }
  if ($istok(join,$2,32)) {
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] : $2 %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] 
  }
  if ($istok(ctcp,$2,32)) {
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] : $2 $iif($snick($chan,1),$ifmatch,$active) %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] 
  }
  if ($istok(away,$2,32)) { 
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - $left(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ],%nums.menulist.len) $+ $iif($len(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ]) > %nums.menulist.len, ...) : $iif(%prefs.mserver.away,mcom) $2 [ %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] ]
  }
  if ($istok(quit,$2,32)) { 
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - $left(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ],%nums.menulist.len) $+ $iif($len(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ]) > %nums.menulist.len, ...) : $iif(%prefs.mserver.quit,mcom) $2 [ %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] ]
  }
  if ($2 == invite) {
    if ($1 > $chan(0)) halt
    return $iif($snick($chan,1) ison $chan($1),$style(2)) - $+ $1 $+ - $chan($1) : $2 $snick($chan,1) $chan($1)
  }
  if ($2 == files) {
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    var %string = %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ]
    var %name = $gettok(%string,1,32), %file
    if ($gettok(%string,2-,32)) %file = $ifmatch | else %file = %name
    ;return - $+ $1 $+ - %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] : runt %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] 
    return - $+ $1 $+ - %name : runt " $+ %file $+ "
  }
  if ($2 == kick) { 
    if ($1 >= %files. [ $+ [ $2 ] $+ ] .num) halt 
    return - $+ $1 $+ - $left(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ],%nums.menulist.len) $+ $iif($len(%files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ]) > %nums.menulist.len, ...) : $2 $chan $snick($chan,1) [ %files. [ $+ [ $2 ] $+ ] . [ $+ [ $1 ] ] ]
  }
  if ($2 == cskick) { 
    if ($1 >= %files.kick.num) halt 
    return - $+ $1 $+ - $left(%files.kick. [ $+ [ $1 ] ],%nums.menulist.len) $+ $iif($len(%files.kick. [ $+ [ $1 ] ]) > %nums.menulist.len, ...) : $netget(chanserv.call) kick $chan $snick($chan,1) [ %files.kick. [ $+ [ $1 ] ] ]
  }
  if ($2 == bankick) { 
    if ($1 >= %files.kick.num) halt 
    return - $+ $1 $+ - $left(%files.kick. [ $+ [ $1 ] ],%nums.menulist.len) $+ $iif($len(%files.kick. [ $+ [ $1 ] ]) > %nums.menulist.len, ...) : { mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* $chr(124) kick $chan $snick($chan,1) [ %files.kick. [ $+ [ $1 ] ] ] }
  }
  if ($2 == servers) {
    if ($1 <= $server(0)) {
      return - $+ $1 $+ - $server($1).group - $server($1).desc : server -m $server($1) $server($1).port $server($1).pass
    }
  }
}
