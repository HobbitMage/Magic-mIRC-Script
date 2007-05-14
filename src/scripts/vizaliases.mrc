;vizu
proc.load {
  echo %colors.system -sta $st.color(Magic Script) is loading
  if ($fopen(file)) { .fclose file }
  unset %colors.*
  unset %str.*
  unset %files.*
  var %t = 0, %setup = strings/setup.ini
  .timerload -mh 0 1  inc %t
  var %i = 1, %j = 1, %n = $ini(%setup,0), %tmp, %namen, %name, %namep, %pre
  while (%i <= %n) {
    %name = $ini(%setup,%i)
    %namen = $ini(%setup,%i,0)
    while (%j <= %namen) { 
      %namep = $ini(%setup,%i,%j)
      set -n %tmp $readini(%setup,n,%name,%namep)
      if ($left(%tmp,1) == $chr(127)) set -n %tmp $right(%tmp,-1)
      if (%name == user) { if (%tmp != $null) {
          if (%namep == nick) if (!$away) nick %tmp
          if (%namep == anick) .anick %tmp
          if (%namep == timestamp) .timestamp -f %tmp
          if (!$istok(nick timestamp anick,%namep,32)) set -n % [ $+ [ %namep ] ] %tmp
      } }
      else if (%tmp != $null) set -n % [ $+ [ %name ] $+ . $+ [ %namep ] ] %tmp 
      inc %j 
    }
    %j = 1
    inc %i
  }
  set %i 0
  var %theme = $readini(mirc.ini,text,theme)
  while (%i < $ini(mirc.ini,colors,0)) {
    set %tmp $readini(mirc.ini,colors,n $+ %i)
    if ($gettok(%tmp,1,44) == %theme) { break }
    inc %i
  }
  set %colors.back $str(0,$calc(2 - $len($gettok(%tmp,2,44)))) $+ $gettok(%tmp,2,44)
  set %colors.action $str(0,$calc(2 - $len($gettok(%tmp,3,44)))) $+ $gettok(%tmp,3,44)
  set %colors.ctcp $str(0,$calc(2 - $len($gettok(%tmp,4,44)))) $+ $gettok(%tmp,4,44)
  set %colors.highlight $str(0,$calc(2 - $len($gettok(%tmp,5,44)))) $+ $gettok(%tmp,5,44)
  set %colors.info $str(0,$calc(2 - $len($gettok(%tmp,6,44)))) $+ $gettok(%tmp,6,44)
  set %colors.info2 $str(0,$calc(2 - $len($gettok(%tmp,7,44)))) $+ $gettok(%tmp,7,44)
  set %colors.invite $str(0,$calc(2 - $len($gettok(%tmp,8,44)))) $+ $gettok(%tmp,8,44)
  set %colors.join $str(0,$calc(2 - $len($gettok(%tmp,9,44)))) $+ $gettok(%tmp,9,44)
  set %colors.kick $str(0,$calc(2 - $len($gettok(%tmp,10,44)))) $+ $gettok(%tmp,10,44)
  set %colors.mode $str(0,$calc(2 - $len($gettok(%tmp,11,44)))) $+ $gettok(%tmp,11,44)
  set %colors.nick $str(0,$calc(2 - $len($gettok(%tmp,12,44)))) $+ $gettok(%tmp,12,44)
  set %colors.normal $str(0,$calc(2 - $len($gettok(%tmp,13,44)))) $+ $gettok(%tmp,13,44)
  set %colors.notice $str(0,$calc(2 - $len($gettok(%tmp,14,44)))) $+ $gettok(%tmp,14,44)
  set %colors.notify $str(0,$calc(2 - $len($gettok(%tmp,15,44)))) $+ $gettok(%tmp,15,44)
  set %colors.other $str(0,$calc(2 - $len($gettok(%tmp,16,44)))) $+ $gettok(%tmp,16,44)
  set %colors.own $str(0,$calc(2 - $len($gettok(%tmp,17,44)))) $+ $gettok(%tmp,17,44)
  set %colors.part $str(0,$calc(2 - $len($gettok(%tmp,18,44)))) $+ $gettok(%tmp,18,44)
  set %colors.quit $str(0,$calc(2 - $len($gettok(%tmp,19,44)))) $+ $gettok(%tmp,19,44)
  set %colors.topic $str(0,$calc(2 - $len($gettok(%tmp,20,44)))) $+ $gettok(%tmp,20,44)
  set %colors.wallops $str(0,$calc(2 - $len($gettok(%tmp,21,44)))) $+ $gettok(%tmp,21,44)
  set %colors.whois $str(0,$calc(2 - $len($gettok(%tmp,22,44)))) $+ $gettok(%tmp,22,44)
  set %colors.edit.back $str(0,$calc(2 - $len($gettok(%tmp,23,44)))) $+ $gettok(%tmp,23,44)
  set %colors.edit.text $str(0,$calc(2 - $len($gettok(%tmp,24,44)))) $+ $gettok(%tmp,24,44)
  set %colors.list.back $str(0,$calc(2 - $len($gettok(%tmp,25,44)))) $+ $gettok(%tmp,25,44)
  set %colors.list.text $str(0,$calc(2 - $len($gettok(%tmp,26,44)))) $+ $gettok(%tmp,26,44)
  set %colors.list.gray $str(0,$calc(2 - $len($gettok(%tmp,27,44)))) $+ $gettok(%tmp,27,44)
  set %colors.list.title $str(0,$calc(2 - $len($gettok(%tmp,28,44)))) $+ $gettok(%tmp,28,44)
  set %colors.edit.inactive $str(0,$calc(2 - $len($gettok(%tmp,29,44)))) $+ $gettok(%tmp,29,44)

  unset %isaway_*
  ;files
  ;nicks
  %i = 1
  .fopen file strings/nicks.txt
  while (%i <= $lines(strings/nicks.txt)) {
    if ($feof) { fclose file | break }
    %files.nick. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.nick.num = %i
  if ($fopen(file)) { .fclose file }
  ;away
  %i = 1
  .fopen file strings/away.txt
  while (%i <= $lines(strings/away.txt)) {
    if ($feof) { fclose file | break }
    %files.away. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.away.num = %i
  if ($fopen(file)) { .fclose file }
  ;channels
  %i = 1
  .fopen file strings/channels.txt
  while (%i <= $lines(strings/channels.txt)) {
    if ($feof) { fclose file | break }
    %files.join. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.join.num = %i
  if ($fopen(file)) { .fclose file }
  ;quit
  %i = 1
  .fopen file strings/quit.txt
  while (%i <= $lines(strings/quit.txt)) {
    if ($feof) { fclose file | break }
    %files.quit. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.quit.num = %i
  if ($fopen(file)) { .fclose file }
  ;kick
  %i = 1
  .fopen file strings/kick.txt
  while (%i <= $lines(strings/kick.txt)) {
    if ($feof) { fclose file | break }
    %files.kick. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.kick.num = %i
  if ($fopen(file)) { .fclose file }
  ;ctcp
  %i = 1
  .fopen file strings/ctcp.txt
  while (%i <= $lines(strings/ctcp.txt)) {
    if ($feof) { fclose file | break }
    %files.ctcp. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.ctcp.num = %i
  if ($fopen(file)) { .fclose file }
  ;kick
  %i = 1
  .fopen file strings/kick.txt
  while (%i <= $lines(strings/kick.txt)) {
    if ($feof) { fclose file | break }
    %files.kick. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.kick.num = %i
  if ($fopen(file)) { .fclose file }
  ;files
  %i = 1
  .fopen file strings/files.txt
  while (%i <= $lines(strings/files.txt)) {
    if ($feof) { fclose file | break }
    %files.files. [ $+ [ %i ] ] = $fread(file)
    inc %i
  }
  %files.files.num = %i
  if ($fopen(file)) { .fclose file }
  ;services
  %i = 1
  echo %colors.system -sta $st.color(Magic Script) Ready in %t ms
  .timerload off
}

proc.start {
  proc.load
  if (%prefs.serv.window) window -ek0mxzn @Сервисы // $+ $netget(nickserv.call)
  if (%prefs.clock) {   
    if ($dialog(clock)) dialog -vs clock $iif(%prefs.clock.xy,$ifmatch,-1 -1) $dialog(clock).cw $dialog(clock).ch
    else dialog $iif(%prefs.clock.window,-mdo,-m) clock clock 
  }
  if (%prefs.help.autostart) help.show sys
  if (%prefs.multiserver) {
    if ($numtok(%prefs.servers,32) > 1) {
      server $gettok(%prefs.servers,1,32)
      %i = 2
      while (%i <= $numtok(%prefs.servers,32)) {
        server -m $gettok(%prefs.servers,%i,32)
        inc %i
      }
    }
  }
}

proc.save { 
  echo %colors.system -at Сохранение переменных
  var %setup = strings\setup.ini
  .copy -o %setup %setup $+ .bak
  var %i = 1, %j = 1, %n = $ini(%setup,0), %tmp, %namen, %name, %namep, %pre
  while (%i <= %n) {
    %name = $ini(%setup,%i)
    %namen = $ini(%setup,%i,0)
    while (%j <= %namen) { 
      %namep = $ini(%setup,%i,%j)
      if (%name == user) {
        if (%namep == anick) writeini %setup user anick $anick
        if (%namep == timestamp) writeini %setup user timestamp $timestampfmt
        if (!$istok(nick timestamp anick,%namep,32)) writeini %setup user %namep [ % $+ [ %namep ] ]
      }
      else {
        set -n %tmp [ % [ $+ [ %name ] $+ . $+ [ %namep ] ] ]
        if ($istok(2 3 22 31,$asc($left(%tmp,1)),32)) set -n %tmp $chr(127) $+ %tmp
        if (%tmp != $null) mwriteini %setup %name %namep %tmp 
      }
      inc %j 
    }
    %j = 1
    inc %i
  }
  echo %colors.system -at Сохранение переменных завершено
  return
  :error
  echo %colors.system -at Ошибка сохранения переменных. Сохраните еще раз.
  .timer 1 1 .copy -o %setup $+ .bak %setup
}


proc.connect {
  unset %isaway_*_ [ $+ [ $server ] ]
  ;-----------------------------
  var %i = 1
  while (%i <= $lines(strings/perform.txt)) {
    var %str = $read(strings/perform.txt,%i)
    var %targ = $gettok(%str,1,32)
    set %str $gettok(%str,2-,32)
    if (%targ == all) { [ [ %str ] ] | goto end }
    if (%targ == $network) { [ [ %str ] ] | goto end }
    if (%targ == $server) { [ [ %str ] ] | goto end }
    :end
    inc %i
  }
  ;-----------------------------  
}
proc.disconnect {
  unset %isaway_*_ [ $+ [ $server ] ]
}
proc.exit {
  unset %isaway_*
}

chnick {
  var %str 
  if ($1 == $me) { set %str %str $+ %colors.mynick | goto cvend }
  if ($isdown($1)) { set %str %str $+ %colors.downnick | goto cvend }
  if ($isbot($1)) { set %str %str $+ %colors.botnick | goto cvend }
  set %str %str $+ %colors.nick
  :cvend
  set %str %str $+ $1 $+ 
  return %str
}

mwriteini {
  var %i = 1, %str, %tmp
  %tmp = $read($1,s,$chr(91) $+ $2 $+ $chr(93))
  %str = $readn
  %i = %str + 1
  while ([*] !iswm %tmp) {
    set -n %tmp $read($1,n,%i)
    if ([*] iswm %tmp) { write -il $+ %i $1 $3 $+ = $+ $4- | return }
    if ($gettok(%tmp,1,61) == $3) { write -l $+ %i $1 $3 $+ = $+ $4- | return }
    inc %i
  }
}
random { return [ $ $+ [ $rand(1,$0) ] ] } 
неори say $snicks $+ : http://www.dan78.pri.ee/pe4ati/11.gif
