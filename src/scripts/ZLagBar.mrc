on *:start:lag.start
on *:unload:lag.unload

alias lag.start {
  if ($version < 6.01) { echo -a * Sorry, this addon does not work with your mIRC verson | unload -rs $lag.q($script) | halt }
  if ($window(@zLagbar)) { window -ar @zLagbar | clear @zLagbar }
  else { window -ahBfp +d @zLagbar 0 0 200 21 }
  if (!%zlag.style) { %zlag.style = graph }
  if (!$len(%zlag.peak)) { %zlag.peak = 5 }
  if (!$len(%zlag.colour1)) { %zlag.colour1 = 16776960 }
  if (!$len(%zlag.colour2)) { %zlag.colour2 = 0 }
  if (!$len(%zlag.colour3)) { %zlag.colour3 = $rgb(text) }
  if (!$len(%zlag.font)) { %zlag.font = Verdana }
  if (!$len(%zlag.font.size)) { %zlag.font.size = 11 }
  if (!$len(%zlag.delay)) { %zlag.delay = 5 }
  if (!$exists(tempcolour.bmp)) {
    window -hBpf +d @temp.colour -1 -1 64 64
    drawrect -fr @temp.colour $rgb(0,0,0) 1 0 0 64 64
    drawsave @temp.colour tempcolour.bmp
    window -c @temp.colour
  }
  drawrect -rf @zLagbar $rgb(face) 1 0 0 200 21
  dll $lag.q($scriptdirtbwin.dll) Attach @zLagbar
  dll $lag.q($scriptdirtbwin.dll) OnSize /lag.size
  dll $lag.q($scriptdirtbwin.dll) Select @zLagbar
  if ($appactive) { window -ar @zLagbar }
  lag.size $dll($lag.q($scriptdirtbwin.dll), GetTBInfo, NOT_USED)
  if (%zlag.style == graph) {
    drawline -rn @zLagbar $rgb(shadow) 1 78 0 200 0
    drawline -rn @zLagbar $rgb(shadow) 1 78 0 78 21
    drawline -rn @zLagbar $rgb(hilight) 1 78 20 199 20
    drawline -rn @zLagbar $rgb(hilight) 1 199 1 199 21
    drawrect -rnf @zLagbar %zlag.colour2 1 79 1 120 19
  }
  if (%zlag.style == bar) {
    drawline -rn @zLagbar $rgb(shadow) 1 78 5 200 5
    drawline -rn @zLagbar $rgb(shadow) 1 78 5 78 16
    drawline -rn @zLagbar $rgb(hilight) 1 78 15 199 15
    drawline -rn @zLagbar $rgb(hilight) 1 199 5 199 16
    drawrect -rnf @zLagbar %zlag.colour2 1 79 6 120 9
  }
  var %temp.textpos = $round($calc((21 - $height(Lag:,%zlag.font,%zlag.font.size)) / 2)),0)
  drawtext -rnc @zLagbar %zlag.colour3 %zlag.font %zlag.font.size 1 %temp.textpos 96 18 Lag: N/A
  drawdot @zLagbar
  lag.check
  .timerlag -io 0 %zlag.delay lag.check
}
alias lag.refresh {
  drawrect -nrf @zLagbar $rgb(face) 1 0 0 200 21
  if ($readini($mircini,Background,toolbar)) {
    lag.temp.bkg
    if (%zlag.style == bar) {
      drawpic -nsl @zLagbar 78 0 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $gettok(%zlag.pos,2,32) 122 5 $lag.q($scriptdirlagbkg.bmp)
      drawpic -nsl @zLagbar 78 16 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $calc($gettok(%zlag.pos,2,32) + 16) 122 5 $lag.q($scriptdirlagbkg.bmp)
    }
    drawpic -nsl @zLagbar 0 0 78 21 %zlag.pos 78 21 $lag.q($scriptdirlagbkg.bmp)
    drawdot @zLagbar
  }
  if (%zlag.style == graph) {
    drawline -rn @zLagbar $rgb(shadow) 1 78 0 200 0
    drawline -rn @zLagbar $rgb(shadow) 1 78 0 78 21
    drawline -rn @zLagbar $rgb(hilight) 1 78 20 199 20
    drawline -rn @zLagbar $rgb(hilight) 1 199 1 199 21
    drawrect -rnf @zLagbar %zlag.colour2 1 79 1 120 19
  }
  if (%zlag.style == bar) {
    drawline -rn @zLagbar $rgb(shadow) 1 78 5 200 5
    drawline -rn @zLagbar $rgb(shadow) 1 78 5 78 16
    drawline -rn @zLagbar $rgb(hilight) 1 78 15 199 15
    drawline -rn @zLagbar $rgb(hilight) 1 199 5 199 16
    drawrect -rnf @zLagbar %zlag.colour2 1 79 6 120 9
  }
  var %temp.textpos = $round($calc((21 - $height(Lag:,%zlag.font,%zlag.font.size)) / 2)),0)
  drawtext -rnc @zLagbar %zlag.colour3 %zlag.font %zlag.font.size 1 %temp.textpos 96 18 Lag: %zlag.current $+ s
  drawdot @zLagbar
}
alias lag.check { if ($server) { raw -q ping lag. [ $+ [ $ticks ] ] } }
alias lag.size {
  %zlag.pos = $calc($1 - 204) $int($calc(($2 - 18) / 2))
  if ($readini($mircini,Background,toolbar)) {
    lag.temp.bkg
    if (%zlag.style == bar) {
      drawpic -nsl @zLagbar 78 0 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $gettok(%zlag.pos,2,32) 122 5 $lag.q($scriptdirlagbkg.bmp)
      drawpic -nsl @zLagbar 78 16 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $calc($gettok(%zlag.pos,2,32) + 16) 122 5 $lag.q($scriptdirlagbkg.bmp)
    }
    drawpic -nsl @zLagbar 0 0 78 21 %zlag.pos 78 21 $lag.q($scriptdirlagbkg.bmp)
    drawdot @zLagbar
  }
  window @zLagbar %zlag.pos 200 21
}
on *:close:@zLagbar:{ dll $lag.q($scriptdirtbwin.dll) Detach @zLagbar }
menu @zLagbar {
  Style
  .$iif(%zlag.style == graph,$style(1)) Graph:{ set %zlag.style graph | lag.refresh }
  .$iif(%zlag.style == bar,$style(1)) Percent bar:{ set %zlag.style bar | lag.refresh }
  Colour
  .Text:{ set %temp.coloursel 3 | set %temp.colour3 $dialog(lagcolour.select,lagcolour.select,-2) | if ($len(%temp.colour3)) { set %zlag.colour3 %temp.colour3 | lag.refresh } | unset %temp.colour* }
  .Foreground:{ set %temp.coloursel 1 | set %temp.colour1 $dialog(lagcolour.select,lagcolour.select,-2) | if ($len(%temp.colour1)) { set %zlag.colour1 %temp.colour1 | lag.refresh } | unset %temp.colour* }
  .Background:{ set %temp.coloursel 2 | set %temp.colour2 $dialog(lagcolour.select,lagcolour.select,-2) | if ($len(%temp.colour2)) { set %zlag.colour2 %temp.colour2 | lag.refresh } | unset %temp.colour* }
  Font:{ var %temp.font = $$?="Enter Font" | var %temp.font.size = $$?="Enter Font Size" | if (%temp.font) { %zlag.font = %temp.font } | if (%temp.font.size) { %zlag.font.size = %temp.font.size } }
  Peak $chr(40) $+ %zlag.peak $+ s $+ $chr(41):{ var %zlag.temp.peak = $$?="Enter Peak number of seconds" | if (%zlag.temp.peak isnum) { %zlag.peak = %zlag.temp.peak } }
  Delay $chr(40) $+ %zlag.delay $+ s $+ $chr(41):{ var %zlag.temp.delay = $$?="Enter Delay" | if (%zlag.temp.delay isnum) { %zlag.delay = %zlag.temp.delay | .timerlag -io 0 %zlag.delay lag.check } }
  -
  Reset to Defaults:{ lag.var.default }
  -
  Unload Lagbar:{ unload -rs $lag.q($script) | halt }
}
on ^*:pong:{
  if (lag.* iswm $2) {
    if (!%zlag.style) { %zlag.style = graph }
    if (!$len(%zlag.peak)) { %zlag.peak = 5 }
    if (!$len(%zlag.colour1)) { %zlag.colour1 = 16776960 }
    if (!$len(%zlag.colour2)) { %zlag.colour2 = 0 }
    if (!$len(%zlag.colour3)) { %zlag.colour3 = $rgb(text) }
    if (!$len(%zlag.font)) { %zlag.font = Verdana }
    if (!$len(%zlag.font.size)) { %zlag.font.size = 11 }
    %zlag.current = $calc(($ticks - $gettok($2,2,46)) / 1000)
    %zlag.perc = $round($calc(%zlag.current * 100 / %zlag.peak),0)
    %zlag.perc = $iif(%zlag.perc > 100,100,%zlag.perc)
    %zlag.perc2 = $calc((18 / 100) * %zlag.perc)
    if (%zlag.current > %zlag.highest) || (!%zlag.highest) { %zlag.highest = %zlag.current }
    if (%zlag.current < %zlag.lowest) || (!%zlag.lowest) { %zlag.lowest = %zlag.current }
    if ($appactive) { window -a @zLagbar }
    drawrect -nrf @zLagbar $rgb(face) 1 0 0 78 21
    if ($readini($mircini,Background,toolbar)) {
      lag.temp.bkg
      drawpic -nsl @zLagbar 0 0 78 21 %zlag.pos 78 21 $lag.q($scriptdirlagbkg.bmp)
    }
    var %temp.textpos = $round($calc((21 - $height(Lag:,%zlag.font,%zlag.font.size)) / 2)),0)
    drawtext -nrc @zLagbar %zlag.colour3 %zlag.font %zlag.font.size 1 %temp.textpos 96 18 Lag: %zlag.current $+ s
    if (%zlag.style == bar) {
      if ($readini($mircini,Background,toolbar)) {
        lag.temp.bkg
        drawpic -nsl @zLagbar 78 0 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $gettok(%zlag.pos,2,32) 122 5 $lag.q($scriptdirlagbkg.bmp)
        drawpic -nsl @zLagbar 78 16 122 5 $calc($gettok(%zlag.pos,1,32) + 78) $calc($gettok(%zlag.pos,2,32) + 16) 122 5 $lag.q($scriptdirlagbkg.bmp)
      }
      if (!$readini($mircini,Background,toolbar)) {
        drawrect -nrf @zLagbar $rgb(face) 1 78 0 122 5
        drawrect -nrf @zLagbar $rgb(face) 1 78 16 122 5
      }
      drawrect -rnf @zLagbar %zlag.colour2 1 79 6 120 9
      drawrect -nrf @zLagbar %zlag.colour1 1 79 6 $calc((120 / 100) * %zlag.perc) 9
    }
    if (%zlag.style == graph) || (!%zlag.style) {
      drawline -rn @zLagbar %zlag.colour2 1 198 19 198 0
      drawline -rn @zLagbar %zlag.colour1 1 198 19 198 $calc(19 - %zlag.perc2)
      drawscroll -n @zLagbar -1 0 79 1 120 19
    }
    drawdot @zLagbar
    unset %zlag.perc %zlag.perc2
    haltdef
  }
}
alias lag {
  if ($isid) {
    if ($1 == highest) { return %zlag.highest }
    if ($1 == lowest) { return %zlag.lowest }
    return %zlag.current
  }
  if (!$isid) {
    set %zlag.temp.message $chr(91) $+ Lag: %zlag.current $+ s $chr(40) $+ Highest: %zlag.highest $+ s Lowest: %zlag.lowest $+ s $+ $chr(41) $+ $chr(93)
    if ($active ischan) || ($query($active)) { msg $active %zlag.temp.message }
    else { echo $colour(info text).dd -at * %zlag.temp.message }
    unset %zlag.temp.message
  }
}
alias lag.unload { .timerlag off | dll $lag.q($scriptdirtbwin.dll) Detach @zLagbar | window -c @zLagbar }
dialog lagcolour.select {
  title "Select Colour"
  size -1 -1 273 102
  scroll "", 1, 48 7 150 16, range 255 horizontal bottom
  scroll "", 2, 48 31 150 16, range 255 horizontal bottom
  scroll "", 3, 48 55 150 16, range 255 horizontal bottom
  button "Ok", 4, 127 79 70 21, ok
  icon 5, 205 7 64 64, tempcolour.bmp, 0, noborder
  edit "", 6, 3 5 40 21
  edit "", 7, 3 29 40 21
  edit "", 8, 3 53 40 21
  edit "", 9, 30 78 70 21, result hide
  button "Cancel", 10, 201 79 70 21, cancel
}
on *:dialog:lagcolour.select:init:*:{
  if (%temp.coloursel) {
    set %temp.colourrgb $rgb(%zlag.colour [ $+ [ %temp.coloursel ] ])
    did -a $dname 6 $gettok(%temp.colourrgb,1,44) | did -a $dname 7 $gettok(%temp.colourrgb,2,44) | did -a $dname 8 $gettok(%temp.colourrgb,3,44) | did -a $dname 9 %zlag.colour [ $+ [ %temp.coloursel ] ]
    did -c $dname 1 $gettok(%temp.colourrgb,1,44) | did -c $dname 2 $gettok(%temp.colourrgb,2,44) | did -c $dname 3 $gettok(%temp.colourrgb,3,44)
  }
  if (!%temp.coloursel) {
    did -a $dname 6 0 | did -a $dname 7 0 | did -a $dname 8 0 | did -a $dname 9 0
  }
  window -hBpf +d @temp.colour -1 -1 64 64
  drawrect -fr @temp.colour $rgb($did(6),$did(7),$did(8)) 1 0 0 64 64
  drawsave @temp.colour tempcolour.bmp
  did -g $dname 5 tempcolour.bmp
}
on *:dialog:lagcolour.select:scroll:*:{
  if ($did == 1) { did -o $dname 6 1 $did(1).sel }
  if ($did == 2) { did -o $dname 7 1 $did(2).sel }
  if ($did == 3) { did -o $dname 8 1 $did(3).sel }
  if ($istok(1 2 3,$did,32)) {
    drawrect -fr @temp.colour $rgb($did(6),$did(7),$did(8)) 1 0 0 64 64
    drawsave @temp.colour tempcolour.bmp
    did -g $dname 5 tempcolour.bmp
    did -o $dname 9 1 $rgb($did(6),$did(7),$did(8))
  }
}
on *:dialog:lagcolour.select:edit:*:{
  if ($did == 6) { if (!$len($did(6))) || ($did(6) !isnum) { did -o $dname 6 1 0 } | did -c $dname 1 $did(6) }
  if ($did == 7) { if (!$len($did(7))) || ($did(7) !isnum) { did -o $dname 7 1 0 } | did -c $dname 2 $did(7) }
  if ($did == 8) { if (!$len($did(8))) || ($did(8) !isnum) { did -o $dname 8 1 0 } | did -c $dname 3 $did(8) }
  if ($istok(6 7 8,$did,32)) {
    drawrect -fr @temp.colour $rgb($did(6),$did(7),$did(8)) 1 0 0 64 64
    drawsave @temp.colour tempcolour.bmp
    did -g $dname 5 tempcolour.bmp
    did -o $dname 9 1 $rgb($did(6),$did(7),$did(8))
  }
}
on *:dialog:lagcolour.select:close:*:{ window -c @temp.colour }
alias lag.temp.bkg {
  if ($exists($readini($mircini,Background,Toolbar))) {
    if (!%zlag.temp.crc) || (%zlag.temp.crc != $crc($readini($mircini,Background,Toolbar))) {
      window -hBfp +d @zlagtemp -1 -1 $window(-1).dw 100
      drawpic -sl @zlagtemp 0 0 $window(-1).dw 100 $lag.q($readini($mircini,Background,Toolbar))
      drawsave @zlagtemp $lag.q($scriptdirlagbkg.bmp)
      window -c @zlagtemp
      %zlag.temp.crc = $crc($readini($mircini,Background,Toolbar))
    }
  }
}
alias lag.var.default {
  %zlag.peak = 5
  %zlag.colour1 = 16776960
  %zlag.colour2 = 0
  %zlag.colour3 = $rgb(text)
  %zlag.font = Verdana
  %zlag.font.size = 11
  %zlag.delay = 5
}
alias lag.q { return " $+ $1- $+ " }
