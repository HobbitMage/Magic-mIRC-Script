on *:start:proc.start
on *:connect:proc.connect
on *:disconnect:proc.disconnect
on *:exit:proc.exit

dialog user_menu {
  title "Меню пользователя"
  size 20 65 86 146
  option dbu
  icon grafix/user_menu.ico, 0
  button "Закрыть", 1, 3 132 80 12, default ok
  button "Справка", 2, 3 120 80 12
  box "", 3, 1 -2 84 55
  button "Настройки пользователя", 4, 3 3 80 12, default
  button "Настройки обращения", 5, 3 15 80 12
  button "Настройки ухода", 6, 3 27 80 12
  button "Сообщения ухода", 7, 3 39 80 12
  box "", 8, 1 49 84 43
  button "Информация о скрипте", 9, 3 54 80 12
  button "Настройки скрипта", 10, 3 66 80 12
  button "Многосерверность", 11, 3 78 80 12
  box "", 27, 1 88 84 31
  button "Загрузить настройки", 25, 3 93 80 12
  button "Сохранить настройки", 26, 3 105 80 12
}

on *:dialog:PMenu:*:*:{
  if ($devent == sclick) {
    if ($did == 2) { help.show prefs | return }
    if ($did == 4) { 
      if ($dialog(PUser)) dialog -vs PUser $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(PUser).cw $dialog(PUser).ch
      else dialog -m PUser prefs_user 
      return
    }
    if ($did == 5) { 
      if ($dialog(Pnickins)) dialog -vs Pnickins $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(Pnickins).cw $dialog(Pnickins).ch
      else dialog -m Pnickins prefs_nickins
      return
    }
    if ($did == 6) { 
      if ($dialog(Paway)) dialog -vs Paway $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(Paway).cw $dialog(Paway).ch
      else dialog -m Paway prefs_away
      return
    }
    if ($did == 7) { 
      if ($dialog(Pawaymes)) dialog -vs Pawaymes $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(Pawaymes).cw $dialog(Pawaymes).ch
      else dialog -m Pawaymes prefs_awaymes
      return
    }
    if ($did == 9) { 
      if ($dialog(sinfo)) dialog -vs sinfo $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(sinfo).cw $dialog(sinfo).ch
      else dialog -m sinfo prefs_sinfo
      return
    }
    if ($did == 10) { 
      if ($dialog(Pscript)) dialog -vs Pscript $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(Pscript).cw $dialog(Pscript).ch
      else dialog -m Pscript prefs_script
      return
    }
    if ($did == 11) { 
      if ($dialog(Pmserver)) dialog -vs Pmserver $calc($dialog(PMenu).x + $dialog(PMenu).w) $dialog(PMenu).y $dialog(Pmserver).cw $dialog(Pmserver).ch
      else dialog -m Pmserver prefs_mserver
      return
    }
    if ($did == 25) { 
      if ($dialog(puser)) dialog -x puser 
      if ($dialog(pnickins)) dialog -x pnickins
      if ($dialog(paway)) dialog -x paway
      if ($dialog(pawaymes)) dialog -x pawaymes
      if ($dialog(sinfo)) dialog -x sinfo
      if ($dialog(Pscript)) dialog -x Pscript
      if ($dialog(Pmserver)) dialog -x Pmserver
      proc.load
    }
    if ($did == 26) { if ($input(Не сохраняйте $+ $chr(44) если у вас появляются ошибки,qy,Сохранить все переменные?)) proc.save }
  }
}

dialog prefs_user {
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 82
  option dbu
  icon grafix\prefs_user.ico, 0
  text "Основной ник", 12, 3 4 60 8
  text "Альтернативный ник", 13, 3 15 60 8
  text "Почтовый адрес", 14, 3 26 60 8
  edit "", 4, 64 3 83 10
  edit "", 5, 64 14 83 10
  edit "", 6, 64 25 83 10, autohs
  box "Пол", 7, 3 38 144 30
  radio "Мужской", 8, 7 46 60 10
  radio "Женский", 9, 7 56 60 10
  radio "Неопределенный", 10, 77 46 60 10
  radio "Множественный", 11, 77 56 60 10
  button "Применить", 1, 3 69 48 12, disable
  button "Справка", 2, 51 69 48 12
  button "Закрыть", 3, 99 69 48 12, ok
}

on *:dialog:PUser:*:*:{
  if ($devent == init) {
    did -a PUser 4 $userget(nick)
    did -a PUser 5 $userget(anick)
    did -a PUser 6 $userget(pass.email)
    if (%sex == m) { did -c PUser 8 | return }
    if (%sex == f) { did -c PUser 9 | return }
    if (%sex == u) { did -c PUser 10 | return }
    if (%sex == n) { did -c PUser 11 | return }
    did -c PUser 8 | did -e puser 12 
  }
  if ($devent == edit) {
    did -e puser 1
  }
  if ($devent == sclick) {
    if ($did == 2) {
      help.show userprefs
      return
    }
    if ($did == 1) { 
      userset nick $did(4)
      userset anick $did(5)
      userset pass.email $did(6)
      if ($did(8).state) userset sex m
      if ($did(9).state) userset sex f
      if ($did(10).state) userset sex u
      if ($did(11).state) userset sex n
      did -b puser 1
      return
    }
    if ($istok(8 9 10 11,$did,32)) did -e puser 1
  }
}

dialog prefs_nickins {
  title "Настройки обращения"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 93
  option dbu
  icon grafix\prefs_nickins.ico, 0
  button "Применить", 1, 39 80 36 12, disable
  button "Справка", 2, 75 80 36 12
  button "Закрыть", 3, 111 80 36 12, ok
  box "Способ обращения при пустой/заполненной строке", 4, 1 1 148 58
  edit "", 5, 2 60 146 10
  edit "", 6, 2 69 146 10, read
  radio "Приват/Обращение", 7, 3 8 65 10
  radio "Подстановка/Обращение", 8, 71 8 77 10
  radio "Подстановка/Приват", 9, 3 17 65 10
  radio "Приват/Подстановка", 10, 71 17 77 10
  text "Приват - Открыть приват с выбранным ником.", 11, 3 27 144 8
  text "Подстановка - В строке ввода текст изменяется, но не отправляется", 12, 3 43 144 13
  text "Обращение - Отправляется строка обращения", 13, 3 35 144 8
  button "Стандартная", 14, 2 80 37 12
}

on *:dialog:Pnickins:*:*:{
  if ($devent == init) {
    did -a Pnickins 5 %str.nickins
    var %nick = $me, %mes = строка ввода
    did -a Pnickins 6 [ [ %str.nickins ] ]
    if (%prefs.nickinsert.type !isnum 1-4) { %prefs.nickinsert.type = 1 | did -e Pnickins 1 }
    did -c Pnickins $calc(6 + %prefs.nickinsert.type) 
  }
  if ($devent == edit) {
    did -e Pnickins 1
  }
  if ($devent == sclick) {
    if ($did == 2) {
      help.show nickinsert
      return
    }
    if ($did == 1) {
      %str.nickins = $did(5)
      if ($did(7).state) %prefs.nickinsert.type = 1
      if ($did(8).state) %prefs.nickinsert.type = 2
      if ($did(9).state) %prefs.nickinsert.type = 3
      if ($did(10).state) %prefs.nickinsert.type = 4
      did -b pnickins 1
      return
    }
    if ($istok(7 8 9 10,$did,32)) { did -e Pnickins 1 | return }
    if ($did == 14) { did -o pnickins 5 1 $stdget(str.nickins) | did -e Pnickins 1 | return }
  }
}

dialog prefs_away {
  title "Настройки ухода"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 92
  option dbu
  icon grafix\prefs_away.ico, 0
  button "Применить", 1, 3 79 48 12, disable
  button "Справка", 2, 51 79 48 12
  button "Закрыть", 3, 99 79 48 12, ok
  box "Смена ника", 4, 1 0 47 67
  radio "Не менять", 5, 4 8 40 10, group
  radio "Весь ник", 6, 4 18 40 10
  radio "Приставка", 7, 4 28 40 10
  radio "Окончание", 8, 4 38 40 10
  radio "Приставка и окончание", 9, 4 48 40 10
  text "Ник", 11, 50 4 25 8
  text "Приставка", 12, 50 25 38 8
  text "окончание", 10, 14 57 41 8
  text "Окончание", 13, 50 46 39 8
  text "Результат", 14, 2 69 27 8
  box "", 15, 48 0 101 67
  edit "", 16, 50 13 97 10
  edit "", 17, 50 34 97 10
  edit "", 18, 50 55 97 10
  edit "", 19, 29 68 120 10, disable
}

alias dialog.paway.create {
  if ($did(5).state) return $me
  if ($did(6).state) return  $did(16)
  if ($did(7).state) return  $did(17) $+ $me
  if ($did(8).state) return  $me $+ $did(18)
  if ($did(9).state) return  $did(17) $+ $me $+ $did(18)
}
on *:dialog:Paway:*:*:{
  if ($devent == init) {
    did -c paway $calc(5 + %prefs.away.nickmode)
    did -a paway 16 %str.away.nick
    did -a paway 17 %str.away.pre
    did -a paway 18 %str.away.end
    did -o paway 19 1 $dialog.paway.create
    return
  }
  if ($devent == edit) {
    did -e Paway 1
    did -o paway 19 1 $dialog.paway.create
    return
  }
  if ($devent == sclick) {
    if ($did == 2) {
      help.show maway
      return
    }
    if ($did == 1) {
      did -b Paway 1
      %str.away.nick = $did(16)
      %str.away.pre = $did(17)
      %str.away.end = $did(18)
      if ($did(5).state) %prefs.away.nickmode = 0
      if ($did(6).state) %prefs.away.nickmode = 1
      if ($did(7).state) %prefs.away.nickmode = 2
      if ($did(8).state) %prefs.away.nickmode = 3
      if ($did(9).state) %prefs.away.nickmode = 4
      return
    }
    if ($istok(5 6 7 8 9,$did,32)) { did -e Paway 1 | did -o paway 19 1 $dialog.paway.create | return }
  }
}

dialog prefs_awaymes {
  title "Сообщения ухода"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 146
  option dbu
  icon grafix\prefs_awaymes.ico, 0
  button "Применить", 1, 3 133 48 12, disable
  button "Справка", 2, 51 133 48 12
  button "Закрыть", 3, 99 133 48 12, ok
  box "Настройки", 4, 1 0 148 37
  check "Включены", 5, 3 6 50 10
  check "Промежуточные", 6, 3 16 53 10, disable
  radio "Сообщения", 7, 96 6 50 10, disable left
  radio "Действия", 8, 96 16 50 10, disable left
  radio "Нотисы", 9, 96 26 50 10, disable left
  edit "", 10, 25 26 15 9, disable autohs
  text "мин.", 11, 41 26 13 8, disable
  text "Каждые", 12, 3 26 21 8, disable
  text "Сообщение об уходе", 13, 2 38 104 8
  button "Стандарт", 15, 110 37 38 9
  edit "", 14, 2 46 147 10, autohs
  text "Сообщение о возвращении", 16, 2 57 104 8
  edit "", 17, 2 65 147 10, autohs
  button "Стандарт", 18, 110 56 38 9
  text "Сообщение о смене причины", 19, 2 76 104 8
  edit "", 20, 2 84 147 10, autohs
  button "Стандарт", 21, 110 75 38 9
  text "Промежуточное сообщение", 22, 2 95 104 8
  edit "", 23, 2 103 147 10, autohs
  button "Стандарт", 24, 110 94 38 9
  text "Неизменная причина", 25, 2 114 104 8
  edit "", 26, 2 122 147 10, autohs
  button "Стандарт", 27, 110 113 38 9
}

on *:dialog:Pawaymes:*:*:{
  if ($devent == init) {
    did -a pawaymes 14 %str.away.msg
    did -a pawaymes 17 %str.away.return
    did -a pawaymes 20 %str.away.change
    did -a pawaymes 23 %str.away.repeat
    did -a pawaymes 26 %str.away.nochange
    if (%prefs.away.mes) { did -c pawaymes 5 | did -e pawaymes 6-12 }
    if (%prefs.away.mesmid) did -c pawaymes 6
    if (%prefs.away.mesmode == describe) did -c pawaymes 8
    if (%prefs.away.mesmode == notice) did -c pawaymes 9
    if ((!$did(8).state) && (!$did(9).state)) did -c pawaymes 7
    did -a pawaymes 10 %nums.away.rep.mins
  }
  if ($devent == edit) {
    did -e Pawaymes 1 
  }
  if ($devent == sclick) {
    if ($did == 5) { if (!$did(5).state) did -b pawaymes 6-12 | else did -e pawaymes 6-12 }
    if ($did == 2) {
      help.show mawaymes
      return
    }
    if ($did == 1) {
      %prefs.away.mes = $iif($did(5).state,$true,$false)
      %prefs.away.mesmid = $iif($did(6).state,$true,$false)
      if ($did(7).state) %prefs.mesmode = msg
      if ($did(8).state) %prefs.mesmode = describe
      if ($did(9).state) %prefs.mesmode = notice
      if ($did(10) !isnum 1-999) { did -o pawaymes 10 1 $iif(%nums.away.rep.mins,$ifmatch,$stdget(nums.away.rep.mins)) }
      %nums.away.rep.mins = $did(10)
      did -b Pawaymes 1
      %str.away.msg = $did(14)
      %str.away.return = $did(17)
      %str.away.change = $did(20)
      %str.away.repeat = $did(23)
      %str.away.nochange = $did(26)
      return
    }
    if ($istok(5 6 7 8 9,$did,32)) { did -e Pawaymes 1 | return }
    if ($did == 15) {
      did -e pawaymes 1
      did -o pawaymes 14 1 %str.away.msg
      return
    }
    if ($did == 18) {
      did -e pawaymes 1
      did -o pawaymes 17 1 %str.away.return
      return
    }
    if ($did == 21) {
      did -e pawaymes 1
      did -o pawaymes 20 1 %str.away.change
      return
    }
    if ($did == 24) {
      did -e pawaymes 1
      did -o pawaymes 23 1 %str.away.repeat
      return
    }
    if ($did == 27) {
      did -e pawaymes 1
      did -o pawaymes 26 1 %str.away.nochange
      return
    }
  }
}

dialog prefs_sinfo {
  title "Информация о скрипте"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 47
  option dbu
  icon grafix\prefs_sinfo.ico, 0
  button "Применить", 1, 3 34 48 12, hide disable
  button "Справка", 2, 51 34 48 12
  button "Закрыть", 3, 99 34 48 12, ok
  text "Скрипт", 4, 1 2 20 8
  edit "", 5, 21 1 128 10, read autohs
  text "Версия", 6, 1 13 20 8
  edit "", 7, 21 12 128 10, read autohs
  text "Дата", 8, 1 24 20 8
  edit "", 9, 21 23 128 10, read autohs
}

on *:dialog:sinfo:*:*:{
  if ($devent == sclick) { if ($did == 2) {
      help.show msinfo
      return
  } }
  if ($devent == init) {
    did -a sinfo 5 %str.scriptname
    did -a sinfo 7 %str.version
    did -a sinfo 9 %str.vdate
  }
}

dialog prefs_script {
  title "Настройки скрипта"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 235 114
  option dbu
  icon grafix\prefs_script, 0
  button "Применить", 1, 3 100 48 12, disable
  button "Справка", 2, 51 100 48 12
  button "Закрыть", 3, 99 100 48 12, ok
  button "Статус", 4, 2 1 31 9
  edit "", 5, 34 1 199 10, autohs
  button "Сервис", 6, 2 12 31 9
  edit "", 7, 34 12 199 10, autohs
  button "Выход", 8, 2 23 31 9
  edit "", 9, 34 23 199 10, autohs
  button "Finger", 10, 2 34 31 9
  edit "", 11, 34 34 199 10, autohs
  check "Расширенный whois", 12, 2 45 57 10
  button "Формат времени", 13, 60 45 46 10
  edit "", 14, 106 45 64 10, return autohs center
  edit "", 15, 169 45 64 10, disable center
  check "Автозапуск часов", 16, 4 65 56 10
  check "Отдельное окно", 17, 60 65 50 10
  text "Координаты:", 18, 134 67 33 8
  edit "", 19, 169 65 62 10, right
  box "Часы", 20, 2 57 231 21
  text "Количество символов в строках меню", 21, 2 80 98 8
  edit "", 22, 101 79 16 10, center
  check "Показывать справку при запуске", 23, 139 90 93 10, left
  check "Отображать окно сервисов", 24, 3 90 114 10
}

alias pscript.tik { did -o pscript 15 1 $asctime($did(pscript,14)) }
on *:dialog:Pscript:*:*:{
  if ($devent == init) {
    did -a pscript 5 %str.status.click
    did -a pscript 7 %str.servecho
    did -a pscript 9 %str.quit.mes
    did -a pscript 11 %str.finger.ans
    if (%prefs.whois.show.idle) did -c pscript 12
    did -a pscript 14 $userget(timestamp)
    pscript.tik
    .timerpscript -o 0 1 pscript.tik
    if (%prefs.clock) did -c pscript 16
    if (%prefs.clock.window) did -c pscript 17
    did -a pscript 19 %prefs.clock.xy
    did -a pscript 22 %nums.menulist.len
    if (%prefs.help.autostart) did -c pscript 23
    if (%prefs.serv.window) did -c pscript 24
  }
  if ($devent == edit) {
    did -e Pscript 1
  }
  if ($devent == sclick) {
    if ($did == 2) {
      help.show mscript
      return
    }
    if ($did == 1) {
      %str.status.click = $did(5)
      %str.servecho = $did(7)
      %str.quit.mes = $did(9)
      %str.finger.ans = $did(11)
      %prefs.whois.show.idle = $did(12).state
      userset timestamp $did(14)
      %prefs.clock = $did(16).state
      %prefs.clock.window = $did(17).state
      %prefs.help.autostart = $did(23).state
      %prefs.serv.window = $did(24).state
      %prefs.clock.xy = $did(19)
      %nums.menulist.len = $iif($did(22) isnum 5-50,$ifmatch,$stdget(nums.menulist.len))
      if ($did(22) !isnum 5-50) did -o pscript 22 1 $stdget(nums.menulist.len)
      did -b Pscript 1
      return
    }
    if ($istok(4 6 8 10 13 16 17 23 24,$did,32)) { did -e Pscript 1 }
    if ($did == 4) did -o pscript 5 1 $stdget(str.status.click)
    if ($did == 6) did -o pscript 7 1 $stdget(str.servecho)
    if ($did == 8) did -o pscript 9 1 $stdget(str.quit.mes)
    if ($did == 10) did -o pscript 11 1 $stdget(str.finger.ans)
    if ($did == 13) did -o pscript 14 1 $stdget(user.timestamp)
  }
  if ($devent == close) { .timerpscript off }
}

dialog prefs_mserver {
  title "Многосерверность"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 250 54
  option dbu
  icon grafix\prefs_mserver.ico, 0
  button "Применить", 1, 62 41 48 12, disable
  button "Справка", 2, 110 41 48 12
  button "Закрыть", 3, 158 41 48 12, ok
  check "Автосоединение с серверами по списку:", 4, 1 1 148 10
  edit "", 5, 1 11 247 10
  button "Добавить текущий", 6, 2 41 55 12
  box "Команды меню, работающие для всех серверов", 7, 4 22 244 17
  check "Смена ника", 8, 7 28 47 10
  check "Режим ухода", 9, 57 28 50 10
  check "Выход из сети", 10, 111 28 50 10
}

on *:dialog:Pmserver:*:*:{
  if ($devent == init) {
    if (%prefs.multiserver) did -c pmserver 4
    did -a pmserver 5 %prefs.servers
    if (%prefs.mserver.nick) did -c pmserver 8
    if (%prefs.mserver.away) did -c pmserver 9
    if (%prefs.mserver.quit) did -c pmserver 10
  }
  if ($devent == edit) {
    did -e Pmserver 1
  }
  if ($devent == sclick) {
    if ($did == 2) {
      help.show mserver
      return
    }
    if ($did == 1) {
      if ($did(4).state) %prefs.multiserver = $true
      else %prefs.multiserver = $false
      if ($did(8).state) %prefs.mserver.nick = $true
      else %prefs.mserver.nick = $false
      if ($did(9).state) %prefs.mserver.away = $true
      else %prefs.mserver.away = $false
      if ($did(10).state) %prefs.mserver.quit = $true
      else %prefs.mserver.quit = $false
      %prefs.servers = $did(5)
      did -b Pmserver 1
      return
    }
    if ($istok(4 8 9 10,$did,32)) { did -e pmserver 1 | return }
    if ($did == 6) { scid $activecid did -o pmserver 5 1 $addtok($did(5),$server,32) | did -e Pmserver 1 | return }
  }
}

dialog prefs_sounds {
  title "Настройки звуков"
  size $iif($calc($dialog(PMenu).x + $dialog(PMenu).w),$ifmatch,20) $iif($dialog(PMenu).y,$ifmatch,65) 150 95
  option dbu
  icon grafix\prefs_sounds.ico, 0
  button "Применить", 1, 3 80 48 12, disable
  button "Справка", 2, 51 80 48 12
  button "Закрыть", 3, 99 80 48 12, ok
}


dialog clock {
  title "Часы"
  size $iif(%prefs.clock.xy,$ifmatch,-1 -1) 50 8
  option dbu
  text "", 1, 0 0 50 10, center
}

on *:dialog:Clock:*:*:{
  if ($devent == init) {
    did -a Clock 1 [ $timestamp ]
    .timerclock -o 0 1 clock.tik
  }
  if ($devent == close) { .timerclock off }
  if ($devent == rclick) { if ($input(Сохранить положение часов?,yq,Положение часов)) set %prefs.clock.xy $dialog(clock).x $dialog(clock).y }
}

alias clock.tik { did -o clock 1 1 $timestamp }
