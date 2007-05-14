;###################prefs########################
ctcp.finger.ans { return [ [ %str.finger.ans ] ] }
quit.msg { return [ [ %str.quit.mes ] ] }

;##################options#######################
;###################mouse########################
click.status { echo %colors.system -t [ [ %str.status.click ] ] }
click.query { whois $1 }
click.channel { channel }
click.nick { nick.insert $1- }
click.notify { whois $1 }
click.mes { whois $1 }

;##################standarts#####################
whois { .raw whois $$1- $iif((%prefs.whois.show.idle == 1) && (!$2),$$1) }
mcom {
  if ($scon(0) == 1) { $1 $2- | return }
  scid -at1 $1 $2-
}
maway mcom away $1-
mquit mcom quit $1-
mnick mcom nick $1
away { 
  var %state, %i = 1, %colorchans, %ncolorchans, %awaymes, %color, %awaycmd, %message

  ;���������� ��������� �������
  if ((!$away) && ($1)) %state = go.away
  if (($away) && ($1)) %state = ch.away
  if ((!$away) && (!$1)) %state = no.away
  if (($away) && (!$1)) %state = re.away
  if ((%state == ch.away) && ($1- == $awaymsg)) %state = nc.away

  ;�������� ������� �������
  if (%prefs.away.mesmode) {
    while (%i <= $chan(0)) {
      %color = $changet($chan(%i),colors)
      if ((%color == 1) || (((%color == 2) || (%color == $null)) && (c !isincs $chan(%i).mode))) {
        if (!$changet($chan(%i),aways)) %colorchans = $addtok(%colorchans,$chan(%i),44)
      }
      else { if (!$changet($chan(%i),aways)) %ncolorchans = $addtok(%ncolorchans,$chan(%i),44) }
      inc %i
    }
  }

  ;������
  if (%state == go.away) {
    if (%oldnick [ $+ [ $cid ] ] != $me) {
      if (%prefs.away.nickmode == 1) { %oldnick [ $+ [ $cid ] ] = $me | if (%str.away.nick != $me) nick $ifmatch }
      if (%prefs.away.nickmode == 3) { %oldnick [ $+ [ $cid ] ] = $me | if (%oldnick [ $+ [ $cid ] ] $+ %str.away.end != $me) nick $ifmatch }
      if (%prefs.away.nickmode == 2) { %oldnick [ $+ [ $cid ] ] = $me | if (%str.away.pre $+ %oldnick [ $+ [ $cid ] ] != $me) nick $ifmatch }
      if (%prefs.away.nickmode == 4) { %oldnick [ $+ [ $cid ] ] = $me | if (%str.away.pre $+ %oldnick [ $+ [ $cid ] ]  $+ %str.away.end != $me) nick $ifmatch }
    }
    if (%prefs.away.mes) {
      if ($istok(notice msg,%prefs.away.mesmode,32)) %awaymes = [ [ %str.away.msg ] ]
      if (%prefs.away.mesmode == describe) %awaymes = ACTION [ [ %str.away.msg ] ] $+ 
      if (%prefs.away.mesmode) { 
        %i = 1
        %message = [ [ %str.away.msg ] ]
        while (%i <= $chan(0)) {
          if ($istok(%colorchans,$chan(%i),44)) echo %colors.info -t $chan(%i) %message
          else echo %colors.info -t $chan(%i) $strip(%message)
          inc %i
        }
      }
    }
    .timeraway $+ $cid 0 $calc(60 * %nums.away.rep.mins) away.rep.msg
  }

  ;������������
  if (%state == re.away) {
    if (%prefs.away.nickmode && (%oldnick [ $+ [ $cid ] ] ) && (%oldnick [ $+ [ $cid ] ] != $me)) { nick %oldnick [ $+ [ $cid ] ] | unset %oldnick [ $+ [ $cid ] ] }
    if (%prefs.away.mes) {
      if ($istok(notice msg,%prefs.away.mesmode,32)) %awaymes = [ [ %str.away.return ] ]
      if (%prefs.away.mesmode == describe) %awaymes = ACTION [ [ %str.away.return ] ] $+ 
      if (%prefs.away.mesmode) { 
        %i = 1
        %message = [ [ %str.away.return ] ]
        while (%i <= $chan(0)) {
          if ($istok(%colorchans,$chan(%i),44)) echo %colors.info -t $chan(%i) %message
          else echo %colors.info -t $chan(%i) $strip(%message)
          inc %i
        }
      }
    }
    .timeraway $+ $cid off
  }

  ;������ �������
  if (%state == ch.away) {
    if (%prefs.away.mes) {
      if ($istok(notice msg,%awaycmd,32)) %awaymes = [ [ %str.away.change ] ]
      if (%prefs.away.mesmode == describe) %awaymes = ACTION [ [ %str.away.change ] ] $+ 
      if (%prefs.away.mesmode) { 
        %i = 1
        %message = [ [ %str.away.change ] ]
        while (%i <= $chan(0)) {
          if ($istok(%colorchans,$chan(%i),44)) echo %colors.info -t $chan(%i) %message
          else echo %colors.info -t $chan(%i) $strip(%message)
          inc %i
        }
      }
    }
    .timeraway $+ $cid 0 $calc(60 * %nums.away.rep.mins) away.rep.msg
  }

  if (%state == no.away) {
  }
  if (%state == nc.away) {
    echo %colors.info -at $network $+ : %str.away.nochange
    return
  }

  ;��������
  if (%prefs.away.mes) {
    if (%prefs.away.mesmode)  {
      if ($istok(describe msg,%prefs.away.mesmode,32)) %awaycmd = .raw privmsg
      if (%prefs.away.mesmode == notice) %awaycmd = .raw NOTICE
    }
    if (%colorchans) %awaycmd %colorchans : $+ %awaymes
    if (%ncolorchans) %awaycmd %ncolorchans : $+ $strip(%awaymes)
  }
  ;������ �����
  .raw away : $+ $1-
}

away.rep.msg {
  if (!%prefs.away.mesmid || (!$away)) return
  if (%prefs.away.mes) return
  var %awaycmd = %prefs.away.mesmode , %i = 1, %colorchans, %ncolorchans, %awaymes, %color
  if (%awaycmd) {
    while (%i <= $chan(0)) {
      %color = $changet($chan(%i),colors)
      if ((%color == 1) || (((%color == 2) || (%color  == $null)) && (c !isincs $chan(%i).mode))) {
      if (!$changet($chan(%i),aways))  %colorchans = $addtok(%colorchans,$chan(%i),44) }
      else {  if (!$changet($chan(%i),aways))  %ncolorchans = $addtok(%ncolorchans,$chan(%i),44) }
      inc %i
    }
  }
  if ($istok(notice msg,%awaycmd,32)) %awaymes = [ [ %str.away.repeat ] ]
  if (%awaycmd == describe) %awaymes = ACTION [ [ %str.away.repeat ] ] $+ 
  if ($istok(describe msg,%awaycmd,32)) %awaycmd = .raw privmsg
  if (%awaycmd == notice) %awaycmd = .raw NOTICE

  if (%colorchans) %awaycmd %colorchans : $+ %awaymes
  if (%ncolorchans) %awaycmd %ncolorchans : $+ $strip(%awaymes)
  if ((%colorchans) || (%ncolorchans)) echo -a $iif(%colorchans %ncolorchans,10�� ���������� ��������:) $iif(%colorchans,� ������� �� %colorchans $+ 10) $iif(%ncolorchans,��� ������ �� %ncolorchans)
}

;####################help########################
key.layout {
  window -ak0z @���������
  clear @���������
  aline %colors.system @��������� F1 ������� ���� ������
  aline %colors.system @��������� F2
  aline %colors.system @��������� F3
  aline %colors.system @��������� F4
  aline %colors.system @��������� F5 ���������� ������
  aline %colors.system @��������� F6 ��������� �� ��� �������� ������
  aline %colors.system @��������� F7 �������� (���� ���������� �� ���������� ���)
  aline %colors.system @��������� F8 �������� �� ��� ������
  aline %colors.system @��������� F9
  aline %colors.system @��������� F10
  aline %colors.system @��������� F11
  aline %colors.system @��������� F12
  aline %colors.system @��������� -
  aline %colors.system @��������� Control+F1
  aline %colors.system @��������� Control+F2
  aline %colors.system @��������� Control+F3
  aline %colors.system @��������� Control+F4
  aline %colors.system @��������� Control+F5 ������ ����� ������ �����
  aline %colors.system @��������� Control+F6
  aline %colors.system @��������� Control+F7
  aline %colors.system @��������� Control+F8
  aline %colors.system @��������� Control+F9 ������� ������ �� �������
  aline %colors.system @��������� Control+F10 ������� ������ �� ����������
  aline %colors.system @��������� Control+F11
  aline %colors.system @��������� Control+F12
  aline %colors.system @��������� -
  aline %colors.system @��������� Shift+F1
  aline %colors.system @��������� Shift+F2
  aline %colors.system @��������� Shift+F3
  aline %colors.system @��������� Shift+F4
  aline %colors.system @��������� Shift+F5 ��������� ������ �������
  aline %colors.system @��������� Shift+F6 ��������� �� ��� �������� ������
  aline %colors.system @��������� Shift+F7 �������� �� �����
  aline %colors.system @��������� Shift+F8 �������� �� ��� ������
  aline %colors.system @��������� Shift+F9
  aline %colors.system @��������� Shift+F10
  aline %colors.system @��������� Shift+F11
  aline %colors.system @��������� Shift+F12
}

key.ascii {
  window -ak0z  @ASCII
  clear @ASCII
  var %i = 0,%str, %j = 1
  while (%i <= 255) {
    ;    %str = %str $chr(127) %i $+ $chr(9) $+ $chr( $+ $iif(!$istok(2 9 22 31,%i,32),%i) $+ ) $+ $chr(9)
    %str = %str  $+ %colors.info $+ $chr(127) $+  $str(0,$calc(4 - $len(%i))) $+ %i $iif(!$istok(0 2 3 9 15 22 31,%i,32), $+ %colors.highlight $+ $chr(%i) $+ , $+ %colors.info $+ -)
    if (%j = 8) { echo %colors.normal @ASCII %str  $+ %colors.info $+ $chr(127) | %str = $null | %j = 0 }
    inc %i | inc %j
  }
  if (%str) echo %colors.normal @ASCII %str
}
