
alias logview {
  logview.check
  window -ael25k0z @Logview /logviewer.help
  logviewer.help
}

alias logview.fill {
  ;format: [-ns<d/n[+/-]>] [mask]
  var %flags, %sort, %mask, %file, %i = 1, %time = $ctime
  if ($left($1,1) == -) { set %flags $right($1,-1) | set %mask $2 $+ *.log | if (s isin $1) { set %sort $mid($1,$calc($pos($1,s,1) + 1),2) | set %flags $remove(%flags,s $+ %sort) } }
  else { set %mask $1 $+ *.log | set %sort n+ }
  echo %logview.info -t @logview Flags: $+ %logview.hl %flags Sort by: $+ %logview.hl %sort Mask: $+ %logview.hl %mask
  var  %n = $findfile($logdir,%mask,0,2)
  if (n isin %flags) %n = %n - $findfile($logdir,#* $+ %mask,0,2)
  if ($findfile($logdir,*.log,0,2) == 0) { echo %logview.info @logview ����� � ����� ����! ��������� ��������� mirc! | halt }
  if (%n == 0) { echo %logview.info @logview �� ������ ������� ������ �� �������! | halt }
  echo %logview.info @logview -  
  echo %logview.info @logview Files: $+ %logview.hl $findfile($logdir,%mask,0,2) Output: $+ %logview.hl %n
  clear -l @Logview
  while (%i <= $findfile($logdir,%mask,0,2)) {
    %file = $nopath($findfile($logdir,%mask,%i,2))
    if (#* iswm %file) { 
      if (n !isin %flags) aline  -l %logview.chan @Logview %file 
    }
    else aline  -l %logview.nick @Logview %file
    inc %i
  }
  echo %logview.info @logview ����� ������ ��������. ��������� $+ %logview.hl $calc($ctime - %time) ������(�).
  if ((%sort) && (%sort != n+)) logview.sort %sort
}

alias logview.sort {
  var %i = 1, %m, %mn, %linei, %linej, %n = $line(@logview,0,1), %date, %time = $ctime, %name
  if (!$istok(d+ d- n+ n-,$1,32)) { echo %logview.info @Logview ����������� �������� $+ %logview.hl $1 | halt }
  echo %logview.info @logview -  
  echo %logview.info -t @Logview ����������: $1  $+ %logview.hl $+ %n �����(��).
  if (%n >= 60) echo %logview.info @Logview ����������, ���������, ���������� ����� ������ ��������� �����, ��������� ���� �������� �� �����.
  while (%i <= %n) {
    if ($istok(d+ d-,$1,32)) %m = $file($logdir $+ $line(@Logview,%i,1)).mtime
    if ($istok(n+ n-,$1,32)) %m = $line(@Logview,%i,1)
    %mn = %i
    %j = $calc(%i +1)
    while (%j <= %n) {
      %date = $file($logdir $+ $line(@Logview,%j,1)).mtime
      %name = $line(@Logview,%j,1)
      if ($1 == d-) { if (%date < %m) { %m = %date | %mn = %j } }
      if ($1 == d+) { if (%date > %m) { %m = %date | %mn = %j  } }
      if ($1 == n+) { if (%name < %m) { %m = %name | %mn = %j  } }
      if ($1 == n-) { if (%name > %m) { %m = %name | %mn = %j  } }
      inc %j
    }
    if (%mn != %i) {
      %linei = $line(@Logview,%i,1)
      %linej = $line(@Logview,%mn,1)
      rline -l %logview. [ $+ [ $iif(#* iswm %linej,chan,nick) ] ] @Logview %i %linej
      rline -l %logview. [ $+ [ $iif(#* iswm %linei,chan,nick) ] ] @Logview %mn %linei
    }
    inc %i
  }
  echo %logview.info @logview ���������� ���������. ������: $+ %logview.hl $calc($ctime - %time) ������(�)
  halt
}

alias logview.filter {
  echo %logview.info -t @logview ������ $line(@logview,0,1) �����(��)
  var %i = 1, %time = $ctime
  if ($1 == s) {
    echo %logview.info @logview �������� $+ %logview.hl $iif($sline(@logview,0),$ifmatch,0) $iif($2 == -,��������� $+ %logview.hl $calc($line(@logview,0,1) - $sline(@logview,0)) ����(��))
    while (%i <= $line(@logview,0,1)) {
      if (($2 == +) && (!$line(@logview,%i,1).state)) { dline -l @logview %i | dec %i }
      if (($2 == -) && ($line(@logview,%i,1).state)) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  if ($1 == m) {
    echo %logview.info @logview ������ $+ %logview.hl $line(@logview,0,1) ����� $+ %logview.hl $3-
    while (%i <= $line(@logview,0,1)) {
      if (($2 == +) && ($3- !iswm $line(@logview,%i,1))) { dline -l @logview %i | dec %i }
      if (($2 == -) && ($3- iswm $line(@logview,%i,1))) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  if ($1 == f) {
    echo %logview.info @logview ������ $+ %logview.hl $line(@logview,0,1) ����� � ������ ������ $+ %logview.hl $2-
    while (%i <= $line(@logview,0,1)) {
      if (!$read($logdir $+ $line(@logview,%i,1),w,* $+ $2- $+ *,1)) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  echo %logview.info @logview ���������� ���������. ��������� $+ %logview.hl $line(@logview,0,1) ����(��). ��������� $+ %logview.hl $calc($ctime - %time) ������(�).
}
alias logview.fileinfo { return $input(����: $1 $+ $crlf $+ �����: $lines($logdir $+ $1) $+ $crlf $+ ������: $asctime($file($logdir $+ $1).ctime) $+ $crlf $+ ������: $asctime($file($logdir $+ $1).mtime),oi,���������� � �����) }
alias logview.play {
  var %flag, %file, %mod, %fn
  echo -a $1-
  if ($left($1,1) == -) { set %flag $right($1,-1) | set %file $logdir $+ $2 | set %fn $2 | set %mod $iif(%flag == m,* $+ $3- $+ *,$3-) }
  else { set %file $logdir $+ $1 | set %fn $1 }
  var %lines = $lines(%file), %i = 1, %j = 0, %n = 0
  ;clear @logview
  echo %logview.info -e @logview ���� %file (����� %lines $+ ): $iif($2,%flag %mod)
  if ($fopen(logview)) .fclose logview
  if (!$exists(" $+ %file $+ ")) { echo %logview.info -e @logview ������: ���� �� ����������. | return }
  .fopen logview " $+ %file $+ "
  while (!$feof) {
    set %string $fread(logview)
    if (!%flag) {
      echo @logview < $+ %i $+ > %string | inc %j
    }
    if ((%flag == s) && (%i isnum %mod)) {
      echo @logview < $+ %i $+ > %string | inc %j
    }
    if ((%flag == m) && (%mod iswm %string)) {
      echo @logview < $+ %i $+ > %string | inc %j
    }
    inc %i
    if (%j > %logview.maxlines) {
      .fclose logview
      echo %logview.info @logview -
      echo %logview.info @logview ����� �������������. �������� %j �����.
      echo %logview.info @logview ��� ����������� �������� � ���� "����������". 
      echo %logview.info @logview -
      %logview.continue = logview.play -s %fn %i $+ - 
      return
    }
  }
  .fclose logview
  echo %logview.info -e @logview ����� �������. �������� %j �����.
}
alias logview.continue {
  var %cmd
  %cmd = %logview.continue
  unset %logview.continue
  %cmd
}

alias logview.logdelete {
  if (!%logview.delete) { if (!$input(������� $iif($sline(@logview,0) > 1,$ifmatch �����(��)?,����? $+ $crlf $+ $sline(@logview,1)),yq,�������� �����)) return }
  echo %logview.info -e @logview �������� $sline(@logview,0) �����(��).
  while ($sline(@logview,0) > 0) {
    remove $iif(!%logview.deltrash,-b) " $+ $logdir $+ $sline(@logview,1) $+ "
    dline -l @logview $sline(@logview,1).ln
  }
  echo %logview.info -e @logview �������� ���������. $iif(!%logview.deltrash,�� ������ ������������ �������� ����� �� �������.)
}


menu menubar {
  .-
  .����
  ..�������������:logview
  ..������:run strings/logviewer.versions.txt
  ..���������:logview.setup
  .-
}

on *:load:{
  logview.check
  echo $iif(%logview.info isnum 0-15,$ifmatch) -a Magic Script Log Viewer loaded!
}

alias logview.check {
  var %tmp, %info, %nick, %chan, %hl, %i = 0
  var %theme = $readini(mirc.ini,text,theme)
  while (%i < $ini(mirc.ini,colors,0)) {
    set %tmp $readini(mirc.ini,colors,n $+ %i)
    if ($gettok(%tmp,1,44) == %theme) { break }
    inc %i
  }
  %logview.version = 0.8.9
  if (%logview.info !isnum 0-15) {
    if (!%logview.info) set %logview.info $iif(%colors.info isnum 0-15,$ifmatch,$str(0,$calc(2 - $len($gettok(%tmp,6,44)))) $+ $gettok(%tmp,6,44))
    else %info = %logview.info
  }
  if (%logview.nick !isnum 0-15) {
    if (!%logview.nick) set %logview.nick $iif(%colors.nick isnum 0-15,$ifmatch,$str(0,$calc(2 - $len($gettok(%tmp,12,44)))) $+ $gettok(%tmp,12,44))
    else %nick = %logview.nick
  }
  if (%logview.chan !isnum 0-15) {
    if (!%logview.chan) set %logview.chan $iif(%colors.chan isnum 0-15,$ifmatch,$str(0,$calc(2 - $len($gettok(%tmp,3,44)))) $+ $gettok(%tmp,3,44))
    else %chan = %logview.chan
  }
  if (%logview.hl !isnum 0-15) {
    if (!%logview.hl) set %logview.hl $iif(%colors.highlight isnum 0-15,$ifmatch,$str(0,$calc(2 - $len($gettok(%tmp,5,44)))) $+ $gettok(%tmp,5,44))
    else %hl = %logview.hl
  }
  if ($numtok(%info %nick %chan %hl,32)) echo -ast ������ Magic Logviewer ������������ ������� ���������� �����. � ������ �� ���������� �������� ������ � ������.
  if (%info) echo -ast %colors.info �������� ��������  $+ %info $+  �������� ��� �������� �� ����� 0-15 �������� /set $chr(37) $+ logview.info �����
  if (%nick) echo -ast %colors.nick �������� ��������  $+ %nick $+  �������� ��� �������� �� ����� 0-15 �������� /set $chr(37) $+ logview.nick �����
  if (%chan) echo -ast %colors.chan �������� ��������  $+ %chan $+  �������� ��� �������� �� ����� 0-15 �������� /set $chr(37) $+ logview.chan �����
  if (%hl) echo -ast %colors.hl �������� ��������  $+ %hl $+  �������� ��� �������� �� ����� 0-15 �������� /set $chr(37) $+ logview.hl �����
  if ($numtok(%info %nick %chan %hl,32)) echo -ast ���� �� �������, ��� ������� ������ ������ � ���� ���������� �� ����������, ������ ������ ������� /logviewer.reset, ������� ��������� ����� �� ����� �������� ����� �� ���������.
}

alias logviewer.reset {
  unset %logview.info
  unset %logview.chan
  unset %logview.nick
  unset %logview.hl
  logview.check
}

menu @logview {
  dclick:{ %logview.mask = $$input(������� �����,ey,����� �� �����,%logview.mask) | logview.play -m $$sline($active,1) %logview.mask }
  $iif(%logview.continue,����������):logview.continue
  -
  ���������:{ if ($dialog(logview.prefs)) dialog -v logview.prefs | else dialog -m logview.prefs prefs_logviewer }
  �������� ���� ������:clear @logview
  ����������� ������ �����
  .������:logview.fill
  .������:logview.fill $chr(35)
  .�������:logview.fill -n
  .������ �� �����:{ %logview.outmask = $$input(������� ����� ������: $crlf * - ����� ���������� �������� $crlf ? - ���� ����� ������ $crlf $+ � ����� ����� ��������� *.log,eyq,����� ������ �����,%logview.outmask) | logview.fill %logview.outmask }
  -
  ����������
  .�� ����:logview.sort d-
  .�� ���� �������:logview.sort d+
  .�� �����:logview.sort n+
  .�� ����� �������:logview.sort n-
  ������
  .������� �� �����:{ %logview.filemask = $$input(������� �����,ey,������ �����,%logview.filemask) | logview.filter m - %logview.filemask }
  .�������� �� �����:{ %logview.filemask = $$input(������� �����,ey,������ �����,%logview.filemask) | logview.filter m + %logview.filemask }
  .������� ����������:logview.filter s -
  .�������� ����������:logview.filter s +
  .����� ������ � �����:{ %logview.searchmask = $$input(������� �����,ey,������ �����,%logview.searchmask) | logview.filter f %logview.searchmask }
  �����
  .$iif($1,������� ���������):logview.play $$1
  .$iif($1,������� ������):logview.play -s $$1 $input(������� ������ �����,ey,���������� �����,1- $+ $lines($logdir $+ $1))
  .$iif($1,������� �� �����):{ %logview.mask = $$input(������� �����,ey,����� �� �����,%logview.mask) | logview.play -m $$1 %logview.mask }
  $iif($1,���������� � $ifmatch):logview.fileinfo $1
  -
  �������� ������:logview.logdelete
  -
  ������� ����� � ������:run $logdir
  ������� ����:run " $+ $logdir $+ $$1 $+ "
}

alias logviewer.help {
  var %ec echo %logview.info -h @Logview 
  if ($1 == $null) {
    %ec -
    %ec ���������� � Magic Logviewer %logview.version
    %ec ������ ��������� ������������� ����� ����� � ���� mIRC �������� ������������ �������������� � �����.
    %ec ��� �������� �������������� ���������� ������������ ������ ���������� �����:
    %ec $chr(9) $chr(37) $+ logview.nick $chr(9) ( $+ %logview.nick $+ ) $chr(9) - $chr(9) ���� ������ ��������
    %ec $chr(9) $chr(37) $+ logview.chan $chr(9) ( $+ %logview.chan $+ ) $chr(9) - $chr(9) ���� ������ �������
    %ec $chr(9) $chr(37) $+ logview.info $chr(9) ( $+ %logview.info $+ ) $chr(9) - $chr(9) ���� �������������� �����
    %ec $chr(9) $chr(37) $+ logview.hl $chr(9) ( $+ %logview.hl $+ ) $chr(9) - $chr(9) ���� ���������� ����������
    %ec � ������� ������� ������� �������� �����, ������� ��� ����� �������� /set $chr(37) $+ logview.nick <�����>
    %ec <�����> ������ ������ � �������� 0-15 � �������� ������� ����� IRC - ����������� �� ������ ����� ����� Ctrl+K
    %ec ��� �������������� ������ ����������� ����� ���������� ������������ ���������� ������ �����, �������� 04
    echo @Logview 
    %ec ��� ������ ������ ���������� ����������� ������ ����� (�� ����, ����������� ������ �������� �����)
    %ec �������� ��������:
    %ec $chr(9) ������ $chr(9) - $chr(9) ����� �������� ��� ����� ����� (*.log)
    %ec $chr(9) ������ $chr(9) - $chr(9) ����� �������� ��� ����� ����� ������� (#*.log)
    %ec $chr(9) ������� $chr(9) - $chr(9) ����� �������� ��� ����� ����� ��������
    %ec $chr(9) �� ����� $chr(9) - $chr(9) ����� �������� ��� ����� �����, ��������������� ��������� �������
    %ec ��������: a* ������� ��� ���� �������� � ������, ������������� �� a, #*b ������� ��� ���� �������, ���������� � ����� ����� b
    echo @Logview 
    %ec ����������� ������ ����� ����� ������������� �� ����� � ���� � ������������ ��� ��������� �������
    echo @Logview 
    %ec ������ ����� ����� �������������:
    %ec $chr(9) �� ����� $chr(9) - $chr(9) ����� �������/��������� ����� �����, ��������������� �������� �����
    %ec $chr(9) �� ���������� $chr(9) $chr(9) - $chr(9) ����� �������/��������� ����� �����, ���������� ������ (shift+mclick,ctrl+mclick)
    %ec $chr(9) �� ������$chr(9) - $chr(9) ����� ��������� ����� �����, ���������� � ���� ���� �� ���� ������, ��������������� ����� (����� ��������)
    echo @Logview 
    %ec ������� ���� ���� ����� ����� ���������:
    %ec $chr(9) ��������� $chr(9) - $chr(9) ����� ������� ���� ����
    %ec $chr(9) ������ $chr(9) - $chr(9) ����� ������ ������, ������� � �������� ��������� (<������>-<�����>); �� ��������� �������� ��������� ���������� �������� (1-���������� �����)
    %ec $chr(9) �� ����� $chr(9) - $chr(9) ����� ������ ������, ��������������� �������� �����
    %ec ��� �������� ������ ������ ������ ������������ ����� �������.
    return
  }
  if ($1 == menu) {
    %ec -
    %ec ��������� Magic Logviewer
    %ec ����� ������ ������ ���� ������� �� 0 �� 15, ���������� �� ������� ������ ����� �� ������� ctrl+k.
    %ec ��� ��� ���������� ������������� ������������ �����, ����������� 0 ����� ������������� ��������� ���������.
    %ec -
    %ec ����� ��������� ������������� �������� � ��������� �������� � ������� (�� �������������, ��� ��� �������������� ������ � ���� ������ ������ �����������).
    %ec ���� ��� ������ ����� ����� ����������� ������ �������, ����� ��������������� � � ������ ����� ���������� ������� ����������� ������.
    echo %logview.hl @Logview ���� ������ ����������� ��������� �������� ����� ������ �� �������. ���������� ������ �� ��������� ������� ������� ��������� ������ ��� ������.
    return
  }
  %ec -
  %ec ����� $1 �����������.
}

dialog prefs_logviewer {
  title "��������� ��������������"
  size -1 -1 150 68
  option dbu
  icon grafix\, 0
  button "���������", 1, 3 54 48 12, disable
  button "�������", 2, 51 54 48 12
  button "�������", 3, 99 54 48 12, ok
  box "�����", 4, 1 1 50 50
  text "����������", 5, 3 9 32 8
  text "���������", 6, 3 19 32 8
  text "����", 7, 3 39 32 8
  text "������", 8, 3 29 32 8
  edit "", 9, 37 8 10 10
  edit "", 10, 37 18 10 10
  edit "", 11, 37 28 10 10
  edit "", 12, 37 38 10 10
  check "������������ ��������", 13, 65 8 80 10
  check "������� � �������", 14, 65 18 80 10
  edit "", 15, 52 31 20 10
  text "���������� ���������� ����� �� ���� �����", 16, 74 29 69 15
}

on *:dialog:logview.prefs:*:*: {
  if ($devent == init) {
    did -a $dname 9 %logview.info
    did -a $dname 10 %logview.hl
    did -a $dname 11 %logview.chan
    did -a $dname 12 %logview.nick
    if (!%logview.delete) did -c $dname 13
    if (!%logview.deltrash) did -c $dname 14
    did -a $dname 15 $iif(%logview.maxlines,$ifmatch,6000)
    return
  }
  if ($devent == edit) {
    did -e $dname 1
  }
  if ($devent == sclick) {
    if ($did == 2) logviewer.help menu
    if ($istok(13 14,$did,32)) did -e $dname 1
    if ($did == 1) {
      if ($did(9) isnum 0-15) %logview.info = $iif($len($did(9)) == 1,0 $+ $did(9),$did(9))
      if ($did(10) isnum 0-15) %logview.hl = $iif($len($did(10)) == 1,0 $+ $did(10),$did(10))
      if ($did(11) isnum 0-15) %logview.chan = $iif($len($did(11)) == 1,0 $+ $did(11),$did(11))
      if ($did(12) isnum 0-15) %logview.nick = $iif($len($did(12)) == 1,0 $+ $did(12),$did(12))
      if ($did(15) > 0) %logview.maxlines = $did(15)
      if ($did(13)) %logview.delete = $false
      if ($did(14)) %logview.deltrash = $false
      did -b $dname 1
    }
  }
}
