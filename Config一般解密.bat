@ECHO OFF

::�H�t�κ޲z����������
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo �ХH�t�κ޲z�������Ұ�...
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

echo �ѱK�}�l

::���o�M�׵�����|
set /p ProPath=�M�׵�����|:

::���ʥؿ�
set ProDrive=%ProPath:~0,2%
%ProDrive%
cd %ProPath%

::�P�_�O�_������{��
for /f %%1 in ('dir *.exe.config /b') do (set ConfigName=%%1)
if {%ConfigName%}=={} (set Remove=0)^
else (
 set /a Remove=1
)

::�P�_�O�_������{���]��web.config
if %Remove% equ 1 (
 if exist %cd%\web.config (
 echo.
 echo ���~:�P�ɦ�web.config��%ConfigName%
 echo.
 goto �ѱK����
 )^
 else rename %ConfigName% web.config
)

echo %CD%
::�����ؿ�
c:
::cd C:\Windows\Microsoft.NET\Framework64\v2.0.50727\
cd C:\Windows\Microsoft.NET\Framework64\v4.0.30319\

::����[�K
aspnet_regiis -pdf connectionStrings "%ProPath%"

::�Y�O������{���A��^���ɦW
if %Remove% equ 1 (
 %ProDrive%
 cd %ProPath%
 rename web.config %ConfigName%
)

:�ѱK����
echo �ѱK����
pause
exit