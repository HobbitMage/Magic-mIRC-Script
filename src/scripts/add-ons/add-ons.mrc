forumfight {
  if (!$exists(forumfight\) mkdir forumfight
  unset %forum.*
  inc %forums.num
  var %filename, %i, %err, %j, %lines, %turn, %targ, %att, %block, %phr
  var %filepath forumfight\
  var %filename result
  set %filename %filepath $+ %filename $+ . $+ %forums.num $+ .txt
  set %i 1
  while (%i <= $0) { echo -a file [ $ [ $+ [ %i ] ] ] $+ .txt | if (!$exists(%filepath $+ [ $ [ $+ [ %i ] ] ] $+ .txt)) set %err %err Нету файла [ $ [ $+ [ %i ] ] ] $+ .txt | inc %i }
  if (%err) { echo -a %err | halt }
  write %filename Битва $0 человек. Участники : $1-
  set %i 1
  while (%i <= $0) { if (%i == 1) set %lines $lines(%filepath $+ [ $ [ $+ [ %i ] ] ] $+ .txt) | else if (%lines != $lines(%filepath $+ [ $ [ $+ [ %i ] ] ] $+ .txt)) set %err Различное количество строк в файлах. | inc %i }
  if (%err) { echo -a %err | halt }
  write %filename %lines ходов
  set %j 1 
  write %filename -------------
  while (%j <= %lines) {
    write %filename Раунд %j
    set %i 1
    while (%i <= $0) {
      set %turn $read(%filepath $+ [ $ [ $+ [ %i ] ] ] $+ .txt, %j)
      set %targ $gettok(%turn,1,32) | set %att $gettok(%turn,2,32) | set %phr $gettok(%turn,4-,32)
      if ($gettok($read(%filepath $+ %targ $+ .txt,%j),3,32) == %att) { 
        write %filename [ $ [ $+ [ %i ] ] ] $+ : %targ %att $gettok(%turn,3,32) $+ . -- не смог нанести %targ удар в %att $iif(%phr, $+ . < $+ %phr $+ >)
        inc %forum.succ_block [ $+ [ %targ ] ]
      }
      else {
        write %filename [ $ [ $+ [ %i ] ] ] $+ : %targ %att $gettok(%turn,3,32) $+ . -- смог нанести %targ удар в %att $iif(%phr, $+ . < $+ %phr $+ >)
        inc %forum.succ_att [ $+ [ $ [ $+ [ %i ] ] ] ]
      }
      inc %forum.incoming [ $+ [ %targ ] ]
      inc %i
    }
    inc %j
    write %filename -------------  
    write %filename -------------  
  }
  set %i 1
  write %filename Количество удачных атак:
  while (%i <= $0) {
    write %filename [ $ [ $+ [ %i ] ] ] - $iif(%forum.succ_att [ $+ [ $ [ $+ [ %i ] ] ] ],$ifmatch,0) попаданий
    inc %i
  }
  set %i 1
  write %filename Количество входящих:
  while (%i <= $0) {
    set %block $calc(%forum.incoming [ $+ [ $ [ $+ [ %i ] ] ] ] - %forum.succ_block [ $+ [ $ [ $+ [ %i ] ] ] ] )
    write %filename [ $ [ $+ [ %i ] ] ] - пропустил $calc(%forum.incoming [ $+ [ $ [ $+ [ %i ] ] ] ] - %forum.succ_block [ $+ [ $ [ $+ [ %i ] ] ] ] ) из %forum.incoming [ $+ [ $ [ $+ [ %i ] ] ] ] ударов (блок $round($calc(%forum.succ_block [ $+ [ $ [ $+ [ %i ] ] ] ] / %forum.incoming [ $+ [ $ [ $+ [ %i ] ] ] ] * 100),0 ) $+ $chr(37) $+ $chr(41) $+ , заблокировал $iif(%forum.succ_block [ $+ [ $ [ $+ [ %i ] ] ] ],$ifmatch,0)
    inc %i
  }
  %i = 1
  while (%i <= $0) { rename %filepath $+ [ $ [ $+ [ %i ] ] ] $+ .txt %filepath $+ %forums.num $+ . $+ [ $ [ $+ [ %i ] ] ] $+ .txt | inc %i }
  run %filename
}

color.hextodec {
  var %r, %g, %b
  set %r $left($1,2)
  set %g $mid($1,3,2)
  set %b $right($1,2)
  %r = $calc($replace($left(%r,1),a,10,b,11,c,12,d,13,e,14,f,15) * 16 + $replace($right(%r,1),a,10,b,11,c,12,d,13,e,14,f,15))
  %g = $calc($replace($left(%g,1),a,10,b,11,c,12,d,13,e,14,f,15) * 16 + $replace($right(%g,1),a,10,b,11,c,12,d,13,e,14,f,15))
  %b = $calc($replace($left(%b,1),a,10,b,11,c,12,d,13,e,14,f,15) * 16 + $replace($right(%b,1),a,10,b,11,c,12,d,13,e,14,f,15))
  return %r %g %b
}
color.dectohex {
  var %r, %g, %b
  set %r $left($1,3)
  set %g $mid($1,4,3)
  set %b $right($1,3)
  %r = $replace($int($calc(%r / 16)),10,a,11,b,12,c,13,d,14,e,15,f) $+ $replace($calc(%r - $int($calc(%r / 16)) * 16),10,a,11,b,12,c,13,d,14,e,15,f)
  %g = $replace($int($calc(%g / 16)),10,a,11,b,12,c,13,d,14,e,15,f) $+ $replace($calc(%g - $int($calc(%g / 16)) * 16),10,a,11,b,12,c,13,d,14,e,15,f)
  %b = $replace($int($calc(%b / 16)),10,a,11,b,12,c,13,d,14,e,15,f) $+ $replace($calc(%b - $int($calc(%b / 16)) * 16),10,a,11,b,12,c,13,d,14,e,15,f)
  return %r %g %b
}

dectohex { }
