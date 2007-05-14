;##############################################
;################### ������� ##################
f1 help $1-
F5  if ($editbox($active)) editbox -an $st.shuf($editbox($active))
F6  if ($editbox($active)) editbox -an /mcom amsg $editbox($active)
F7 if ($editbox($active)) editbox -an /me [ $iif($chr(32) $+ ���� isin $editbox($active),$replace($editbox($active),$chr(32) $+ ����,$chr(32) $+ $$1),$editbox($active)) ]
F8  if ($editbox($active)) editbox -an /mcom ame $editbox($active)

sF5  if ($editbox($active)) editbox -an $st.color($editbox($active))
sF6  if ($editbox($active)) editbox -an /mcom amsg [ [ $editbox($active) ] ]
sF7 if ($editbox($active)) editbox -an /me [ [ $editbox($active) ] ]
sF8  if ($editbox($active)) editbox -an /mcom ame [ [ $editbox($active) ] ]

cF5 if ($editbox($active)) editbox -an $st.spaces($editbox($active))
cF9 editbox -a $trans.en.ru($editbox($active))
cF10 editbox -a $trans.ru.en($editbox($active))

j join #$1 $2-
� describe $active �������� $+ $sex(,�,�,�) �� $snicks �

;##############################################
;################# ����������� ################
trans.en.ru return $replacecs($1-,.,�,$chr(44),�,q,�,w,�,e,�,r,�,t,�,y,�,u,�,i,�,o,�,p,�,[,�,],�,a,�,s,�,d,�,f,�,g,�,h,�,j,�,k,�,l,�,;,�,',�,z,�,x,�,c,�,v,�,b,�,n,�,m,�,.,�,Q,�,W,�,E,�,R,�,T,�,Y,�,U,�,I,�,O,�,P,�,$chr(123),�,$chr(125),�,A,�,S,�,D,�,F,�,G,�,H,�,J,�,K,�,L,�,:,�,",�,Z,�,X,�,C,�,V,�,B,�,N,�,<,�,>,�,?,$chr(44),&,?,^,:,/,.,`,�,$,;,�,$chr(35),@,",$chr(35),�,$chr(36),;,&,?,~,�)
trans.ru.en return $replacecs($1-,�,.,�,$chr(44),�,q,�,w,�,e,�,r,�,t,�,y,�,u,�,i,�,o,�,p,�,[,�,],�,a,�,s,�,d,�,f,�,g,�,h,�,j,�,k,�,l,�,;,�,',�,z,�,x,�,c,�,v,�,b,�,n,�,m,�,.,�,Q,�,W,�,E,�,R,�,T,�,Y,�,U,�,I,�,O,�,P,�,$chr(123),�,$chr(125),�,A,�,S,�,D,�,F,�,G,�,H,�,J,�,K,�,L,�,:,�,",�,Z,�,X,�,C,�,V,�,B,�,N,�,M,�,<,�,>,$chr(44),?,?,&,:,^,.,/,�,`,;,$chr(36),�,$chr(35),�,~,",@,�,$chr(35))

;##############################################
;################# ������������ ###############
st.color {
  ;��������� ���������� �������
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
  ;������������� ������
  var %str, %nik, %num | set %str $null | set %nik $replace($1,$chr(32),$chr(1))
  :shuf
  set %num $rand(1,$len(%nik)) | set %str %str $+ $mid(%nik,%num,1) | set %nik $left(%nik,$calc(%num -1)) $+ $right(%nik,$calc($len(%nik) - %num))
  if ($len(%nik)) goto shuf
  return  $replace(%str,$chr(1), $chr(32),$chr(2),$chr(44))
}

st.spaces {
  ;����� ������� ������� ���� ���� ������
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
  ;������ �������� � ��� �����: ������ ������ ������ ����� ������� �����, ��������� ����� ����� ������ ������
  var %i = 1, %str
  while (%i <= $len($3)) {
    set %str %str  $+ $1 $+ $left($gettok($3,%i,32),1) $+ $iif($right($gettok($3,%i,32),-1), $+ $2 $+ $ifmatch)
    inc %i
  }
  return %str
}

st.revert {
  ;������ ����� �������
  var %i = 0, %str, %str2
  set %str $replace($1-,$chr(32),$chr(1))
  :loop
  set %str2 %str2 $+ $right(%str,1)
  set %str $left(%str,-1)
  if ($len(%str)) goto loop
  return $replace(%str2,$chr(1),$chr(32))
}

;##############################################
;################## ���������� ################
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

runt { if (!$exists($1-)) { write $1- | echo %colors.info ������ ���� $+ %colors.system $1- } | run $1- }
google  { run http://www.google.ru/search?q= $+ $replace($1-,$chr(32),+) }
g google $1-
d google define: $+ $1-

===========================================
netsetup {
  var %pref = $readini(strings/networks.ini,$network,$1)
  var %info, %def
  if ($2 == $null) {
    if ($istok(chanserv.call nickserv.call memoserv.call,$1,32)) { %info = ������� ������ ������� | %def = msg $gettok($1,1,46) }
    if ($istok(fastghost,$1,32)) { %info = �������������� ����� ���� ��� ������� ns ghost $crlf $+ ����� ��������� �������� $true � $false | %def = $true }
    if ($istok(nickidentstring,$1,32)) { %info = ������, ������� ������ ����� ����������� ���� ������ | %def = This nickname is registered and protected. If it is your }
    if ($istok(nickregisterstring,$1,32)) { %info = ������, ������� ������ ����� ���������� ����������� | %def = This nick is not registered, if you intend to use it in the future }
    if (!%info) %info = �������� ���� $1 | if (!%def) %def = $null
    var %tmp = $input(%info,eyq,��������� ���� $network,$iif(%pref,%pref,%def))
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
    if ($istok(password,$2,32)) { %info = ������ �� $1 � ���� $network | %def = $nickget($1,password) | %ishide = $false }
    if (!%info) %info = ���� $2 �� $1 � ���� $network | if (!%def) %def = $null
    var %tmp = $input(%info,eyq $+ $iif(%ishide,p),��������� ���� $1 � ���� $network,$iif(%pref,%pref,%def))
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
    if ($istok(pass.email,$1,32)) { %info = �����, ������������ ��� ����� ������� | %def = nomail }
    if (!%info) %info = �������� ���� $1 | if (!%def) %def = $null
    var %tmp = $input(%info,eyq,��������� ���� $network,$iif(%pref,%pref,%def))
    if (%tmp) { writeini strings/user.ini user $1 %tmp | set $chr(37) $+ [ $1 ] %tmp }
    return
  }
  writeini strings/setup.ini user $1 $2- | set $chr(37) $+ [ $1 ] %tmp
}

userget {
  return $readini(strings/setup.ini,user,$1)
}

stdget {
  if ($1- == str.away.nochange) return 10������� ����� ��������� � �������
  if ($1- == str.away.msg) return 10�� $ $+ + $ $+ sex(��,��,��,��) $ $+ + 3. �������:10 $ $+ 1-
  if ($1- == str.away.return) return 10������ $ $+ + $ $+ sex(��,���,���,���) $ $+ + . 3������ $ $+ + $ $+ sex(,�,�,�) $+ 10 $ $+ duration($awaytime,3) 3����� �� �������:10 $ $+ awaymsg
  if ($1- == str.away.change) return 10������ $ $+ + $ $+ sex(,�,�,�) $ $+ + 3 $ $+ duration($awaytime,3) 10����� �� �������:3 $ $+ awaymsg $ $+ + 10. ������ �� $ $+ + $ $+ sex(��,��,��,��) �� �������:3 $ $+ 1-
  if ($1- == str.away.repeat) return 10�� �����. 3�� $ $+ + $ $+ sex(��,��,��,��) $ $+ + 10 $ $+ duration($awaytime,3) 3����� �� �������:10 $ $+ awaymsg
  if ($1- == nums.away.rep.mins) return 40
  if ($1- == nums.menulist.len) return 15
  if ($1- == str.status.click) return ������ $ $+ + % $+ colors.server $ $+ server ��������� � ���� $ $+ + % $+ colors.server $ $+ network
  if ($1- == str.servecho) return $ $+ network $ $+ + 9: ������ $ $+ 1 $ $+ + 9| $ $+ 2-
  if ($1- == str.finger.ans) return ������� �� ������!
  if ($1- == str.quit.mes) return $ $+ iif($network == gamenavigator,http://magic.gamenavigator.ru,Magic Script % $+ str.version �� % $+ str.vdate $ $+ + )
  if ($1- == str.nickins) return 4 $ $+ + % $+ nick $ $+ + 3, % $+ mes
  if ($1- == user.timestamp) return $chr(91) HH:nn:ss $chr(93)
}

chanset {
  var %info, %ishide, %def, %pref
  if ($3 == $null) {
    if ($istok(password,$2,32)) { %info = ������ �� $1 � ���� $network | %def = $changet($1,$2) | %ishide = $false }
    if (!%info) %info = ���� $2 �� $1 � ���� $network | if (!%def) %def = $null
    var %tmp = $input(%info,eyq $+ $iif(%ishide,p),��������� ������  $1 � ���� $network,$iif(%pref,%pref,%def))
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
