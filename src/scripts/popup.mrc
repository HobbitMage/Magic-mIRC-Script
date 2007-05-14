Меню
Перезагрузить переменные:proc.load
Сохранить переменные:{ if ($input(Не сохраняйте $+ $chr(44) если у вас появляются ошибки,qy,Сохранить все переменные?)) proc.save }
-
Файлы настроек
.Настройки клиента:runt strings/setup.ini
.Настройки сетей:runt strings/networks.ini
.Настройки ников:runt strings/passes.ini
.Настройки каналов:runt strings/chans.ini
.-
.Список причин ухода:runt strings/away.txt
.Список ников:runt strings/nicks.txt
.Список каналов:runt strings/chans.txt
.Список причин киков:runt strings/kick.txt
.Список причин выхода:runt strings/quit.txt
.Список сообщений ctcp:runt strings/ctcp.txt
.Список файлов быстрого доступа:runt strings/files.txt
.-
.Команды автовыполнения:runt strings/perform.txt
Файлы
.Папка mIRC:run .
.Записки:runt notes.txt
.Инструкция:runt Инструкция.txt
.Версии:runt Версии.txt
Логи
.$iif((!$script(logviewer.ini)) && ($exists(scripts/logviewer.ini)),Подключить просмотровщик):load -rs scripts/logviewer.ini
.$iif($script(logviewer.ini),Отключить просмотровщик):unload -rs scripts/logviewer.ini
.Папка:run $mircdir $+ logs
Настройки:{ if ($dialog(PMenu)) dialog -v PMenu | else dialog -m PMenu user_menu }
$iif($server,Настройки $network)
.Вызов chanserv:netsetup chanserv.call
.Вызов nickserv:netsetup nickserv.call
.Вызов memoserv:netsetup memoserv.call
.-
.ghost меняет ник ( $+ $netget(fastghost) $+ ):netsetup fastghost $iif($netget(fastghost),$false,$true)
.Строка запроса пароля:netsetup nickidentstring
.Строка предложения регистрации:netsetup nickregisterstring
.-
.Nickserv
..$iif($netget(ns.reg.mail),$style(1)) Требуется почта для регистраций :netsetup ns.reg.mail $iif($netget(ns.reg.mail),$false,$true)
..-
..$iif($netget(ns.help.simple),$style(1)) Help commands:netsetup ns.help.simple $iif($netget(ns.help.simple),$false,$true)
..$iif($netget(ns.auth),$style(1)) AUTH:netsetup ns.auth $iif($netget(ns.auth),$false,$true)
..$iif($netget(ns.access),$style(1)) ACCESS:netsetup ns.access $iif($netget(ns.access),$false,$true)
..$iif($netget(ns.drop.pass),$style(1)) DROP password:netsetup ns.drop.pass $iif($netget(ns.drop.pass),$false,$true)
..$iif($netget(ns.link.pass),$style(1)) LINK password:netsetup ns.link.pass $iif($netget(ns.link.pass),$false,$true)
..$iif($netget(ns.unlink.pass),$style(1)) UNLINK nick password:netsetup ns.unlink.pass $iif($netget(ns.unlink.pass),$false,$true)
..$iif($netget(ns.ajoin),$style(1)) AJOIN:netsetup ns.ajoin $iif($netget(ns.ajoin),$false,$true)
..$iif($netget(ns.set.info),$style(1)) SET INFO:netsetup ns.set.info $iif($netget(ns.set.info),$false,$true)
..$iif($netget(ns.set.icqnumber),$style(1)) SET ICQNUMBER:netsetup ns.set.icqnumber $iif($netget(ns.set.icqnumber),$false,$true)
..$iif($netget(ns.set.location),$style(1)) SET LOCATION:netsetup ns.set.location $iif($netget(ns.set.location),$false,$true)
..$iif($netget(ns.set.secure),$style(1)) SET SECURE:netsetup ns.set.secure $iif($netget(ns.set.secure),$false,$true)
..$iif($netget(ns.set.hide.usermask),$style(1)) SET HIDE USERMASK:netsetup ns.set.hide.usermask $iif($netget(ns.set.hide.usermask),$false,$true)
..$iif($netget(ns.set.timezone),$style(1)) SET TIMEZONE:netsetup ns.set.timezone $iif($netget(ns.set.timezone),$false,$true)
..$iif($netget(ns.set.mainnick),$style(1)) SET MAINNICK:netsetup ns.set.mainnick $iif($netget(ns.set.mainnick),$false,$true)
..$iif($netget(ns.unset),$style(1)) UNSET:netsetup ns.unset $iif($netget(ns.unset),$false,$true)
..$iif($netget(ns.listemail),$style(1)) LISTEMAIL:netsetup ns.listemail $iif($netget(ns.listemail),$false,$true)
..$iif($netget(ns.listchans),$style(1)) LISTCHANS:netsetup ns.listchans $iif($netget(ns.listchans),$false,$true)
.Chanserv
..$iif($netget(cs.help.simple),$style(1)) Help commands:netsetup cs.help.simple $iif($netget(cs.help.simple),$false,$true)
..$iif($netget(cs.set.topic),$style(1)) SET TOPIC:netsetup cs.set.topic $iif($netget(cs.set.topic),$false,$true)
..$iif($netget(cs.topic),$style(1)) TOPIC:netsetup cs.topic $iif($netget(cs.topic),$false,$true)
..$iif($netget(cs.set.secure),$style(1)) SET SECURE:netsetup cs.set.secure $iif($netget(cs.set.secure),$false,$true)
..$iif($netget(cs.set.enforce),$style(1)) SET ENFORCE:netsetup cs.set.enforce $iif($netget(cs.set.enforce),$false,$true)
..$iif($netget(cs.set.nolinks),$style(1)) SET NOLINKS:netsetup cs.set.nolinks $iif($netget(cs.set.nolinks),$false,$true)
..$iif($netget(cs.unset),$style(1)) UNSET:netsetup cs.UNSET $iif($netget(cs.unset),$false,$true)
..$iif($netget(cs.access.count),$style(1)) ACCESS COUNT:netsetup cs.access.count $iif($netget(cs.access.count),$false,$true)
..$iif($netget(cs.aop),$style(1)) AOP:netsetup cs.aop $iif($netget(cs.aop),$false,$true)
..$iif($netget(cs.sop),$style(1)) SOP:netsetup cs.sop $iif($netget(cs.sop),$false,$true)
..$iif($netget(cs.kick),$style(1)) KICK:netsetup cs.kick $iif($netget(cs.kick),$false,$true)
..$iif($netget(cs.akick.add),$style(1)) AKICK дополнительные команды:netsetup cs.akick.add $iif($netget(cs.akick.add),$false,$true)
..$iif($netget(cs.info.all),$style(1)) INFO ALL:netsetup cs.info.all $iif($netget(cs.info.all),$false,$true)
..$iif($netget(cs.clear.exceptions),$style(1)) CLEAR EXCEPTIONS:netsetup cs.clear.exceptions $iif($netget(cs.clear.exceptions),$false,$true)
..$iif($netget(cs.clear.invite),$style(1)) CLEAR INVITE:netsetup cs.clear.invite $iif($netget(cs.clear.invite),$false,$true)
..$iif($netget(cs.clear.halfops),$style(1)) CLEAR HALFOPS:netsetup cs.clear.halfops $iif($netget(cs.clear.halfops),$false,$true)
..$iif($netget(cs.status),$style(1)) STATUS:netsetup cs.status $iif($netget(cs.status),$false,$true)
..-
..$iif($netget(cs.protect),$style(1)) дать защиту:netsetup cs.protect $iif($netget(cs.protect),$false,$true)
..$iif($netget(cs.op),$style(1)) дать оп:netsetup cs.op $iif($netget(cs.op),$false,$true)
..$iif($netget(cs.hop),$style(1)) дать хоп:netsetup cs.hop $iif($netget(cs.hop),$false,$true)
..$iif($netget(cs.voice),$style(1)) дать войс:netsetup cs.voice $iif($netget(cs.voice),$false,$true)
.MemoServ
..$iif($netget(ms.save),$style(1)) SAVE:netsetup ms.save $iif($netget(ms.save),$false,$true)
..$iif($netget(ms.forward),$style(1)) FORWARD:netsetup ms.forward $iif($netget(ms.forward),$false,$true)
..$iif($netget(ms.info),$style(1)) INFO:netsetup ms.info $iif($netget(ms.info),$false,$true)
..$iif($netget(ms.ignore),$style(1)) IGNORE:netsetup ms.ignore $iif($netget(ms.ignore),$false,$true)
..$iif($netget(ms.set.forward),$style(1)) SET FORWARD:netsetup ms.set.forward $iif($netget(ms.set.forward),$false,$true)
-
Дополнения
.Часы:{
  if ($dialog(clock)) dialog -vs clock $iif(%prefs.clock.xy,$ifmatch,-1 -1) $dialog(clock).cw $dialog(clock).ch
  else dialog $iif(%prefs.clock.window,-mdo,-m) clock clock 
}
.$iif($script($mircdir $+ scripts\zlagbar.mrc),Выключить,Включить) лагомер:$iif($script($mircdir $+ scripts\zlagbar.mrc),unload,load) -rs scripts\zlagbar.mrc 
-
Раскладка клавиатуры:key.layout
Таблица символов:key.ascii
