;##############################################
;################### Клавиши ##################
f1 help $1-
F5  if ($editbox($active)) editbox -an $st.shuf($editbox($active))
F6  if ($editbox($active)) editbox -an /mcom amsg $editbox($active)
F7 if ($editbox($active)) editbox -an /me [ $iif($chr(32) $+ №ник isin $editbox($active),$replace($editbox($active),$chr(32) $+ №ник,$chr(32) $+ $$1),$editbox($active)) ]
F8  if ($editbox($active)) editbox -an /mcom ame $editbox($active)

sF5  if ($editbox($active)) editbox -an $st.color($editbox($active))
sF6  if ($editbox($active)) editbox -an /mcom amsg [ [ $editbox($active) ] ]
sF7 if ($editbox($active)) editbox -an /me [ [ $editbox($active) ] ]
sF8  if ($editbox($active)) editbox -an /mcom ame [ [ $editbox($active) ] ]

cF5 if ($editbox($active)) editbox -an $st.spaces($editbox($active))
cF9 editbox -a $trans.en.ru($editbox($active))
cF10 editbox -a $trans.ru.en($editbox($active))

j join #$1 $2-
† describe $active поставил $+ $sex(,а,о,и) на $snicks †

;##############################################
;################# переводчики ################
trans.en.ru return $replacecs($1-,.,ю,$chr(44),б,q,й,w,ц,e,у,r,к,t,е,y,н,u,г,i,ш,o,щ,p,з,[,х,],ъ,a,ф,s,ы,d,в,f,а,g,п,h,р,j,о,k,л,l,д,;,ж,',э,z,я,x,ч,c,с,v,м,b,и,n,т,m,ь,.,ю,Q,Й,W,Ц,E,У,R,К,T,Е,Y,Н,U,Г,I,Ш,O,Щ,P,З,$chr(123),Х,$chr(125),Ъ,A,Ф,S,Ы,D,В,F,А,G,П,H,Р,J,О,K,Л,L,Д,:,Ж,",Э,Z,Я,X,Ч,C,С,V,М,B,И,N,Т,<,Б,>,Ю,?,$chr(44),&,?,^,:,/,.,`,ё,$,;,№,$chr(35),@,",$chr(35),№,$chr(36),;,&,?,~,Ё)
trans.ru.en return $replacecs($1-,ю,.,б,$chr(44),й,q,ц,w,у,e,к,r,е,t,н,y,г,u,ш,i,щ,o,з,p,х,[,ъ,],ф,a,ы,s,в,d,а,f,п,g,р,h,о,j,л,k,д,l,ж,;,э,',я,z,ч,x,с,c,м,v,и,b,т,n,ь,m,б,.,Й,Q,Ц,W,У,E,К,R,Е,T,Н,Y,Г,U,Ш,I,Щ,O,З,P,Х,$chr(123),Ъ,$chr(125),Ф,A,Ы,S,В,D,А,F,П,G,Р,H,О,J,Л,K,Д,L,Ж,:,Э,",Я,Z,Ч,X,С,C,М,V,И,B,Т,N,Ь,M,Б,<,Ю,>,$chr(44),?,?,&,:,^,.,/,ё,`,;,$chr(36),№,$chr(35),Ё,~,",@,№,$chr(35))

;##############################################
;################# стиллизаторы ###############
st.color {
  ;раскраска случайными цветами
  var %len = 0 , %str , %nik , %col
  set %str $null
  set %nik  $replace($1-, $chr(32),$chr(1)) 
  :cvet
  set %col $rand(3,13)
  if ( %col isnum 1-9 ) set %col 0 $+ %col
  set %str %str $+  $+ %col $+ $left( %nik , 1) 
  set %nik $right( %nik , -1 )
  set %len $calc( %len + 1 )
  if ( %len >= $len($1-) ) { return  $replace(%str $+ ,$chr(1), $chr(32))  | halt } 
  else {  goto cvet }
}

st.shuf {
  ;перемешивание строки
  var %str, %nik, %num | set %str $null | set %nik $replace($1,$chr(32),$chr(1))
  :shuf
  set %num $rand(1,$len(%nik)) | set %str %str $+ $mid(%nik,%num,1) | set %nik $left(%nik,$calc(%num -1)) $+ $right(%nik,$calc($len(%nik) - %num))
  if ($len(%nik)) goto shuf
  return  $replace(%str,$chr(1), $chr(32),$chr(2),$chr(44))
}

st.spaces {
  ;после каждого символа идет один пробел
  var %i = 1, %str
  set %old $1-
  :loop
  set %str %str $left(%old,1)
  set %old $right(%old,-1)
  inc %i 1
  if (%i < $calc(2 + $len($1-))) goto loop
  return %str
}

st.twocolors {
  ;строка красится в два цвета: первым цветом первая буква каждого слова, остальная часть слова вторым цветом
  var %i = 1, %str
  while (%i <= $len($3)) {
    set %str %str  $+ $1 $+ $left($gettok($3,%i,32),1) $+ $iif($right($gettok($3,%i,32),-1), $+ $2 $+ $ifmatch)
    inc %i
  }
  return %str
}

st.revert {
  ;строка задом наперед
  var %i = 0, %str, %str2
  set %str $replace($1-,$chr(32),$chr(1))
  :loop
  set %str2 %str2 $+ $right(%str,1)
  set %str $left(%str,-1)
  if ($len(%str)) goto loop
  return $replace(%str2,$chr(1),$chr(32))
}

;##############################################
;################## дополнения ################
nick.insert {
  if (($changet($chan,colors) == 1) || ((($changet($chan,colors) == 2) || ($changet($chan,colors) == $null)) && (c !isincs $chan($active).mode))) var %color = $true
  var %nick = [ [ $iif($replace($1-,$chr(32),$chr(44) $+ $chr(32),_,$chr(32)),$ifmatch,$1-) ] ], %mes = $editbox($chan)
  if (!%nick) %nick = $1-
  var %tmp = $readini(strings/passes.ini,$1,names)
  if ($rand(0,$numtok(%tmp,1)) != 0) { set %nick $gettok(%tmp,$ifmatch,1) }
  var %text = [ [ %str.nickins ] ]

  if ($editbox($chan) != $null)  {
    if (%prefs.nickinsert.type == 1) editbox -na $iif(%color,%text,$strip(%text))
    if (%prefs.nickinsert.type == 2) editbox -na $iif(%color,%text,$strip(%text))
    if (%prefs.nickinsert.type == 3) query $1-
    if (%prefs.nickinsert.type == 4) editbox -a $iif(%color,%text,$strip(%text))
  }
  else { 
    if (%prefs.nickinsert.type == 1) query $1-
    if (%prefs.nickinsert.type == 2) editbox -a $iif(%color,%text,$strip(%text))
    if (%prefs.nickinsert.type == 3) editbox -a $iif(%color,%text,$strip(%text))
    if (%prefs.nickinsert.type == 4) query $1-
  }
}

nill { }

runt { if (!$exists($1-)) { write $1- | echo %colors.info Создан файл $+ %colors.system $1- } | run $1- }
google  { run http://www.google.ru/search?q= $+ $replace($1-,$chr(32),+) }
g google $1-
d google define: $+ $1-

===========================================
netsetup {
  var %pref = $readini(strings/networks.ini,$network,$1)
  var %info, %def
  if ($2 == $null) {
    if ($istok(chanserv.call nickserv.call memoserv.call,$1,32)) { %info = Команда вызова сервиса | %def = msg $gettok($1,1,46) }
    if ($istok(fastghost,$1,32)) { %info = Автоматическая смена ника при команде ns ghost $crlf $+ Может принимать значения $true и $false | %def = $true }
    if ($istok(nickidentstring,$1,32)) { %info = Строка, которой сервис ников запрашивает ввод пароля | %def = This nickname is registered and protected. If it is your }
    if ($istok(nickregisterstring,$1,32)) { %info = Строка, которой сервис ников предлагает регистрацию | %def = This nick is not registered, if you intend to use it in the future }
    if (!%info) %info = Измените поле $1 | if (!%def) %def = $null
    var %tmp = $input(%info,eyq,Настройка сети $network,$iif(%pref,%pref,%def))
    if (%tmp) writeini strings/networks.ini $network $1 %tmp
    return
  }
  writeini strings/networks.ini $network $1 $2-
}

netget {
  var %tmp = $readini(strings/networks.ini,$network,$1)
  if (%tmp) return %tmp
  if ($1 == MemoServ.call) return .msg memoserv 
  if ($1 == NickServ.call) return .msg nickserv 
  if ($1 == ChanServ.call) return .msg chanserv 
}

nickset {
  var %pref = $readini(strings/passes.ini,$network,$1)
  var %info, %ishide, %def
  if ($3 == $null) {
    if ($istok(password,$2,32)) { %info = Пароль от $1 в сети $network | %def = $nickget($1,password) | %ishide = $false }
    if (!%info) %info = Поле $2 от $1 в сети $network | if (!%def) %def = $null
    var %tmp = $input(%info,eyq $+ $iif(%ishide,p),Настройка ника $1 в сети $network,$iif(%pref,%pref,%def))
    if (%tmp) writeini strings/passes.ini $1 [ $2 ] $+ + $+ [ $network ] %tmp
    return
  }
  writeini strings/passes.ini $1 [ $2 ] $+ + $+ [ $network ] $3-
}

nickget {
  return $readini(strings/passes.ini,$1,[ $2 ] $+ + $+ [ $network ])
}

userset {
  var %pref = $readini(strings/setup.ini,user,$1)
  var %info, %def
  if ($1 == timestamp) { .timestamp -f $2- | writeini strings/setup.ini user $1 $2- | return }
  if ($1 == nick) { nick $2- | writeini strings/setup.ini user $1 $2- | return }
  if ($1 == anick) { .anick $2- | writeini strings/setup.ini user $1 $2- | return }
  if ($1 == sex) { set %sex $iif($2,$2,1) | writeini strings/setup.ini user $1 $2 | return }
  if ($2 == $null) {
    if ($istok(pass.email,$1,32)) { %info = Почта, используемая для писем паролей | %def = nomail }
    if (!%info) %info = Измените поле $1 | if (!%def) %def = $null
    var %tmp = $input(%info,eyq,Настройка сети $network,$iif(%pref,%pref,%def))
    if (%tmp) { writeini strings/user.ini user $1 %tmp | set $chr(37) $+ [ $1 ] %tmp }
    return
  }
  writeini strings/setup.ini user $1 $2- | set $chr(37) $+ [ $1 ] %tmp
}

userget {
  return $readini(strings/setup.ini,user,$1)
}

stdget {
  if ($1- == str.away.nochange) return 10Причина ухода совпадает с текущей
  if ($1- == str.away.msg) return 10уш $ $+ + $ $+ sex(ел,ла,ло,ли) $ $+ + 3. Причина:10 $ $+ 1-
  if ($1- == str.away.return) return 10вернул $ $+ + $ $+ sex(ся,ась,ось,ись) $ $+ + . 3Уходил $ $+ + $ $+ sex(,а,о,и) $+ 10 $ $+ duration($awaytime,3) 3назад по причине:10 $ $+ awaymsg
  if ($1- == str.away.change) return 10Уходил $ $+ + $ $+ sex(,а,о,и) $ $+ + 3 $ $+ duration($awaytime,3) 10назад по причине:3 $ $+ awaymsg $ $+ + 10. Теперь уш $ $+ + $ $+ sex(ел,ла,ло,ли) по причине:3 $ $+ 1-
  if ($1- == str.away.repeat) return 10не здесь. 3Уш $ $+ + $ $+ sex(ел,ла,ло,ли) $ $+ + 10 $ $+ duration($awaytime,3) 3назад по причине:10 $ $+ awaymsg
  if ($1- == nums.away.rep.mins) return 40
  if ($1- == nums.menulist.len) return 15
  if ($1- == str.status.click) return Сервер $ $+ + % $+ colors.server $ $+ server подключен к сети $ $+ + % $+ colors.server $ $+ network
  if ($1- == str.servecho) return $ $+ network $ $+ + 9: Сервис $ $+ 1 $ $+ + 9| $ $+ 2-
  if ($1- == str.finger.ans) return Пальцем не тыкать!
  if ($1- == str.quit.mes) return $ $+ iif($network == gamenavigator,http://magic.gamenavigator.ru,Magic Script % $+ str.version от % $+ str.vdate $ $+ + )
  if ($1- == str.nickins) return 4 $ $+ + % $+ nick $ $+ + 3, % $+ mes
  if ($1- == user.timestamp) return $chr(91) HH:nn:ss $chr(93)
}

chanset {
  var %info, %ishide, %def, %pref
  if ($3 == $null) {
    if ($istok(password,$2,32)) { %info = Пароль от $1 в сети $network | %def = $changet($1,$2) | %ishide = $false }
    if (!%info) %info = Поле $2 от $1 в сети $network | if (!%def) %def = $null
    var %tmp = $input(%info,eyq $+ $iif(%ishide,p),Настройка канала  $1 в сети $network,$iif(%pref,%pref,%def))
    if (%tmp) writeini strings/chans.ini $1 [ $2 ] $+ + $+ [ $network ] %tmp
    return
  }
  writeini strings/chans.ini $1 [ $2 ] $+ + $+ [ $network ] $3-
}

changet {
  return $readini(strings/chans.ini,$1,[ $2 ] $+ + $+ [ $network ])
}

if3 {
  ;var n1 n2 n3 ans1 ans2 ans3 ans4
  if ($1 == $2) { return $5 | halt }
  if ($1 == $3) { return $6 | halt }
  if ($1 == $4) { return $8 | halt }
  return $7
}

sex {  return $if3(%sex,m,f,n,$1,$2,$3,$4) }
