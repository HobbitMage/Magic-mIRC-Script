
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
  if ($findfile($logdir,*.log,0,2) == 0) { echo %logview.info @logview Логов в папке нету! Проверьте настройки mirc! | halt }
  if (%n == 0) { echo %logview.info @logview По вашему запросу файлов не найдено! | halt }
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
  echo %logview.info @logview Вывод файлов завершен. Затрачено $+ %logview.hl $calc($ctime - %time) секунд(а).
  if ((%sort) && (%sort != n+)) logview.sort %sort
}

alias logview.sort {
  var %i = 1, %m, %mn, %linei, %linej, %n = $line(@logview,0,1), %date, %time = $ctime, %name
  if (!$istok(d+ d- n+ n-,$1,32)) { echo %logview.info @Logview Неизвестное свойство $+ %logview.hl $1 | halt }
  echo %logview.info @logview -  
  echo %logview.info -t @Logview Сортировка: $1  $+ %logview.hl $+ %n файла(ов).
  if (%n >= 60) echo %logview.info @Logview Пожалуйста, подождите, сортировка может занять некоторое время, остальные окна работать не будут.
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
  echo %logview.info @logview Сортировка закончена. Прошло: $+ %logview.hl $calc($ctime - %time) секунд(а)
  halt
}

alias logview.filter {
  echo %logview.info -t @logview Фильтр $line(@logview,0,1) файла(ов)
  var %i = 1, %time = $ctime
  if ($1 == s) {
    echo %logview.info @logview Выделено $+ %logview.hl $iif($sline(@logview,0),$ifmatch,0) $iif($2 == -,останется $+ %logview.hl $calc($line(@logview,0,1) - $sline(@logview,0)) файл(ов))
    while (%i <= $line(@logview,0,1)) {
      if (($2 == +) && (!$line(@logview,%i,1).state)) { dline -l @logview %i | dec %i }
      if (($2 == -) && ($line(@logview,%i,1).state)) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  if ($1 == m) {
    echo %logview.info @logview Файлов $+ %logview.hl $line(@logview,0,1) Маска $+ %logview.hl $3-
    while (%i <= $line(@logview,0,1)) {
      if (($2 == +) && ($3- !iswm $line(@logview,%i,1))) { dline -l @logview %i | dec %i }
      if (($2 == -) && ($3- iswm $line(@logview,%i,1))) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  if ($1 == f) {
    echo %logview.info @logview Файлов $+ %logview.hl $line(@logview,0,1) Поиск в файлах строки $+ %logview.hl $2-
    while (%i <= $line(@logview,0,1)) {
      if (!$read($logdir $+ $line(@logview,%i,1),w,* $+ $2- $+ *,1)) { dline -l @logview %i | dec %i }
      inc %i
    }
  }
  echo %logview.info @logview Фильтрация завершена. Результат $+ %logview.hl $line(@logview,0,1) файл(ов). Затрачено $+ %logview.hl $calc($ctime - %time) секунд(а).
}
alias logview.fileinfo { return $input(Файл: $1 $+ $crlf $+ Строк: $lines($logdir $+ $1) $+ $crlf $+ Создан: $asctime($file($logdir $+ $1).ctime) $+ $crlf $+ Изменён: $asctime($file($logdir $+ $1).mtime),oi,Информация о файле) }
alias logview.play {
  var %flag, %file, %mod, %fn
  echo -a $1-
  if ($left($1,1) == -) { set %flag $right($1,-1) | set %file $logdir $+ $2 | set %fn $2 | set %mod $iif(%flag == m,* $+ $3- $+ *,$3-) }
  else { set %file $logdir $+ $1 | set %fn $1 }
  var %lines = $lines(%file), %i = 1, %j = 0, %n = 0
  ;clear @logview
  echo %logview.info -e @logview Файл %file (строк %lines $+ ): $iif($2,%flag %mod)
  if ($fopen(logview)) .fclose logview
  if (!$exists(" $+ %file $+ ")) { echo %logview.info -e @logview Ошибка: Файл не существует. | return }
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
      echo %logview.info @logview Вывод приостановлен. Выведено %j строк.
      echo %logview.info @logview Для продолжения выберите в меню "Продолжить". 
      echo %logview.info @logview -
      %logview.continue = logview.play -s %fn %i $+ - 
      return
    }
  }
  .fclose logview
  echo %logview.info -e @logview Вывод окончен. Выведено %j строк.
}
alias logview.continue {
  var %cmd
  %cmd = %logview.continue
  unset %logview.continue
  %cmd
}

alias logview.logdelete {
  if (!%logview.delete) { if (!$input(Удалить $iif($sline(@logview,0) > 1,$ifmatch файла(ов)?,файл? $+ $crlf $+ $sline(@logview,1)),yq,Удаление логов)) return }
  echo %logview.info -e @logview Удаление $sline(@logview,0) файла(ов).
  while ($sline(@logview,0) > 0) {
    remove $iif(!%logview.deltrash,-b) " $+ $logdir $+ $sline(@logview,1) $+ "
    dline -l @logview $sline(@logview,1).ln
  }
  echo %logview.info -e @logview Удаление завершено. $iif(!%logview.deltrash,Вы можете восстановить удалённые файлы из корзины.)
}


menu menubar {
  .-
  .Логи
  ..Просмотровщик:logview
  ..Версии:run strings/logviewer.versions.txt
  ..Настройки:logview.setup
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
  if ($numtok(%info %nick %chan %hl,32)) echo -ast Скрипт Magic Logviewer предпологает наличие переменных цвета. В случае их отсутствия возможны ошибки в работе.
  if (%info) echo -ast %colors.info содержит значение  $+ %info $+  измените это значение на число 0-15 командой /set $chr(37) $+ logview.info число
  if (%nick) echo -ast %colors.nick содержит значение  $+ %nick $+  измените это значение на число 0-15 командой /set $chr(37) $+ logview.nick число
  if (%chan) echo -ast %colors.chan содержит значение  $+ %chan $+  измените это значение на число 0-15 командой /set $chr(37) $+ logview.chan число
  if (%hl) echo -ast %colors.hl содержит значение  $+ %hl $+  измените это значение на число 0-15 командой /set $chr(37) $+ logview.hl число
  if ($numtok(%info %nick %chan %hl,32)) echo -ast Если вы уверены, что никаких важных данных в этих переменных не содержится, можете ввести команду /logviewer.reset, которая установит цвета из вашей цветовой схемы по умолчанию.
}

alias logviewer.reset {
  unset %logview.info
  unset %logview.chan
  unset %logview.nick
  unset %logview.hl
  logview.check
}

menu @logview {
  dclick:{ %logview.mask = $$input(Введите маску,ey,Вывод по маске,%logview.mask) | logview.play -m $$sline($active,1) %logview.mask }
  $iif(%logview.continue,Продолжить):logview.continue
  -
  Настройки:{ if ($dialog(logview.prefs)) dialog -v logview.prefs | else dialog -m logview.prefs prefs_logviewer }
  Очистить окно вывода:clear @logview
  Перегрузить список логов
  .Полный:logview.fill
  .Каналы:logview.fill $chr(35)
  .Приваты:logview.fill -n
  .Список по маске:{ %logview.outmask = $$input(Введите маску вывода: $crlf * - любая комбинация символов $crlf ? - один любой символ $crlf $+ в конце будет добавлено *.log,eyq,Маска вывода логов,%logview.outmask) | logview.fill %logview.outmask }
  -
  Сортировка
  .По дате:logview.sort d-
  .По дате обратно:logview.sort d+
  .По имени:logview.sort n+
  .По имени обратно:logview.sort n-
  Фильтр
  .Удалить по маске:{ %logview.filemask = $$input(Введите маску,ey,Фильтр логов,%logview.filemask) | logview.filter m - %logview.filemask }
  .Оставить по маске:{ %logview.filemask = $$input(Введите маску,ey,Фильтр логов,%logview.filemask) | logview.filter m + %logview.filemask }
  .Удалить выделенные:logview.filter s -
  .Оставить выделенные:logview.filter s +
  .Поиск строки в файле:{ %logview.searchmask = $$input(Введите маску,ey,Фильтр логов,%logview.searchmask) | logview.filter f %logview.searchmask }
  Вывод
  .$iif($1,Вывести полностью):logview.play $$1
  .$iif($1,Вывести строки):logview.play -s $$1 $input(Введите номера строк,ey,Построчный вывод,1- $+ $lines($logdir $+ $1))
  .$iif($1,Вывести по маске):{ %logview.mask = $$input(Введите маску,ey,Вывод по маске,%logview.mask) | logview.play -m $$1 %logview.mask }
  $iif($1,Информация о $ifmatch):logview.fileinfo $1
  -
  Удаление файлов:logview.logdelete
  -
  Открыть папку с логами:run $logdir
  Открыть файл:run " $+ $logdir $+ $$1 $+ "
}

alias logviewer.help {
  var %ec echo %logview.info -h @Logview 
  if ($1 == $null) {
    %ec -
    %ec Информация о Magic Logviewer %logview.version
    %ec Скрипт позволяет просматривать файлы логов в окне mIRC сохраняя оригинальное форматирование и цвета.
    %ec Для удобства предоставления информации используются четыре переменные цвета:
    %ec $chr(9) $chr(37) $+ logview.nick $chr(9) ( $+ %logview.nick $+ ) $chr(9) - $chr(9) цвет файлов приватов
    %ec $chr(9) $chr(37) $+ logview.chan $chr(9) ( $+ %logview.chan $+ ) $chr(9) - $chr(9) цвет файлов каналов
    %ec $chr(9) $chr(37) $+ logview.info $chr(9) ( $+ %logview.info $+ ) $chr(9) - $chr(9) цвет информационных строк
    %ec $chr(9) $chr(37) $+ logview.hl $chr(9) ( $+ %logview.hl $+ ) $chr(9) - $chr(9) цвет выделенной информации
    %ec В скобках указано текущее значение цвета, сменить его можно командой /set $chr(37) $+ logview.nick <число>
    %ec <Число> должно лежать в пределах 0-15 и являться номером цвета IRC - просмотреть их номера можно нажав Ctrl+K
    %ec Для предотвращения ошибок отображения чисел старайтесь использовать двузначные номера цвета, например 04
    echo @Logview 
    %ec Для начала поиска необходимо перегрузить список логов (из меню, вызываемого правой клавишей мышки)
    %ec Варианты загрузки:
    %ec $chr(9) Полный $chr(9) - $chr(9) будут выведены все файлы логов (*.log)
    %ec $chr(9) Каналы $chr(9) - $chr(9) будут выведены все файлы логов каналов (#*.log)
    %ec $chr(9) Приваты $chr(9) - $chr(9) будут выведены все файлы логов приватов
    %ec $chr(9) По маске $chr(9) - $chr(9) будут выведены все файлы логов, удовлетворяющие заданному запросу
    %ec Например: a* выведет все логи приватов с никами, начинающимися на a, #*b выведет все логи каналов, содержащих в имени букву b
    echo @Logview 
    %ec Загруженный список логов можно отсортировать по имени и дате в возрастающем или убывающем порядке
    echo @Logview 
    %ec Список логов можно отфильтровать:
    %ec $chr(9) По маске $chr(9) - $chr(9) будут удалены/оставлены файлы логов, удовлетворяющие заданной маске
    %ec $chr(9) По выделеннию $chr(9) $chr(9) - $chr(9) будут удалены/оставлены файлы логов, выделенные мышкой (shift+mclick,ctrl+mclick)
    %ec $chr(9) По строке$chr(9) - $chr(9) будут оставлены файлы логов, содержащие в себе хотя бы одну строку, удовлетворяющую маске (очень медленно)
    echo @Logview 
    %ec Вывести файл лога можно тремя способами:
    %ec $chr(9) Полностью $chr(9) - $chr(9) будет выведен весь файл
    %ec $chr(9) Строки $chr(9) - $chr(9) будут выведы строки, лежащие в заданном интервале (<начало>-<конец>); по умолчанию интервал принимает предельные значения (1-количество строк)
    %ec $chr(9) По маске $chr(9) - $chr(9) будут выведы строки, удовлетворяющие заданной маске
    %ec Для удобства поиска каждая строка предворяется своим номером.
    return
  }
  if ($1 == menu) {
    %ec -
    %ec Настройки Magic Logviewer
    %ec Цвета вывода должны быть числами от 0 до 15, посмотреть на таблицу цветов можно по нажатию ctrl+k.
    %ec Так как желательно использование двухцифровых кодов, недостающий 0 будет автоматически прибавлен сскриптом.
    %ec -
    %ec Можно отключить подтверждения удаления и отключить удаление в корзину (не рекомендуется, так как восстановление файлов в этом случае сильно усложняется).
    %ec Если при выводе файла строк оказывается больше предела, вывод останавливается и в строке ввода появляется команда продолжения вывода.
    echo %logview.hl @Logview Пока данная возможность позволяет выводить файлы только по строкам. Непонятная ошибка не позволяет данному скрипту сработать второй раз подряд.
    return
  }
  %ec -
  %ec Топик $1 отсутствует.
}

dialog prefs_logviewer {
  title "Настройки просмотровщика"
  size -1 -1 150 68
  option dbu
  icon grafix\, 0
  button "Применить", 1, 3 54 48 12, disable
  button "Справка", 2, 51 54 48 12
  button "Закрыть", 3, 99 54 48 12, ok
  box "Цвета", 4, 1 1 50 50
  text "Информация", 5, 3 9 32 8
  text "Выделение", 6, 3 19 32 8
  text "Ники", 7, 3 39 32 8
  text "Каналы", 8, 3 29 32 8
  edit "", 9, 37 8 10 10
  edit "", 10, 37 18 10 10
  edit "", 11, 37 28 10 10
  edit "", 12, 37 38 10 10
  check "Подтверждать удаление", 13, 65 8 80 10
  check "Удалять в корзину", 14, 65 18 80 10
  edit "", 15, 52 31 20 10
  text "Предельное количество строк за один вывод", 16, 74 29 69 15
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
