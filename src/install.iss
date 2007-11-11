[Setup]
AppName=Magic mIRC Script
AppVerName=Magic mIRC Script 0.7.0.6
AppPublisher=Cy6JIuMamop
AppPublisherURL=http://magic.gamenavigator.ru
AppSupportURL=http://wiki.gamenavigator.ru/wiki/Magic_Script
AppUpdatesURL=http://magic.gamenavigator.ru/magicscript
DefaultDirName={pf}\Magic mIRC
DefaultGroupName=Magic mIRC Script
AllowNoIcons=yes
LicenseFile=license.txt
InfoBeforeFile=Info.txt
OutputDir=..\bin
OutputBaseFilename=Magic_0.7.0.6
Compression=lzma/normal
SolidCompression=yes
VersionInfoCompany=Hellfire corp.
VersionInfoDescription=Magic mIRC Script 0.7.0.6
VersionInfoTextVersion=v. 0.7.0.6
VersionInfoVersion=0.7.0.6
AllowRootDirectory=no
AlwaysShowComponentsList=yes
AppendDefaultDirName=yes
AppendDefaultGroupName=yes
BackColor=clBlue
BackColor2=clRed

[Languages]
Name: "rus"; MessagesFile: "compiler:Languages\Russian.isl"

[Types]
Name: "full"; Description: "Полная установка"
Name: "compact"; Description: "Обновление"
Name: "custom"; Description: "Выборочная установка"; Flags: iscustom

[components]
name: "main"; Description: "Файлы скрипта"; Types: full compact custom; Flags: fixed
name: "txt"; Description: "Настройки скрипта"; Types: full custom; Flags: disablenouninstallwarning
name: "help_ru"; Description: "Рускоязычная справка"; Types: full custom; Flags: disablenouninstallwarning
name: "help_en"; Description: "Оригинальная справка"; Types: custom; Flags: disablenouninstallwarning

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\mirc.exe"; Description: "Запустить программу"; Flags: postinstall nowait

[Files]
Source: "mirc.exe"; DestDir: "{app}"; Components: main
Source: "help\mirc.hlp"; DestDir: "{app}"; Flags: ignoreversion; Components: help_ru
Source: "help\mirc.chm"; DestDir: "{app}"; Flags: ignoreversion; Components: help_en
Source: "ircintro.chm"; DestDir: "{app}"; Flags: ignoreversion; Components: help_en
Source: "servers.ini"; DestDir: "{app}"; Flags: ignoreversion; Components: txt
Source: "Версии.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "readme.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "versions.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "scripts\help\help.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\logviewer\logviewer.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\popups.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\popup.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\raws.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\setups.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\stuffaliases.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\sysaliases.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\vizaliases.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion; Components: main
Source: "scripts\ZLagBar.mrc"; DestDir: "{app}\Scripts"; Flags: ignoreversion onlyifdoesntexist; Components: main
Source: "scripts\TBWin.dll"; DestDir: "{app}\Scripts"; Flags: ignoreversion onlyifdoesntexist; Components: main
Source: "scripts\remote.ini"; DestDir: "{app}\Scripts"; Flags: ignoreversion onlyifdoesntexist; Components: main
Source: "strings\*"; DestDir: "{app}\Strings"; Flags: ignoreversion onlyifdoesntexist; Components: txt; beforeinstall: asktoower('strings');
Source: "Grafix\*"; DestDir: "{app}\Grafix"; Flags: ignoreversion; Components: main
Source: "license.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: main
Source: "scripts\help\help.versions.txt"; DestDir: "{app}\Strings"; Flags: ignoreversion; Components: main
Source: "scripts\logviewer\logviewer.versions.txt"; DestDir: "{app}\Strings"; Flags: ignoreversion; Components: main
;Source: "sounds\Private.mp3"; DestDir: "{app}"; Flags: ignoreversion

[INI]
Filename: "{app}\mirc.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://magic.gamenavigator.ru"

[Icons]
Name: "{group}\Magic mIRC Script"; Filename: "{app}\mirc.exe"
Name: "{group}\{cm:ProgramOnTheWeb,Magic mIRC Script}"; Filename: "{app}\mirc.url"
Name: "{group}\{cm:UninstallProgram,Magic mIRC Script}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Magic mIRC"; Filename: "{app}\mirc.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Magic mIRC"; Filename: "{app}\mirc.exe"; Tasks: quicklaunchicon

[code]
var
  UserInfoPage: TInputQueryWizardPage;
  UserInfoPage2: TInputQueryWizardPage;
  UserSexPage: TInputOptionWizardPage;
  ServerNamePage: TInputOptionWizardPage;
  ServerInfoPage: TInputQueryWizardPage;
  UserThemePage: TInputOptionWizardPage;
  owertexts,askedower: boolean;
  servName,servAddr,servGroup: string;

procedure asktoower(par: string);
begin
case par of
'strings': begin
  if not askedower then begin
    if FileExists(ExpandConstant(CurrentFileName)) then
      if MsgBox('Найдены файлы с настройками скрипта.'#13#13 + 'Хотите сохранить настройки?',mbConfirmation, MB_YESNO) = IDYES then
        owertexts := false else owertexts := true;
 end;
 if owertexts then deletefile(ExpandConstant(CurrentFileName));
 askedower := true;
 end;
end;
end;

procedure InitializeWizard;
begin
  { Create the pages }
  UserinfoPage := CreateInputQueryPage(wpSelectDir,
    'Информация о пользователе', 'Пожалуйста, заполните поля и нажмите "Далее".',
    'В большинстве сетей в нике разрешено использовать только латинские символы и некоторые вспомогательные символы ([,],|,~ и др.)');
  UserinfoPage2 := CreateInputQueryPage(UserinfoPage.ID,
    'Информация о пользователе, продолжение', 'Пожалуйста, заполните поля и нажмите "Далее".',
    'Идентификатор используется для выделения пользователей из одной подсети. Состоит из латинских символов и цифр, не более 10 символов в длинну (сервер сам обрежет лишнее) создается из системного адреса e-mail.');

  UserSexPage := CreateInputOptionPage(UserinfoPage2.ID,
    'Пол пользователя', 'Пожалуйста, укажите пол пользователя и нажмите "Далее".',
    '',
    True, False);
    
  UserSexPage.add('Мужской');
  UserSexPage.add('Женский');
  UserSexPage.add('Неизвестный');
  UserSexPage.add('Множественные лица');
  
  ServerNamePage := CreateInputOptionPage(UserSexPage.ID,
    'Сервер', 'Пожалуйста, выберите сервер и нажмите "Далее".',
    '',
    True, False);

  UserThemePage := CreateInputOptionPage(ServerNamePage.ID,
    'Цветовая схема', 'Пожалуйста, выберите цветовую тему по умолчанию и нажмите "Далее".',
    'Цветовую схему можно настроить в меню, вызываемом по комбинации клавиш Alt+K. Доступны несколько тем и возможна тонкая настройка цвета.',
    True, False);

  ServerInfoPage := CreateInputQueryPage(ServerNamePage.ID,
    'Информация о сервере', 'Пожалуйста, заполните поля и нажмите "Далее".',
    'Если у вас уже установлен в настройках сервер, укажите Пользовательский');
  ServerInfoPage.add('Описание',False);
  ServerInfoPage.add('Сервер:Порт:Пароль',False);
  ServerInfoPage.add('Группа',False);

  ServerNamePage.add('Пользовательский');
  ServerNamePage.add('Сервер Навигатора Игрового Мира');
  ServerNamePage.add('Сервер провайдера Qwerty (Wenet)');
  ServerNamePage.add('Сервер Северное Бутово (IrcNet.ru)');
  ServerNamePage.add('Сервер ChatNet (DALNet.ru)');
  ServerNamePage.add('Сервер RusNet (RusNet)');
  //ServerNamePage.add('Сервер проекта Media Solipse');
  
  UserinfoPage.add('Основной ник',False);
  UserinfoPage.add('Альтернативный ник - используется автоматически, если основной ник занят.',False);
  UserinfoPage2.add('Почтовый адрес - используется при регистрации ника. Некоторые сети позволяют регистрацию без почтового адреса, тогда используется строчка NOMAIL.',False);
  UserinfoPage2.add('Системный адрес E-mail',False);

  UserThemePage.add('Magic Dark — чёрный фон и малиновый текст.');
  UserThemePage.add('Magic Gray — тёмно-серый фон и текст цвета морской волны.');
  UserThemePage.add('Magic Light — белый фон и фиолетовый текст.');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  res: boolean;
  errormes,mini,muser,msetup,tempstr,tmpnick: string;
  tempnum: integer;
begin
res := true;
case CurPageID of
 {после окна выбора папки}
 wpSelectDir: begin
  mini := ExpandConstant('{app}\mirc.ini');
  muser := ExpandConstant('{app}\Strings\user.ini');
  msetup := ExpandConstant('{app}\Strings\setup.ini');
  UserThemePage.SelectedValueIndex := 0;
 if FileExists(mini) then begin
   tempstr := GetIniString('mirc','host','',mini);
   tempnum := pos('SERVER:',tempstr);
   if tempnum > 0 then begin
     servName := copy(tempstr,0,tempnum - 1);
     delete(tempstr,1,tempnum + 6);
     tempnum := pos('GROUP:',tempstr);
     if tempnum > 0 then begin
       servAddr := copy(tempstr,0,tempnum - 1);
       servGroup := copy(tempstr,tempnum + 6,length(tempstr));
     end else servAddr := tempstr;
   end;
   case GetIniString('text','theme','',mini) of
   'Magic Dark': UserThemePage.SelectedValueIndex := 0;
   'Magic Gray': UserThemePage.SelectedValueIndex := 1;
   'Magic Light': UserThemePage.SelectedValueIndex := 2;
   '': UserThemePage.SelectedValueIndex := 0;
   else begin
      UserThemePage.Add('Пользовательская (без изменений)');
      UserThemePage.SelectedValueIndex := 3;
   end;
   end;
 end;
 if FileExists(msetup) then begin
   UserinfoPage.Values[0] := GetIniString('user','nick',GetIniString('user','nick','nick' + inttostr(random(9)) + inttostr(random(9)) + inttostr(random(9)),muser),msetup);
   UserinfoPage.Values[1] := GetIniString('user','anick',GetIniString('user','anick','nick' + inttostr(random(9)) + inttostr(random(9)) + inttostr(random(9)),muser),msetup);
   UserinfoPage2.Values[0] := GetIniString('user','pass.mail',GetIniString('user','pass.mail','NOMAIL',muser),msetup);
   UserinfoPage2.Values[1] := GetIniString('mirc','email',GetIniString('mirc','email','magic' + inttostr(random(9))+ inttostr(random(9)) + inttostr(random(9)) + '@email.net',mini),mini);
   UserSexPage.SelectedValueIndex := 0;
   case GetIniString('user','sex','m',muser) of
   'f': UserSexPage.SelectedValueIndex := 1;
   'u': UserSexPage.SelectedValueIndex := 2;
   'n': UserSexPage.SelectedValueIndex := 3;
   else UserSexPage.SelectedValueIndex := 0; end;
   case GetIniString('user','sex','m',msetup) of
   'f': UserSexPage.SelectedValueIndex := 1;
   'u': UserSexPage.SelectedValueIndex := 2;
   'n': UserSexPage.SelectedValueIndex := 3;
   else UserSexPage.SelectedValueIndex := 0;
   end;
 end else begin
   tmpnick  :=  'nick' + inttostr(random(9)) + inttostr(random(9)) + inttostr(random(9));
   UserinfoPage.Values[0] := tmpnick;
   UserinfoPage.Values[1] := 'nick' + inttostr(random(9)) + inttostr(random(9)) + inttostr(random(9));
   UserinfoPage2.Values[0] := 'NOMAIL';
   UserinfoPage2.Values[1] := 'magic' + inttostr(random(9))+ inttostr(random(9)) + inttostr(random(9)) + '@email.net';
   UserSexPage.SelectedValueIndex := 0;
 end;
 {Сервачок}
 ServerNamePage.SelectedValueIndex := 1;
    end;
  {после окна настроек пользователя}
      UserinfoPage.ID: begin
       if CompareText(UserinfoPage.Values[0],tmpnick) = 0 then begin errormes := 'Не рекомендуется использовать сгенерированный ник, придумайте свой ник!'; tmpnick := ''; end;
       if UserinfoPage.Values[0] = '' then errormes := 'Вы не ввели ник.'
       if UserinfoPage.Values[1] = '' then  if errormes = '' then errormes := 'Вы не ввели альтернативный ник.' else errormes := errormes + #13#13 + 'Вы не ввели альтернативный ник.'
       if errormes <> '' then begin
        MsgBox(errormes, mbError, MB_OK);
        res := False;
       end;
       errormes := '';
      end;
      UserinfoPage2.ID: begin
       if UserinfoPage2.Values[0] = '' then  errormes := 'Вы не ввели почтовый адрес.'
       if UserinfoPage2.Values[1] = '' then  if errormes = '' then errormes := 'Вы не ввели идентификатор.' else errormes := errormes + #13#13 + 'Вы не ввели идентификатор.'
       if errormes <> '' then begin
        MsgBox(errormes, mbError, MB_OK);
        res := False;
       end;
       errormes := '';
      end;


  {после окна выбора сервера}
  ServerNamePage.ID: begin
    case ServerNamePage.SelectedValueIndex of
    0: begin
         ServerInfoPage.Values[0] := servName;
         ServerInfoPage.Values[1] := servAddr;
         ServerInfoPage.Values[2] := servGroup;
       end;
    1: begin
         ServerInfoPage.Values[0] := 'Сервер Навигатора Игрового Мира';
         ServerInfoPage.Values[1] := 'irc.gamenavigator.ru:6667';
         ServerInfoPage.Values[2] := '';
       end;
    2: begin
         ServerInfoPage.Values[0] := 'Провайдер Qwerty';
         ServerInfoPage.Values[1] := 'irc.qwerty.ru:6667';
         ServerInfoPage.Values[2] := 'WeNet.ru';
       end;
    3: begin
         ServerInfoPage.Values[0] := 'Сервер Северное Бутово';
         ServerInfoPage.Values[1] := 'butovo.ircnet.ru:6667';
         ServerInfoPage.Values[2] := 'IrcNet.ru';
       end;
    4: begin
         ServerInfoPage.Values[0] := 'ChatNet';
         ServerInfoPage.Values[1] := 'irc.chatnet.ru:6667';
         ServerInfoPage.Values[2] := 'DALNet.ru';
       end;
    5: begin
         ServerInfoPage.Values[0] := 'Rusnet';
         ServerInfoPage.Values[1] := 'irc.rusnet.org.ru:6669';
         ServerInfoPage.Values[2] := 'RusNet';
       end;
    6: begin
         ServerInfoPage.Values[0] := 'Проект Media Solipse';
         ServerInfoPage.Values[1] := 'media.solipse.ru:6667';
         ServerInfoPage.Values[2] := 'Solipse';
       end;
    end;
  end;

end;
if res then result := true else result := false;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  if (PageID = ServerInfoPage.ID) and (ServerNamePage.SelectedValueIndex <> 0) then Result := True
 else
    Result := False;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var overwrite: boolean;
    mini,muser,msetup: string;
begin
  if CurStep = ssPostInstall then begin
mini := ExpandConstant('{app}\mirc.ini')
muser := ExpandConstant('{app}\Strings\user.ini');
msetup := ExpandConstant('{app}\Strings\setup.ini');
 if FileExists(mini) then begin
  FileCopy(mini,ExpandConstant('{app}\mirc.ini.bak'),False);
    if MsgBox('Найден файл mirc.ini, желаете сохранить свои настройки?'#13#13 + 'Ваши текущие настройки сохранены в mirc.ini.bak.', mbConfirmation, MB_YESNO) = IDNO then overwrite := true;
  end else overwrite := true;

 if overwrite then begin
   deleteinisection('text',mini)
   deleteinisection('options',mini)
   deleteinisection('pfiles',mini)
   deleteinisection('clicks',mini)
   deleteinisection('mirc',mini)
   deleteinisection('colors',mini)
   deleteinisection('palettes',mini)
 end;
 setinistring('text','aptitle','Магический чат, версия 0.7.0.6',mini);
 if overwrite then begin
   setinistring('text','quit','$quit.msg',mini);
   setinistring('text','finger','$ctcp.finger.ans',mini);
   if UserThemePage.SelectedValueIndex = 0 then setinistring('text','theme','Magic Dark',mini);
   if UserThemePage.SelectedValueIndex = 1 then setinistring('text','theme','Magic Gray',mini);
   if UserThemePage.SelectedValueIndex = 2 then setinistring('text','theme','Magic Light',mini);
   setinistring('text','defport','6667',mini);
   setinistring('text','commandchar','/',mini);
   setinistring('text','linesep','-',mini);
   setinistring('text','timestamp','[HH:nn:ss]',mini);
   setinistring('text','logstamp','[HH:nn:ss]',mini);
   setinistring('text','accept','*.jpg,*.gif,*.png,*.bmp,*.txt,*.log,*.wav,*.mid,*.mp3,*.wma,*.ogg,*.zip',mini);
   setinistring('text','ignore','*.exe,*.com,*.bat,*.dll,*.ini,*.mrc,*.vbs,*.js,*.pif,*.scr,*.lnk,*.pl,*.shs,*.htm,*.html,*.wmf',mini);

   setinistring('options','n0','1,1,0,1,1,1,300,0,0,1,1,1,0,0,0,0,1,0,1,0,2048,0,1,4,0,0,1,1,0,50,1,1,0,0,0',mini);
   setinistring('options','n1','5,100,1,1,4490,2,23,0,7,1,0,1,1,1,1,0,1,1,0,0,0,1,1,1,5,1,1,0,0,0,1,0,1,0,1,10',mini);
setinistring('options','n2','0,0,0,1,0,1,1,1,0,60,120,0,0,1,0,0,0,1,0,120,20,10,0,0,0,1,1,1,0,0,1,1,0,0,1,1',mini);
setinistring('options','n3','30000,1,0,1,1,0,0,1,0,0,0,1,0,1,1,1,1,1,0,0,0,0,1,1,0,1,0,8,0,0,0,3,180,0,1,0,0',mini);
setinistring('options','n4','1,0,1,2,0,0,9999,0,0,1,1,1,1024,0,1,99,60,0,1,0,0,1,1,3,0,5000,1,5,0,1,13,0,1,1,0,1,1',mini);
setinistring('options','n5','1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1,0,300,10,4,0,1,29,0,0,1,8192,1,0,0,85,0,1,0,0',mini);
setinistring('options','n6','0,1,0,1,1,1,1,1,1,1,0,0,0,0,1,1,0,1,0,1,0,0,500,1,1,0,1,0,0,1,4,1,1,1,0,0',mini);
setinistring('options','n7','1,0,0,0,0,1,0,1,1,1,1,0,0,1,0,0,1,70,0,60,0,1,1,1,1,1,0,0,1,0,1,0,1,1,1,0,1',mini);
setinistring('options','n8','2,3,0,212,1,1,0,2,0,0,0,0,0,0,0,0,1,0,0,0,0,0,168,1,0',mini);

   setinistring('fonts','fstatus','Verdana,411,204,2',mini);
   setinistring('fonts','fchannel','Verdana,411,204,2',mini);
   setinistring('fonts','fquery','Verdana,411,204,2',mini);
   setinistring('fonts','f#navigator-central','Verdana,411,204,2',mini);
   setinistring('fonts','f#quiz','Verdana,411,204,2',mini);
   setinistring('fonts','f#hellfire','Verdana,411,204,2',mini);

 end;
 setinistring('pfiles','n0','scripts\remote.ini',mini);
 setinistring('pfiles','n1','scripts\remote.ini',mini);
 setinistring('pfiles','n2','scripts\remote.ini',mini);
 setinistring('pfiles','n3','scripts\remote.ini',mini);
 setinistring('pfiles','n4','Scripts\popup.mrc',mini);

 deleteinisection('rfiles',mini)
 setinistring('rfiles','n0','scripts\remote.ini',mini);
 setinistring('rfiles','n1','scripts\remote.ini',mini);
 setinistring('rfiles','n2','Scripts\raws.mrc',mini);
 setinistring('rfiles','n3','Scripts\popups.mrc',mini);
 setinistring('rfiles','n4','Scripts\setups.mrc',mini);
 setinistring('rfiles','n5','Scripts\help.mrc',mini);
 setinistring('rfiles','n6','Scripts\logviewer.mrc',mini);

 deleteinisection('afiles',mini)
 setinistring('afiles','n0','scripts\vizaliases.mrc',mini);
 setinistring('afiles','n1','scripts\stuffaliases.mrc',mini);
 setinistring('afiles','n2','scripts\sysaliases.mrc',mini);

 setinistring('clicks','status','click.status $1',mini);
 setinistring('clicks','query','click.query $1',mini);
 setinistring('clicks','channel','click.channel $1',mini);
 setinistring('clicks','nicklist','click.nick $1',mini);
 setinistring('clicks','notify','click.notify $1',mini);
 setinistring('clicks','message','click.mes $1',mini);

 setinistring('highlight','n0','2,0,0,0,,,"$me",0',mini);

 if overwrite then begin
   setinistring('mirc','user','Использующий магию',mini);
   setinistring('mirc','email',UserinfoPage2.Values[1],mini);
 end;
 setinistring('mirc','host',ServerInfoPage.Values[0] + 'SERVER:' + ServerInfoPage.Values[1] + 'GROUP:' + ServerInfoPage.Values[2],mini);

 setinistring('colors','n0','Magic Dark,0,8,9,4,1,1,12,11,7,3,11,13,9,7,6,14,7,8,3,5,1,0,1,0,13,15,6,14',mini);
 setinistring('colors','n1','Magic Gray,15,10,5,4,0,1,12,12,7,3,12,11,9,5,11,1,7,8,3,5,2,15,0,15,0,1,5,15',mini);
 setinistring('colors','n2','Magic Light,15,8,4,7,2,3,4,2,3,0,2,6,5,2,6,14,1,14,12,5,12,15,1,15,1,14,5,0',mini);
 if overwrite then begin
   setinistring('colors','n3','mIRC Classic,0,6,4,5,2,3,3,3,3,3,3,1,5,7,6,1,3,2,3,5,1,0,1,0,1,15,6,0',mini);
   setinistring('colors','n4','mIRC Modern,0,6,4,7,2,3,4,3,3,3,3,1,5,2,6,1,14,2,3,5,1,0,1,0,1,14,5,0',mini);
   setinistring('colors','n5','Monochrome State,1,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,1,15,1,15,15,15,14',mini);
   setinistring('colors','n6','NoName script,11,2,1,1,1,1,12,12,12,12,12,1,1,12,1,1,12,12,12,1,1,11,1,11,1,1,1,11',mini);
   setinistring('colors','n7','pIRC script,1,0,11,14,3,3,13,7,4,9,8,0,11,6,0,7,4,5,3,8,11,1,0,1,7,15,14,1',mini);
   setinistring('colors','n8','Placid Hues,0,2,4,7,2,3,3,3,3,15,3,1,5,7,6,1,3,2,3,5,1,0,1,0,1,15,6,0',mini);
   setinistring('colors','n9','Rainbow Sky,0,7,4,5,1,1,3,3,8,13,3,14,2,7,13,5,3,8,3,4,14,0,5,0,3,14,10,0',mini);
 end;

 setinistring('palettes','n0','0,16777215,16711808,37632,255,127,10158219,32764,65535,64512,8421376,16776960,16721960,16715263,5395026,13816530',mini);
 setinistring('palettes','n1','16777215,0,10485760,37632,255,127,10223772,27865,65535,64512,10008577,13421568,16515072,16715263,16776960,5789784',mini);
 setinistring('palettes','n2','12632256,0,8323072,37632,255,127,10223772,32764,50886,64512,9671424,16776960,16515072,16711935,8355711,16777215',mini);
 if overwrite then begin
   setinistring('palettes','n3','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
   setinistring('palettes','n4','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
   setinistring('palettes','n5','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
   setinistring('palettes','n6','0,16777215,9561087,37632,255,127,10223772,32764,65535,64512,16739081,3947580,48379,16711935,4669494,11115405',mini);
   setinistring('palettes','n7','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
   setinistring('palettes','n8','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
   setinistring('palettes','n9','16777215,0,8323072,37632,255,127,10223772,32764,65535,64512,9671424,16776960,16515072,16711935,8355711,13816530',mini);
 end;

 if overwrite then deleteinisection('cnicks',mini);
 setinistring('cnicks','n0','$me,2,,,0,0,0,0,0',mini);
 setinistring('cnicks','n1',',15,,,1,1,0,0,30',mini);
 if overwrite then begin
   setinistring('cnicks','n2',',11,,,0,0,1,0,0',mini);
   setinistring('cnicks','n3',',1,.,,0,0,0,0,0',mini);
   setinistring('cnicks','n4',',3,@,,0,0,0,0,0',mini);
   setinistring('cnicks','n5',',7,%,,0,0,0,0,0',mini);
   setinistring('cnicks','n6',',14,+,,0,0,0,0,0',mini);
 end;

 if overwrite then deleteinisection('chanfolder',mini);
 setinistring('chanfolder','n0','#navigator-central,"Центральный канал чата «Навигатора»",,"gamenavigator",1,,"Навигатор"',mini);
 setinistring('chanfolder','n1','#quiz,"Викторина в чатах «Навигатора»",,"gamenavigator",1,,"Навигатор"',mini);
 setinistring('chanfolder','n2','#butovo,"Канал Бутово",,"IrcNet.ru",1,,"Butovo"',mini);
 setinistring('chanfolder','n3','#butovo_point,"Канал бутовских поинтовщиков",,"IrcNet.ru",1,,"Butovo"',mini);
 setinistring('chanfolder','n4','#centel,"Бутовский канал сети Qwerty",,"IrcNet.ru",1,,"Butovo"',mini);
 setinistring('chanfolder','n5','#qwerty,"Центральный канал Qwerty",,"WeNet",1,,"Qwerty"',mini);
 setinistring('chanfolder','n6','#yellow,"Игровой канал сети Qwerty",,"WeNet",,,"Qwerty"',mini);
 setinistring('chanfolder','n7','#hellfire,,,,1,,"Hellfire"',mini);

 setinistring('dirs','logdir','logs\',mini);
setinistring('dirs','waves','sounds\',mini);
setinistring('dirs','midis','sounds\',mini);
setinistring('dirs','mp3s','sounds\',mini);
setinistring('dirs','wmas','sounds\',mini);
setinistring('dirs','oggs','sounds\',mini);

setinistring('about','version','6.31',mini);
setinistring('about','show','no',mini);

setinistring('language','sjis','0',mini);
setinistring('language','multibyte','1',mini);
setinistring('language','mbed','0',mini);
setinistring('language','utf','1',mini);
setinistring('language','linking','1',mini);

//  if FileExists(muser) then FileCopy(muser,ExpandConstant('{app}\strings\user.ini.bak'),False);
  setinistring('user','nick',UserinfoPage.Values[0],msetup);
  setinistring('user','anick',UserinfoPage.Values[1],msetup);
  setinistring('user','pass.email',UserinfoPage2.Values[0],msetup);
  setinistring('user','timestamp',GetIniString('user','timestamp',GetIniString('user','timestamp','[HH:nn:ss]',muser),msetup),msetup);
  case UserSexPage.SelectedValueIndex of
   1: setinistring('user','sex','f',msetup);
   0: setinistring('user','sex','m',msetup);
   2: setinistring('user','sex','u',msetup);
   3: setinistring('user','sex','n',msetup);
  end;
  
  setinistring('str','scriptname','Magic mIRC Script',msetup);
  setinistring('str','nickins',GetIniString('str','nickins','3 $+ %nick $+ 4, %mes',msetup),msetup);
  setinistring('str','status.click',GetIniString('str','status.click','Сервер $+ %colors.server $server подключен к сети $+ %colors.server $network',msetup),msetup);
  setinistring('str','servecho',GetIniString('str','servecho','$network $+ 9: Сервис $1 $+ 9| $2-',msetup),msetup);
  setinistring('str','finger.ans',GetIniString('str','finger.ans','Пальцем не тыкать!',msetup),msetup);
  setinistring('str','quit.mes',GetIniString('str','quit.mes','$iif($network == gamenavigator,http://magic.gamenavigator.ru,Magic Script %str.version от %str.vdate $+ )',msetup),msetup);
                         {Версия}
  setinistring('str','version','0.7.0.6',msetup);
  setinistring('str','vdate','10.11.07',msetup);
  setinistring('str','away.msg',GetIniString('str','away.msg','10уш $+ $sex(ел,ла,ло,ли) 3Причина:10 $1-',msetup),msetup);
  setinistring('str','away.return',GetIniString('str','away.return','10вернул $+ $sex(ся,ась,ось,ись) 3Уходил $+ $sex(,а,о,и) $+ 10 $duration($awaytime,3) 3назад по причине:10 $awaymsg',msetup),msetup);
  setinistring('str','away.repeat',GetIniString('str','away.repeat','10не здесь, 3уш $+ $sex(ел,ла,ло,ли) $+ 10 $duration($awaytime,3) 3назад по причине:10 $awaymsg',msetup),msetup);
  setinistring('str','away.change',GetIniString('str','away.change','10уходил $+ $sex(,а,о,и) $duration($awaytime,3) 3назад по причине:10 $awaymsg 3Теперь уш $+ $sex(ел,ла,ло,ли) по причине:10 $1-',msetup),msetup);
  setinistring('str','away.nochange',GetIniString('str','away.nochange','10Причина ухода совпадает с текущей',msetup),msetup);
  setinistring('str','away.nick',GetIniString('str','away.nick',UserinfoPage.Values[0],msetup),msetup);
  setinistring('str','away.end',GetIniString('str','away.end','_afk',msetup),msetup);
  setinistring('str','away.pre',GetIniString('str','away.pre','[AFK]',msetup),msetup);
  
  setinistring('colors','owntext',GetIniString('colors','owntext','15',msetup),msetup);
  setinistring('colors','ownaction',GetIniString('colors','ownaction','14',msetup),msetup);
  setinistring('colors','ownnotice',GetIniString('colors','ownnotice','15',msetup),msetup);
  setinistring('colors','ownctcp',GetIniString('colors','ownctcp','14',msetup),msetup);
  setinistring('colors','err.com',GetIniString('colors','err.com','10',msetup),msetup);
  setinistring('colors','err.raw',GetIniString('colors','err.raw','10',msetup),msetup);
  setinistring('colors','cmd.raw',GetIniString('colors','cmd.raw','14',msetup),msetup);
  setinistring('colors','chan',GetIniString('colors','chan','09',msetup),msetup);
  setinistring('colors','n.my',GetIniString('colors','n.my','13',msetup),msetup);
  setinistring('colors','n.friend',GetIniString('colors','n.friend','12',msetup),msetup);
  setinistring('colors','n.bot',GetIniString('colors','n.bot','13',msetup),msetup);
  setinistring('colors','n.enemy',GetIniString('colors','n.enemy','06',msetup),msetup);
  setinistring('colors','n.prot',GetIniString('colors','n.prot','05',msetup),msetup);
  setinistring('colors','n.op',GetIniString('colors','n.op','13',msetup),msetup);
  setinistring('colors','n.voice',GetIniString('colors','n.voice','15',msetup),msetup);
  setinistring('colors','n.hop',GetIniString('colors','n.hop','14',msetup),msetup);
  setinistring('colors','n.none',GetIniString('colors','n.none','00',msetup),msetup);
  setinistring('colors','system',GetIniString('colors','system','10',msetup),msetup);
  setinistring('colors','mask1',GetIniString('colors','mask1','09',msetup),msetup);
  setinistring('colors','mask2',GetIniString('colors','mask2','11',msetup),msetup);
  setinistring('colors','server',GetIniString('colors','server','09',msetup),msetup);

  setinistring('nums','away.rep.mins',GetIniString('nums','away.rep.mins','50',msetup),msetup);
  setinistring('nums','menulist.len',GetIniString('nums','menulist.len','15',msetup),msetup);

  setinistring('prefs','ignoreraws',GetIniString('prefs','ignoreraws','321 322 323 324',msetup),msetup);
  setinistring('prefs','whois.show.idle',GetIniString('prefs','whois.show.idle','$true',msetup),msetup);
  setinistring('prefs','nickinsert.type',GetIniString('prefs','nickinsert.type','3',msetup),msetup);
  setinistring('prefs','multiserver',GetIniString('prefs','multiserver','$false',msetup),msetup);
  setinistring('prefs','mserver.away',GetIniString('prefs','mserver.away','$true',msetup),msetup);
  setinistring('prefs','mserver.quit',GetIniString('prefs','mserver.quit','$true',msetup),msetup);
  setinistring('prefs','mserver.nick',GetIniString('prefs','mserver.nick','$true',msetup),msetup);
  setinistring('prefs','servers',GetIniString('prefs','servers',ServerInfoPage.Values[1],msetup),msetup);
  setinistring('prefs','clock',GetIniString('prefs','clock','$false',msetup),msetup);
  setinistring('prefs','clock.window',GetIniString('prefs','clock.window','$false',msetup),msetup);
  setinistring('prefs','clock.xy',GetIniString('prefs','clock.xy','30 30',msetup),msetup);
  setinistring('prefs','away.nickmode',GetIniString('prefs','away.nickmode','3',msetup),msetup);
  setinistring('prefs','away.mesmode',GetIniString('prefs','away.mesmode','describe',msetup),msetup);
  setinistring('prefs','away.mesmid',GetIniString('prefs','away.mesmid','$false',msetup),msetup);
  setinistring('prefs','away.mes',GetIniString('prefs','away.mes','$true',msetup),msetup);
  setinistring('prefs','help.autostart',GetIniString('prefs','help.autostart','$true',msetup),msetup);

end;
end;


