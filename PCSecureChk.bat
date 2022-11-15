@echo off

@REM 避免亂碼
chcp 65001

@REM 確認作業系統是x86還是x64
set archbit=""
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
  set archbit=x86
) else (
  set archbit=x64
)

cls

@REM 取IP位址
FOR /F "delims=: tokens=2" %%a in ('ipconfig ^| find "  IPv4"') do ( 
  if "!counter!"=="%1" goto :eof
  set IPAddress=%%a
  set /a counter+=1
)
for /f "tokens=* delims= " %%a in ("%IPAddress%") do set IPAddress=%%a

@REM 取主機名稱
for /f %%i in ('hostname') do set hostname=%%i

@REM 取日期
set tmpDate=
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined tmpDate set tmpDate=%%x
set YYYYMMDD=%tmpDate:~0,4%%tmpDate:~4,2%%tmpDate:~6,2%

@REM ========主選單========
:menu
echo 主機名稱：%hostname%
echo 執行路徑：%~dp0
echo 本機IP：%IPAddress%
echo 系統日期：%YYYYMMDD%
echo.
echo 這個批次檔是用來檢測使用者PC資安設定
echo 使用限制：Windows 10 1709 (組建 16299) 或更新版本
echo -----------------------------------------------------
echo 1 - 檢視IP設定(ipconfig)
echo 2 - 作業系統版本(winver)
echo 3 - 防火牆(wf.msc)
echo 4 - 事件檢視器(eventvwr.msc)
echo 5 - 群組原則管理員(gpedit.msc)
echo 6 - 使用者清單(net user)
echo 7 - 管理員群組名單(net localgroup administrators)
echo 8 - 安裝軟體(control appwiz.cpl)
echo 9 - 系統校時設定(control timedate.cpl)
echo a - 螢幕保護裝置設定(control desk.cpl,,@screensaver)
echo b - 電腦管理(compmgmt.msc)
echo c - 網路連線(ncpa.cpl)
echo d - 軟體安裝檢查細項
echo e - 惡意程式檢測工具
echo -----------------------------------------------------
echo 0 - 結束程式
echo.

@REM ========主選單取值========
set /p end=請選擇要執行的項目(按0結束):

@REM ========判斷要走哪個指令========
if %end%==1 goto ip
if %end%==2 goto winv
if %end%==3 goto wf
if %end%==4 goto event
if %end%==5 goto gp
if %end%==6 goto lstuser
if %end%==7 goto lstadm
if %end%==8 goto sflst
if %end%==9 goto tcl
if %end%==a goto scr
if %end%==b goto com
if %end%==c goto ncpa
if %end%==d goto submenu2
if %end%==e goto submenu1

if %end%==0 goto :eof

@REM ========次選單 - 惡意程式檢測相關工具========
:submenu1
cls
echo.
echo.
echo 子項目：惡意程式檢測工具
echo.
echo -----------------------------------------------------
echo 1 - 檢視工作管理員(taskmgr)
echo 2 - 檢視資源監視器(resmon)
echo 3 - 執行Process Explorer
echo 4 - 執行Autoruns
echo 5 - 執行TCPView
echo 6 - arp -a
echo 7 - tasklist
echo -----------------------------------------------------
echo 0 - 結束程式
echo b - 回主頁
echo.

set /p subend=請選擇要執行的項目(按0結束):

if %subend%==1 goto task
if %subend%==2 goto resmon
if %subend%==3 goto pe
if %subend%==4 goto autoruns
if %subend%==5 goto tcpview
if %subend%==6 goto arpa
if %subend%==7 goto taslst
if %subend%==b (
  cls
  goto menu
)
if %subend%==0 goto :eof

@REM ========次選單 - 軟體安裝檢查細項========
:submenu2
cls
echo.
echo.
echo 子項目：軟體安裝檢查細項
echo.
echo -----------------------------------------------------
echo 1 - 檢查是否有裝eset防毒軟體
echo 2 - 查看acrobat安裝版本
echo 3 - 查看zip或rar安裝版本
echo 4 - 查看java安裝版本
echo 5 - 查看flash player安裝版本
echo 6 - 查看瀏覽器(Browser)安裝版本
echo -----------------------------------------------------
echo 0 - 結束程式
echo b - 回主頁
echo.

set /p subopt=請選擇要執行的項目(按0結束):

if %subopt%==1 goto eset
if %subopt%==2 goto acrobat
if %subopt%==3 goto zip
if %subopt%==4 goto java
if %subopt%==5 goto flash
if %subopt%==6 goto browser
if %subopt%==0 goto :eof
if %subopt%==b (
  cls
  goto menu
)

@REM ========各項操作指令========

:ip
cls
echo.
echo 指令：ipconfig
echo IP查詢結果為：
ipconfig
echo.
pause
cls
goto menu

:wf
wf.msc
cls
goto menu

:winv
winver
cls
goto menu

:event
eventvwr
cls
goto menu

:gp
gpedit.msc
cls
goto menu

:lstuser
echo.
echo 指令：net user
net user
echo.
echo -----------------------------------------------------
set /p accopt=輸入要查詢的使用者帳號(按b回主頁/按0結束):
echo %accopt%
if %accopt%==0 (
  goto :eof
) else if %accopt%==b (
  cls
  goto menu
) else (
  cls
  echo -----------------------------------------------------
  echo 指令：net user %accopt%
  net user %accopt%
  echo -----------------------------------------------------
  echo.
  pause
  goto lstuser
)

:lstadm
cls
echo.
echo 指令：net localgroup administrators
net localgroup administrators
pause
cls
goto menu

:sflst
control appwiz.cpl
cls
goto menu

:tcl
control timedate.cpl
cls
goto menu

:scr
control desk.cpl,,@screensaver
cls
goto menu

:com
compmgmt.msc
cls
goto menu

:ncpa
ncpa.cpl
cls
goto menu

:eset
cls
echo 檢查是否有裝 eset (nod32) 防毒軟體
echo.
echo 指令：winget list --name eset
winget list --name eset
echo 指令：winget list --name nod
winget list --name nod
pause
cls
goto submenu2

:acrobat
cls
echo 檢查是否有裝 acrobat 防毒軟體
echo.
echo 指令：winget list --name acrobat
winget list --name acrobat
pause
cls
goto submenu2

:zip
cls
echo 檢查是否有裝 zip 及 rar 軟體
echo.
echo 指令：winget list --name zip
winget list --name zip
echo 指令：winget list --name rar
winget list --name rar
pause
cls
goto submenu2

:java
cls
echo 檢查是否有裝 java
echo.
echo 指令：winget list --name java
winget list --name java
pause
cls
goto submenu2

:flash
cls
echo 檢查是否有裝 flash
echo.
echo 指令：winget list --name flash
winget list --name flash
pause
cls
goto submenu2

:browser
echo.
echo 查看chrome版本...
echo 指令：winget list --name chrome
winget list --name chrome
echo.
echo 查看edge版本...
echo 指令：winget list --name edge
winget list --name edge
echo.
echo 查看firefox版本...
echo 指令：winget list --name firefox
winget list --name firefox
pause
cls
goto submenu2

:task
taskmgr
goto submenu1

:resmon
resmon
goto submenu1

:pe
if %archbit%=="x86" (
  start %~dp0\tools\procexp.exe
) else (
  start %~dp0\tools\procexp64.exe
)
goto submenu1

:autoruns
if %archbit%=="x86" (
  start %~dp0\tools\Autoruns.exe
) else (
  start %~dp0\tools\Autoruns64.exe
)
goto submenu1

:tcpview
if %archbit%=="x86" (
  start %~dp0\tools\tcpview.exe
) else (
  start %~dp0\tools\tcpview64.exe
)
goto submenu1

:arpa
cls
echo.
echo 指令：arp -a
arp -a
arp -a > "%~dp0\log\arp-%IPAddress%-%YYYYMMDD%.txt"
echo 產製arp紀錄完成...
pause
cls
goto submenu1

:taslst
cls
echo.
echo 指令：tasklist
tasklist
tasklist /V /FO TABLE > "%~dp0\log\tasklist-%IPAddress%-%YYYYMMDD%.txt"
echo 產製taslist紀錄完成...
pause
cls
goto submenu1