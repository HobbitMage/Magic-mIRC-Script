menu status {
  $server
  .$style(2) ���������� $uptime(server,1):nill
  .���������� �������������:{ echo -s ������ ���������� ������������� | lusers }
  .������ �������:list
  .���������:{ echo -s ������ ��������� ������� | motd }
  .����� �� �������:{ echo -s ������ ������� �� ������� | time }
  �����������:runt strings/perform.txt
  -
}

menu query,nicklist {
  ����������
  .� ����:uwho $$1
  .$iif($address($$1,5),$ifmatch):clipboard $address($$1,5)
  .$iif($comchan($$1,0),$style(2) ����� ������� $chr(58) $ifmatch):nill
  .$iif($readini(strings/passes.ini,$1,names),�������� ���������):{ var %str = $readini(strings/passes.ini,$1,names) | var %num = $$input(�������� ����� ����������� ���������: $crlf $+ $replace(%str,$chr(1),$crlf),ye,��������� ���������,1) | %str = $puttok(%str,$$input(������� ����� ��������� � $1,ey,��������� ���������,$gettok(%str,%num,1)),%num,1) | writeini strings/passes.ini $1 names %str }
  .$iif(!$2,�������� ���������):{ var %txt = $input(������� ������ ��������� � $1,ey,���������� ���������) | if (%txt) { var %str = $readini(strings/passes.ini,$1,names) | if ($istok(%str,$1,1)) { %txt = $input(����� ��������� ��� ����,o,���� ���������) | halt } | %str = $addtok(%str,%txt,1) | writeini strings/passes.ini $1 names %str } }
  .$iif($readini(strings/passes.ini,$1,names),������� ���������):{ var %str = $readini(strings/passes.ini,$1,names) | var %num = $$input(�������� ����� ����������� ���������: $crlf $+ $replace(%str,$chr(1),$crlf),ye,�������� ���������,1) | var %txt = $$input(����� ������� ��������� $gettok(%str,%num,1)) $+ ?,%num,1),y,�������� ���������) | %str = $deltok(%str,%num,1) | writeini strings/passes.ini $1 names %str }
  ���:whois $$1
  �������:{ $netget(nickserv.call) ghost $$1 $nickget($1,password) | if (!$netget(fastghost)) .timer 1 1 nick $$1 }
  -
  $iif($active != $$1,������� ������):query $1
  $iif($menu == nicklist,���������):nick.insert $snicks
  ���������:msg $$1 $$?="��������� ��� $1 $+ :"
  �����:notice $$1 $$?="��������� ��� $1 $+ :"
  CTCP:ctcp $$1 $$?="��������� ��� $1 $+ :"
  CTCP:
  .Ping:ctcp $$1 ping
  .Time:ctcp $$1 time
  .Version:ctcp $$1 version
  .Finger:ctcp $$1 finger
  .-
  .$submenu($menulist($1,ctcp))
  .���������:runt strings/ctcp.txt
  DCC
  .������� ����:dcc send $$1
  .���:dcc chat $$1
  -
  ������� ��
  .$submenu($menulist($1,invite))
}

menu nicklist {
  -
  ��������
  .$iif(($me isop $chan) || ($me ishop $chan),���)
  ..�������:kick $chan $$1 $$input(� �����?,ey,������� ���� $nick � $chan,���)
  ..��������� ������� �� �����:kick $chan $$1 $read(strings/kick.txt)
  ..������
  ...$submenu($menulist($1,kick))
  .��� ����� ������
  ..����� ������ �� �������:$netget(chanserv.call) kick $chan $$1 $$input(� �����?,ey,������� ���� $nick � $chan,���)
  ..����� ������ �� ��������� �������:$netget(chanserv.call) kick $chan $$1 $read(strings/kick.txt)
  ..������
  ...$submenu($menulist($1,cskick))
  .$iif(($me isop $chan) || ($me ishop $chan),������):kick $chan $$1 ������� ����� ��� ��� �� $me
  .������� ��� ����� ������:$netget(chanserv.call) kick $chan $$1 ������� ����� ��� ��� �� $me
  .$iif($me isop $chan,���)
  ..�������:{ var %tmp = $input(������� �������,ey,������� �������,���) | mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 %tmp }
  ..��������� ������� �� �����:{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 $read(strings/kick.txt) }
  ..������
  ...$submenu($menulist($1,bankick))
  ..��� ����:{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* }
  .$iif($me isop $chan,������):{ mode # +bb $address($snick(#,1),0) $snick(#,1) $+ !*@*.* | kick $chan $$1 ������� ����� �� $me (��������� ������) }
  .-
  .$iif(($1 isop $chan) && ($me isop $chan),����) $iif(($1 !isop $chan) && ($me isop $chan),��) :mode $chan $iif($1 isop $chan,-,+) $+ ooo $$1-3
  .$iif(($1 isop $chan) && ($netget(cs.op)),����,��) ����� ������:$netget(chanserv.call) $iif($1 isop $chan,deop,op) $chan $$1
  .$iif(($1 ishop $chan) && (($me isop $chan) || ($me ishop $chan)),�����) $iif(($1 !ishop $chan) && (($me isop $chan) || ($me ishop $chan)),���) :mode $chan $iif($1 ishop $chan,-,+) $+ hhh $$1-3
  .$iif($netget(cs.hop),$iif($1 ishop $chan,�����,���) ����� ������):$netget(chanserv.call) $iif($1 ishop $chan,dehalfop,halfop) $chan $$1
  .$iif(($1 isvoice $chan) && (($me isop $chan) || ($me ishop $chan) || ($me == $1)),������) $iif(($1 !isvoice $chan) && (($me isop $chan) || ($me ishop $chan)),����) :mode $chan $iif($1 isvoice $chan,-,+) $+ vvv $$1-3
  .$iif($netget(cs.voice),$iif($1 isvoice $chan,������,����) ����� ������):$netget(chanserv.call) $iif($1 isvoice $chan,devoice,voice) $chan $$1
  .-
  .���������
  ..�������:{ runt strings/kick.txt }
}

menu query,nicklist {
  -
  �����
  .������ ���������:ignore -pcntikdu999 $address($$1,0)
  .������:ignore -pcntikd $address($$1,0)
  .�� �������:ignore -pntd $address($$1,0)
  .�� ������:ignore -nt $address($$1,0)
  .�� CTCP � DCC:ignore -td $address($$1,0)
  .�� �����:ignore -k $address($$1,0)
  ����� �����:ignore -r $address($$1,0)
  -
  ������
  .$iif($cnick($1).color != %colors.n.friend,�������� � ������):{ .cnick -ans3 $1 %colors.n.friend }
  .$iif($cnick($1).color == %colors.n.friend,������� �� ������):{ .cnick -r $1 }
  .-
  .$iif($cnick($1).color != %colors.n.enemy,�������� �� ������):{ .cnick -ans3 $1 %colors.n.enemy }
  .$iif($cnick($1).color == %colors.n.enemy,������� �� ������):{ .cnick -r $1 }
  -
}

menu status,channel,query,@������� {
  ������:
  .$iif($server,�����������,������������):$iif($server,quit,server)
  .-
  .$submenu($menulist($1,servers))
  .-
  -
  �:
  .$style(2) ��� $me $iif($usermode != +,$ifmatch):nill
  .$style(2) $date - $time:clipboard $date - $time
  .$iif($away,����������):clipboard $awaymsg
  .IP $ip :clipboard $ip
  -
  �����
  .$submenu($menulist($1,files))
  .����� mIRC:run .
  .-
  .�������������:runt strings/files.txt
  -
  $iif($script(logview.ini),����� � �����) :nill
  -
  ���� (����� $lines(strings/nicks.txt) $+ )
  .$submenu($menulist($1,nick))
  .������:$iif(%prefs.mserver.nick,mcom) nick $$?="����� ���"
  .-
  .�������������:runt strings/nicks.txt
  .$iif(!$read(strings/nicks.ini,w,$me),�������� �������):{ write strings/nicks.txt $me | if ($lines(strings/nicks.txt) = %files.join.num) { set %files.nick. [ $+ [ %files.nick.num ] ] $chan | inc %files.nick.num } }
  �������������
  .$iif((r !isin $usermode) && ($nickget($me,password)),� ������� �����):$netget(nickserv.call) identify $nickget($me,password)
  .$iif((r !isin $usermode) && ($nickget($me,password)),�����������):$netget(nickserv.call) register $nickget($me,password) $userget(pass.email)
  .$iif($nickget($me,password),�������/����������,����������) ������:nickset $me password
  Away
  .$iif($away,���� $duration($awaytime) ����� � �������� $+ $chr(58) $left($awaymsg,10) $+ $iif($len($awaymsg) > 10,...)):clipboard $awaymsg
  .$iif($away,$style(2)) ����:$iif(%prefs.mserver.away,mcom) away $$?="�������"
  .$iif($away,$style(2)) ���� �� �������
  ..$submenu($menulist($1,away))
  ..���� � $time:$iif(%prefs.mserver.away,mcom) away ���� $fulltime
  .$iif(!$away,$style(2)) ������� �������:$iif(%prefs.mserver.away,mcom) away $$input(������� ����� �������,ey,����� ������� ����������,$awaymsg)
  .$iif(!$away,$style(2)) ������� �������
  ..$submenu($menulist($1,away))
  .$iif(!$away,$style(2)) ���������:$iif(%prefs.mserver.away,mcom) away
  .$iif(!$away,$style(2)) ��������� ����:$iif(%prefs.mserver.away,mcom) raw away
  .-
  .�������������:runt strings/away.txt
  -
  ������
  .$submenu($menulist($1,join))
  .������:j $$?="�������� ������"
  .������ �������:list
  .-
  .�������������:runt strings/channels.txt
  .$iif($menu == channel,�������� �������) :{ write -s $+ $chan strings/channels.txt $chan | if ($lines(strings/channels.txt) = %files.join.num) { set %files.join. [ $+ [ %files.join.num ] ] $chan | inc %files.join.num } }
  $chan
  .$iif($me !ison $chan,����� �� �����):j $chan
  .$iif($me !isop $chan,��������� ��):$netget(chanserv.call) op $chan $me
  .$iif($me isop $chan,������ ��):$netget(chanserv.call) deop $chan $me
  .��������� �����:notice $chan $$?="���������"
  .-
  .����������:$netget(chanserv.call) info $chan all
  .���������
  ..����� ( $+ $iif($changet($chan,colors),$ifmatch,2) $+ ):{ chanset $chan colors $$input(������� ��������� ������: $crlf $+ 1 - ������ $crlf $+ 2 - �������� ������������ $crlf $+ 3 - �������,ey,��������� $chan,$iif($changet($chan,colors),$ifmatch,2)) }
  ..$iif($changet($chan,aways),��������,���������) ��������� �� �����:{ chanset $chan aways $iif($changet($chan,aways),0,1) }
  -
  �����
  .$submenu($menulist($1,quit))
  .������:$iif(%prefs.mserver.quit,mcom) quit $$?="��������� ������"
  .�������������:runt strings/quit.txt
  -
}

menu status,channel,nicklist,query {
  $iif($server,�������)
  .����
  ..�����������:{ var %pass = $input(������� ������ ��� $me,ey,����������� ����,$nickget($me,password)) | var %mail $input(������� ��� �������� �����,ye,����������� ����,$userget(pass.email)) | if (($netget(ns.reg.mail)) && (*@*.* !iswm %mail)) return $input(� ������ ���� ����������� ������������� �����,wo,����������� ���� ��������) | $netget(NickServ.call) register %pass %mail | if ($input(��������� ��� $me ������ %pass $+ ?,yq,�����������)) nickset $me password %pass }
  ..$iif($netget(ns.auth),����������� �����������):$netget(NickServ.call) auth $$input(������� ��� $+ $chr(44) ���������� �� �����,ey,������������� �����������)
  ..$iif($netget(ns.auth),��������� �������������):$netget(NickServ.call) sendauth
  ..�������������:$netget(NickServ.call) identify $$input(������� ������ �� $me,ey,�������������,$nickget($me,password))
  ..$iif($netget(ns.access),�����������������)
  ...������ �������:$netget(NickServ.call) access list
  ...�������� �����:$netget(NickServ.call) access add $input(������� �����. ����������� * � ? ��� �������� ����������/������ ������ �������,eo,���������� ����� �����������������,$ial($me).user $+ @ $+ $host)
  ...������ �����:$netget(NickServ.call) access del $input(������� �����. ����������� * � ? ��� �������� ����������/������ ������ �������,eo,���������� ����� �����������������,$ial($me).user $+ @ $+ $host)
  ..����� �����������:$netget(NickServ.call) drop $iif($netget(ns.drop.pass),$$input(������� ������ �� $me,ey,����� ����,$nickget($me,password)))
  ..-
  ..$iif(!$netget(ns.link.pass),������������):$netget(NickServ.call) link $$input(������� ����� ��� ��� ��������,ey,������� ���)
  ..$iif($netget(ns.link.pass),������������):{ var %nick = $$input(������� ��� ��� ��������,ey,������� ���) | var %pass = $$input(������� ������ �� ����,ey,������� ���,$nickget(%nick,password)) | $netget(NickServ.call) link %nick %pass }
  ..$iif($netget(ns.unlink.pass),�����������):{ var %nick = $input(������� ��� ��� ��� ������ ��������,ey,��������� ����� ����) | var %pass | if (%nick) %pass = $$input(������� ������ �� ����,ey,��������� ����� ����,$nickget(%nick,pass)) | $netget(NickServ.call) unlink %nick %pass }
  ..$iif(!$netget(ns.unlink.pass),�����������):$netget(NickServ.call) unlink $$input(������� ��� ��� ��� ������ ��������,ey,��������� ����� ����)
  ..������ ��������:$netget(NickServ.call) listlinks
  ..-
  ..���������
  ...������:{ var %newpass = $$Input(������� ����� ������,ye,����� ������,$nickget($me,password)) | if ($len(%newpass) <= 4) set %newpass $input(������� �������� ������,wo,������ �� �������) | $netget(NickServ.call) set password %newpass | if ($input(��������� ��� $me ������ %newpass $+ ?,yq,����� ������)) nickset $me password %newpass }
  ...����
  ....������:$netget(NickServ.call) help set language
  ....�������:$netget(NickServ.call) $iif(($$input(������� ����� �����,ey,���� ��������,1) isnum 1-11),set language $ifmatch)
  ...����:$netget(NickServ.call) set url $$input(������� ����� �����,ey,��� URL)
  ...�����:$netget(NickServ.call) set email $$input(������� �������� �����,ye,��� e-mail)
  ...$iif($netget(ns.set.info),����������):$netget(NickServ.call) set info $$input(������� �����,ey,���������� � ���)
  ...$iif($netget(ns.set.icqnumber),����� ICQ):$netget(NickServ.call) set icqnumber $$input(������� ����� ICQ,ey,����� ICQ)
  ...$iif($netget(ns.set.location),��������������):$netget(NickServ.call) set location $$input(������� ��������������,ey,���������� � ��������������)
  ...�������� ����
  ....�������� (60 ���):$netget(NickServ.call) set kill on
  ....���������� (20 ���):$netget(NickServ.call) set kill quick
  ....����������:$netget(NickServ.call) set kill immed
  ....���������:$netget(NickServ.call) set kill off
  ...$iif($netget(ns.set.secure),������)
  ....��������:$netget(NickServ.call) set secure on
  ....���������:$netget(NickServ.call) set secure off
  ...���������
  ....��������:$netget(NickServ.call) set private on
  ....���������:$netget(NickServ.call) set private off
  ...������
  ....����� ��������:$netget(NickServ.call) set hide email on
  ....����� �� ��������:$netget(NickServ.call) set hide email off
  ....$iif($netget(ns.set.hide.usermask),����� ��������):$netget(NickServ.call) set hide usermask on
  ....$iif($netget(ns.set.hide.usermask),����� �� ��������):$netget(NickServ.call) set hide usermask off
  ....����� ��������:$netget(NickServ.call) set hide quit on
  ....����� �� ��������:$netget(NickServ.call) set hide quit off
  ...$iif($netget(ns.set.timezone),������� ����):$netget(NickServ.call) set timezone $$input(������� ���� � ������� $crlf +H -H (+3 ����������) $crlf +H:mm (+3:00 ����������) $crlf XXX (GMT �� ��������),eqo,���������� ������� ����,+3)
  ...$iif($netget(ns.set.mainnick),�������� ���):$netget(NickServ.call) set mainnick $$input(������� �������� ���,eqo,��������� ��������� ����,$me)
  ...-
  ...$iif($netget(ns.unset),������)
  ....����:$netget(NickServ.call) unset url
  ....����������:$netget(NickServ.call) unset info
  ..$iif($netget(ns.ajoin),���������)
  ...�������� �����:$netget(NickServ.call) ajoin add $$input(������� �������� ������,eqo,���������� � ������ ����������,$chan)
  ...������ �����:$netget(NickServ.call) ajoin del $$input(������� �������� ������,eqo,������ �� ������ ����������,$chan)
  ...������:$netget(NickServ.call) ajoin list
  ...������:$netget(NickServ.call) ajoin now
  ..-
  ..������ ����
  ...����������� ���:{ var %nick = $$input(������� ���,ey,�������� ����,$gettok($snicks,1,44)) | var %pass = $$input(������ �� %nick,ey,�������� ����,$nickget(%nick,password)) | $netget(NickServ.call) recover %nick %pass }
  ...���������� ���:{ var %nick = $$input(������� ���,ey,������������ ����) | var %pass = $$input(������ �� %nick,ey,������������ ����,$nickget(%nick,password)) | $netget(NickServ.call) release %nick %pass }
  ...�������:{ var %nick = $$input(������� ���,ey,Ghost,$gettok($snicks,1,44)) | var %pass = $$input(������ �� %nick,ey,Ghost,$nickget(%nick,password)) | $netget(NickServ.call) ghost %nick %pass }
  ..-
  ..����������:$netget(NickServ.call) info $$input(������� ���,ey,���������� � ������������,$iif($chan,$gettok($snicks,1,44),$active)) $iif($input(������ ����������?,qy,������),all)
  ..������ �����������:$netget(NickServ.call) list $$input(������� ����� ������,ey,����� �������������,*@*)
  ..$iif($netget(ns.listemail),������ e-mail):$netget(NickServ.call) listemail $$input(������� ����� ������,ey,����� ������� �����,*@*)
  ..$iif($netget(ns.listchans),������ �������):$netget(NickServ.call) listchans
  ..������ �����:$netget(NickServ.call) status $$input(������� ������ ����� (�� 16) $crlf $+ 0 - ���� $crlf $+ 1 - �� ��������������� $crlf $+ 2 - ��������������� �� ������ $crlf $+ 3 - ��������������� �� ������,ey,�������� �����,$snicks)
  ..-
  ..$iif($netget(ns.help.simple),������,������ ������):$netget(NickServ.call) help
  ..$iif($netget(ns.help.simple),������ ������):$netget(NickServ.call) help commands
  ..���������:$netget(NickServ.call) help $$input(������� ������� $+ $chr(44) �� ������� ��������� ������,ey,������ �� �������)
  .������
  ..�����������:{ var %chan = $$input(������� �������� ������,ey,����������� ������,$chan) | var %pass = $$input(������� ������ �� %chan,ey,����������� ������,$changet(%chan,password)) | $netget(ChanServ.call) register %chan %pass $$input(������� �������� ������,ey,����������� ������) | chanset %chan password %pass }
  ..�������������:{ var %chan = $$input(������� �������� ������,ey,������������� �� ������,$chan) | var %pass = $$input(������� ������ �� %chan,ey,������������� �� ������,$changet(%chan,password)) | $netget(ChanServ.call) identify %chan %pass }
  ..�����:{ var %chan = $$input(������� �������� ������,ey,����� ������,$chan) | $netget(ChanServ.call) drop %chan }
  ..���������
  ...��������:{ var %chan = $$input(������� �������� ������,ey,��������� ���������,$chan) | var %nick = $$input(������� ��� ���������,ey,��������� ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) set %chan founder %nick }
  ...��������:{ var %chan = $$input(������� �������� ������,ey,��������� ���������,$chan) | var %nick = $$input(������� ��� ���������,ey,��������� ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) set %chan successor %nick }
  ...������:{ var %chan = $$input(������� �������� ������,ey,��������� ������,$chan) | var %pass = $$input(������� ������ ��� %chan,ey,��������� ������,$changet(%chan,password)) | $netget(ChanServ.call) set %chan password %pass | chanset %chan password %pass }
  ...��������:{ var %chan = $$input(������� �������� ������,ey,�������� ������,$chan) | var %desc = $$input(������� �������� ������,ey,�������� ������) | $netget(ChanServ.call) set %chan desc %desc }
  ...���������:{ var %chan = $$input(������� �������� ������,ey,��������� ������,$chan) | var %url = $$input(������� �������� ������,ey,��������� ������) | $netget(ChanServ.call) set %chan url %url }
  ...�����:{ var %chan = $$input(������� �������� ������,ey,��������� �����,$chan) | var %mail = $$input(������� �������� �����,ey,��������� �����,) | $netget(ChanServ.call) set %chan email %mail }
  ...�����������:{ var %chan = $$input(������� �������� ������,ey,��������� �����������,$chan) | var %msg = $$input(������� �����������,ey,��������� �����������,) | $netget(ChanServ.call) set %chan entrymsg %msg }
  ...$iif($netget(cs.set.topic),�����):{ var %chan = $$input(������� �������� ������,ey,��������� ������,$chan) | var %text = $$input(������� �����,ey,��������� ������,$chan(#).topic) | $netget(ChanServ.call) set %chan topic %text }
  ...�������� ������:{ var %chan = $$input(������� �������� ������,ey,�������� ������,$chan) | var %mode = $$input(������� ON/OFF,ey,�������� ������,off) | $netget(ChanServ.call) set %chan keeptopic %mode }
  ...������ ������:{ var %chan = $$input(������� �������� ������,ey,������ ������,$chan) | var %mode = $$input(������� ON/OFF,ey,������ ������,OFF) | $netget(ChanServ.call) set %chan topiclock %mode }
  ...������ �������:{ var %chan = $$input(������� �������� ������,ey,������ �������,$chan) | var %mode = $$input(������� ���������� �����,ey,������ �������,+nt) | $netget(ChanServ.call) set %chan mlock %mode }
  ...�����������:{ var %chan = $$input(������� �������� ������,ey,��������� �����,$chan) | var %mode = $$input(������� ON/OFF,ey,��������� �����,OFF) | $netget(ChanServ.call) set %chan private %mode }
  ...�����������:{ var %chan = $$input(������� �������� ������,ey,������������ �����,$chan) | var %mode = $$input(������� ON/OFF,ey,������������ �����,OFF) | $netget(ChanServ.call) set %chan RESTRICTED %mode }
  ...$iif($netget(cs.set.secure),������):{ var %chan = $$input(������� �������� ������,ey,���������� �����,$chan) | var %mode = $$input(������� ON/OFF,ey,���������� �����,OFF) | $netget(ChanServ.call) set %chan secure %mode }
  ...������ ����������:{ var %chan = $$input(������� �������� ������,ey,������ ����������,$chan) | var %mode = $$input(������� ON/OFF,ey,������ ����������,OFF) | $netget(ChanServ.call) set %chan secureops %mode }
  ...��������� ���������:{ var %chan = $$input(������� �������� ������,ey,���������� ���������,$chan) | var %mode = $$input(������� ON/OFF,ey,���������� ���������,OFF) | $netget(ChanServ.call) set %chan leaveops %mode }
  ...������ ����������:{ var %chan = $$input(������� �������� ������,ey,������������ ������,$chan) | var %mode = $$input(������� ON/OFF,ey,������������ ������,OFF) | $netget(ChanServ.call) set %chan opnotice %mode }
  ...$iif($netget(cs.set.enforce),��������� �������):{ var %chan = $$input(������� �������� ������,ey,���������� �������,$chan) | var %mode = $$input(������� ON/OFF,ey,���������� �������,OFF) | $netget(ChanServ.call) set %chan enforce %mode }
  ...$iif($netget(cs.set.nolinks),��������� �����):{ var %chan = $$input(������� �������� ������,ey,��������� �����,$chan) | var %mode = $$input(������� ON/OFF,ey,��������� �����,OFF) | $netget(ChanServ.call) set %chan nolinks %mode }
  ...-
  ...$iif($netget(cs.unset),������)
  ....���������:{ var %chan = $$input(������� �������� ������,ey,������ ���������,$chan) | $netget(ChanServ.call) unset %chan successor }
  ....����:{ var %chan = $$input(������� �������� ������,ey,������ ����,$chan) | $netget(ChanServ.call) unset %chan url }
  ....�����:{ var %chan = $$input(������� �������� ������,ey,������ �����,$chan) | $netget(ChanServ.call) unset %chan email }
  ....�����������:{ var %chan = $$input(������� �������� ������,ey,������ �����������,$chan) | $netget(ChanServ.call) unset %chan entrymsg }
  ..$iif($netget(cs.topic),�����):{ var %chan = $$input(������� �������� ������,ey,����� ������,$chan) | var %text = $$input(������� ����� �����,ey,����� ������,$chan(%chan).topic) | $netget(ChanServ.call) topic %chan %text }
  ..������
  ...��������:{ var %chan = $$input(������� �������� ������,ey,���������� ������ �������,$chan) | var %nick = $input(������� ����������� ���,ey,���������� ������ �������,$gettok($snicks,1,44)) | var %level = $$input(������� ������� �������,ey,���������� ������ �������,30) | $netget(ChanServ.call) access %chan add %nick %level }
  ...������:{ var %chan = $$input(������� �������� ������,ey,�������� ������ �������,$chan) | var %nick = $input(������� ��������� ����/������ �������,ey,�������� ������ �������,$snicks) | $netget(ChanServ.call) access %chan del %nick } 
  ...������:{ var %chan = $$input(������� �������� ������,ey,�������� ������ �������,$chan) | var %mask = $input(������� ����� ������/������ �������,ey,�������� ������ �������) | $netget(ChanServ.call) access %chan list %mask }
  ...$iif($netget(cs.access.count),����������):{ var %chan = $$input(������� �������� ������,ey,�������� ���������� �������,$chan) | $netget(ChanServ.call) access %chan count }
  ..$iif($netget(cs.aop),AOP)
  ...��������:{ var %chan = $$input(������� �������� ������,ey,���������� � ������ AOP,$chan) | var %nick = $input(������� ����������� ���,ey,���������� � ������ AOP,$gettok($snicks,1,44)) | $netget(ChanServ.call) aop %chan add %nick }
  ...������:{ var %chan = $$input(������� �������� ������,ey,C����� AOP,$chan) | $netget(ChanServ.call) aop %chan list }
  ..$iif($netget(cs.sop),SOP)
  ...��������:{ var %chan = $$input(������� �������� ������,ey,���������� � ������ SOP,$chan) | var %nick = $input(������� ����������� ���,ey,���������� � ������ SOP,$gettok($snicks,1,44)) | $netget(ChanServ.call) sop %chan add %nick }
  ...������:{ var %chan = $$input(������� �������� ������,ey,C����� SOP,$chan) | $netget(ChanServ.call) sop %chan list }
  ..������
  ...��������:$netget(ChanServ.call) HELP LEVELS DESC
  ...����������:{ var %chan = $$input(������� �������� ������,ey,��������� ������ �������,$chan) | var %name = $input(������� ���������� �������,ey,��������� ������ �������) | var %level = $$input(������� ������� �������,ey,��������� ������ �������,30) | $netget(ChanServ.call) LEVELS %chan set %name %level }
  ...���������:{ var %chan = $$input(������� �������� ������,ey,���������� ������ �������,$chan) | var %name = $input(������� ����������� �������,ey,���������� ������ �������) | $netget(ChanServ.call) LEVELS %chan disable %name }
  ...������:{ var %chan = $$input(������� �������� ������,ey,�������� ������� �������,$chan) | $netget(ChanServ.call) LEVELS %chan list }
  ...��������:{ var %chan = $$input(������� �������� ������,ey,����� ������� �������,$chan) | $netget(ChanServ.call) LEVELS %chan reset }
  ..$iif($netget(cs.status),������):{ var %chan = $$input(������� �������� ������,ey,�������� �������,$chan) | var %nick = $input(������� ���,ey,�������� �������,$gettok($snicks,1,44)) | $netget(ChanServ.call) status %chan %nick }
  ..-
  ..����� ��������
  ...Op:{ var %chan = $$input(������� �������� ������,ey,������ ���������,$chan) | var %nick = $input(������� ���,ey,������ ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) op %chan %nick }
  ...Deop:{ var %chan = $$input(������� �������� ������,ey,����� ������ ���������,$chan) | var %nick = $input(������� ���,ey,����� ������ ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) deop %chan %nick }
  ...$iif($netget(cs.voice),Voice):{ var %chan = $$input(������� �������� ������,ey,������ ����� ������,$chan) | var %nick = $input(������� ���,ey,������ ����� ������,$gettok($snicks,1,44)) | $netget(ChanServ.call) voice %chan %nick }
  ...$iif($netget(cs.voice),Devoice):{ var %chan = $$input(������� �������� ������,ey,����� ������ ����� ������,$chan) | var %nick = $input(������� ���,ey,����� ������ ����� ������,$gettok($snicks,1,44)) | $netget(ChanServ.call) devoice %chan %nick }
  ...$iif($netget(cs.halfop),Halfop):{ var %chan = $$input(������� �������� ������,ey,������ ��������� ���������,$chan) | var %nick = $input(������� ���,ey,������ ��������� ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) halfop %chan %nick }
  ...$iif($netget(cs.halfop),Dehalfop):{ var %chan = $$input(������� �������� ������,ey,����� ������ ��������� ���������,$chan) | var %nick = $input(������� ���,ey,����� ������ ��������� ���������,$gettok($snicks,1,44)) | $netget(ChanServ.call) dehalfop %chan %nick }
  ...$iif($netget(cs.protect),Protect):{ var %chan = $$input(������� �������� ������,ey,������ �����������,$chan) | var %nick = $input(������� ���,ey,������ �����������,$gettok($snicks,1,44)) | $netget(ChanServ.call) protect %chan %nick }
  ...$iif($netget(cs.protect),Deprotect):{ var %chan = $$input(������� �������� ������,ey,����� ������ �����������,$chan) | var %nick = $input(������� ���,ey,����� ������ �����������,$gettok($snicks,1,44)) | $netget(ChanServ.call) deprotect %chan %nick }
  ..$iif($netget(cs.kick),���������):{ var %chan = $$input(������� �������� ������,ey,��������� � ������,$chan) | var %nick = $$input(������� ���,ey,��������� � ������,$gettok($snicks,1,44)) | var %reas = $input(������� �������,ey,��������� � ������) | $netget(ChanServ.call) kick %chan %nick %reas }
  ..����������
  ...��������:{ var %chan = $$input(������� �������� ������,ey,����������,$chan) | var %mask = $$input(������� ����� �������,ey,����������,$gettok($snicks,1,44) $+ !*@*) | var %reas = $input(������� �������,ey,����������) | $netget(ChanServ.call) akick %chan add %mask %reas }
  ...�������:{ var %chan = $$input(������� �������� ������,ey,����������,$chan) | var %mask = $$input(������� ����� ������� $crlf $+ ALL ������ ��� �����,ey,����������,$gettok($snicks,1,44) $+ !*@*) | $netget(ChanServ.call) akick %chan del %mask }
  ...������:{ var %chan = $$input(������� �������� ������,ey,����������,$chan) | var %mask = $input(������� ����� �������/������ �������,ey,����������) | $netget(ChanServ.call) akick %chan list %mask }
  ...$iif($netget(cs.akick.add),����������):{ var %chan = $$input(������� �������� ������,ey,���������� ����������,$chan) | var %mask = $input(������� ����� �������/������ �������,ey,����������) | $netget(ChanServ.call) akick %chan view }
  ...$iif($netget(cs.akick.add),������):{ var %chan = $$input(������� �������� ������,ey,���������� ������,$chan) | $netget(ChanServ.call) akick %chan enforce }
  ...$iif($netget(cs.akick.add),���������):{ var %chan = $$input(������� �������� ������,ey,���������� - ���������,$chan) | $netget(ChanServ.call) akick %chan count }
  ..��������
  ...������:{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan modes }
  ...����:{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan bans }
  ...$iif($netget(cs.clear.exceptions),����������):{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan exceptions }
  ...$iif($netget(cs.clear.invite),�����������):{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan invites }
  ...���������:{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan ops }
  ...$iif($netget(cs.clear.halfops),���������):{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan halfops }
  ...������:{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan voices }
  ...����������:{ var %chan = $$input(������� �������� ������,ey,������� ������,$chan) | $netget(ChanServ.call) clear %chan users }
  ..-
  ..������������:{ var %chan = $$input(������� �������� ������,ey,������������,$chan) | $netget(ChanServ.call) invite %chan }
  ..�����������:{ var %chan = $$input(������� �������� ������,ey,�����������,$chan) | $netget(ChanServ.call) unban %chan }
  ..-
  ..������:{ var %mask = $$input(������� ����� ������,ey,������ �������,$chan) | $netget(ChanServ.call) list %mask }
  ..����������:{ var %chan = $$input(������� �������� ������,ey,�������� ����������,$chan) | $netget(ChanServ.call) info %chan $iif($netget(cs.info.all),$iif($input(������ ����������?,yq,�������� ����������),all)) }
  ..-
  ..$iif($netget(cs.help.simple),������,������ ������):$netget(ChanServ.call) help
  ..$iif($netget(cs.help.simple),������ ������):$netget(ChanServ.call) help commands
  ..���������:$netget(ChanServ.call) help $$input(������� ������� $+ $chr(44) �� ������� ��������� ������,ey,������ �� �������)
  .����
  ..�������:$netget(MemoServ.call) send $$input(������� ��� ��� �����,ey,����������,$active) $$input(������� ���������,ey,�����)
  ..������
  ...�����:$netget(MemoServ.call) list $input(������� ������ ��������� ��������� $crlf $+ NEW ������� ������ ����� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,������ ���������,NEW)
  ...������:$netget(MemoServ.call) list $$input(������� �������� ������,ey,��������� ������,$chan) $input(������� ������ ��������� ��������� $crlf $+ NEW ������� ������ ����� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,������ ���������,NEW)
  ..���������
  ...�����:$netget(MemoServ.call) read $input(������� ������ ��������� ��������� $crlf $+ LAST ������� ��������� ��������� $crlf $+ NEW ������� ��� ����� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,��������� ���������,LAST)
  ...������:$netget(MemoServ.call) read $$input(������� �������� ������,ey,��������� ������,$chan) $input(������� ������ ��������� ��������� $crlf $+ LAST ������� ��������� ��������� $crlf $+ NEW ������� ��� ����� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,��������� ���������,LAST)
  ..$iif($netget(ms.forward),���������):$netget(MemoServ.call) forward $input(������� ������ ������������ ��������� $crlf $+ ALL �������� ��� ���� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������ ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,��������� ���������,ALL)
  ..$iif($netget(ms.save),���������)
  ...����:$netget(MemoServ.call) save $input(������� ������ ����������� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,��������� ���������,1)
  ...������:$netget(MemoServ.call) save $$input(������� �������� ������,ey,��������� ������,$chan) $input(������� ������ ����������� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,��������� ���������,1)
  ..�������
  ...����:$netget(MemoServ.call) del $input(������� ������ ��������� ��������� $crlf $+ ALL ������ ��� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������ ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,������� ���������,1)
  ...������:$netget(MemoServ.call) del $$input(������� �������� ������,ey,��������� ������,$chan) $input(������� ������ ����������� ��������� $crlf $+ 2-5 $+ $chr(44) $+ 7-9 ������� ��������� ��� �������� 2 $+ $chr(44) $+ 3 $+ $chr(44) $+ 4 $+ $chr(44) $+ 5 $+ $chr(44) $+ 7 $+ $chr(44) $+ 8 $+ $chr(44) $+ 9,ey,������� ���������,1)
  ..����������
  ...�����������
  ....��������:$netget(MemoServ.call) set notify on
  ....��� �����:$netget(MemoServ.call) set notify logon
  ....�����:$netget(MemoServ.call) set notify new
  ....���������:$netget(MemoServ.call) set notify off
  ...�����
  ....����:$netget(MemoServ.call) set limit $input(������������ ���������� ����������� ��������� � ��������� 0-20,ey,��������� ������ ���������,20)
  ....������:$netget(MemoServ.call) set limit $$input(������� �������� ������,ey,�������� ������,$chan) $input(������������ ���������� ����������� ��������� � ��������� 0-20,ey,��������� ������ ���������,20)
  ...$iif($netget(ms.set.forward),��������)
  ....������:$netget(MemoServ.call) set forward on
  ....�����:$netget(MemoServ.call) set forward copy
  ....���������:$netget(MemoServ.call) set forward off
  ..$iif($netget(ms.info),����������):$netget(MemoServ.call) info $input(������� �������� ������. $crlf $+ ��� �������� ������ ������ ��� ��������� ������ ����������.,ye,�������� ������,$chan)
  ..$iif($netget(ms.ignore),������������)
  ...��������:$netget(MemoServ.call) ignore add $$input(������� ���/����� ��� �������������,ey,������ �������������)
  ...�������:$netget(MemoServ.call) ignore del $$input(������� ���/����� ��� ����������� �������������,ey,������ �������������)
  ...������:$netget(MemoServ.call) ignore list
  ..-
  ..$iif($netget(ms.help.simple),������,������ ������):$netget(MemoServ.call) help
  ..$iif($netget(ms.help.simple),������ ������):$netget(MemoServ.call) help commands
  ..���������:$netget(MemoServ.call) help $$input(������� ������� $+ $chr(44) �� ������� ��������� ������,ey,������ �� �������)
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
