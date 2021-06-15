@ECHO OFF

::以系統管理員身分執行
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo 請以系統管理員身分啟動...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

echo 解密開始

::取得專案絕對路徑
set /p ProPath=專案絕對路徑:

::移動目錄
set ProDrive=%ProPath:~0,2%
%ProDrive%
cd %ProPath%

::判斷是否為單機程式
for /f %%1 in ('dir *.exe.config /b') do (set ConfigName=%%1)
if {%ConfigName%}=={} (set Remove=0)^
else (
 set /a Remove=1
)

::判斷是否為單機程式也有web.config
if %Remove% equ 1 (
 if exist %cd%\web.config (
 echo.
 echo 錯誤:同時有web.config及%ConfigName%
 echo.
 goto 解密結束
 )^
 else rename %ConfigName% web.config
)

echo %CD%
::切換目錄
c:
::cd C:\Windows\Microsoft.NET\Framework64\v2.0.50727\
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319\

::執行加密
aspnet_regiis -pdf connectionStrings "%ProPath%"

::若是為單機程式，改回原檔名
if %Remove% equ 1 (
 %ProDrive%
 cd %ProPath%
 rename web.config %ConfigName%
)

:解密結束
echo 解密結束
pause
exit