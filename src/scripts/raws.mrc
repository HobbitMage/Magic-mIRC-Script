;errors
on *:input:*:{ oninput $1- }
raw *:*:{ if (!$istok(%prefs.ignoreraws,$numeric,32)) { onraw $numeric $1- } }
on *:notice:*:*:onnotice $nick $1-
ctcp ^*:*:*:onctcp $nick $1-
on *:nick:onnick $nick $newnick
on *:join:#:onjoin $nick $chan
on *:part:#:onpart $nick $chan $1-
on *:quit:onquit $nick $1-

alias onraw {
  if ($1 == 301) { 
    if ([ %isaway_ [ $+ [ $3 ] $+ _ $+ [ $server ] ] ]) { halt }
    set -u [ $+ [ %nums.away.show.delay ] ] %isaway_ [ $+ [ $3 ] $+ _ $+ [ $server ] ] $true
  }
  if ($1 == 429) { nick %oldnick [ $+ [ $cid ] ] }
  return
}

alias onnotice {
  if ($istok(nickserv chanserv memoserv,$1,32)) {
    servecho $replace($left($1,4),nick,ников,chan,каналов,memo,собщений) $2-
  }
  if (($1 == nickserv) && ($2- == $netget(nickidentstring))) {
    if ($nickget($me,password)) $netget(nickserv.call) identify $nickget($me,password)
    else echo %colors.info -at Вы выбрали занятый ник  $+ $me $+ , если он ваш, идентифицируйтесь!
  }
}

alias onctcp {
  if ($2 == version) { ctcpreply $1 $2 $st.color(Magic script) %str.version | return }
  if ($2 == finger) { ctcpreply $1 $2 $ctcp.finger.ans | haltdef | return }
}

alias servecho { 
  if (%prefs.serv.window) {
    if (!$window(@Сервисы))   window -ek0mxzn @Сервисы // $+ $netget(nickserv.call) 
    echo 3 -t @Сервисы [ [ %str.servecho ] ] 
  }
  return
}

alias group.color {
  ;$1 = nick $2 = color
  var %i = 1, %num = $chan(0)
  while (%i <= %num) {
    if ($1 ison $chan(%i)) cline $iif($2 isnum 0-15,-l $2,-lr) $chan(%i) $1
    inc %i 
  }
}
alias group.color.find {
  var %num = $0
  var %i = 2, %nick, %group
  while (%i <= %num) {
    %nick = $remove($ [ $+ [ %i ] ],+,@,.,%)
    %group = $nickget(%nick,group)
    if (%group == Друзья) cline -l %logview.n.friend $1 %nick
    if (%group == Враги) cline -l %logview.n.enemy $1 %nick
    inc %i
  }
}

alias onnick {
}

alias onjoin {
  if ($1 == $me) return
}

alias onpart {
  if (($window($1)) && ($3 == +q)) echo %logview.info -t $1  $+ %logview.hl $+ $1 вышел из сети.
}
alias onquit {
  if ($window($1)) echo %logview.info -t $1  $+ %logview.hl $+ $1 вышел из сети.
}

alias oninput {
}
