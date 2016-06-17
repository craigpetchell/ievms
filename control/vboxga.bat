REM find DVD disk drive letter
REM wmic logicaldisk drive types -> 3: Local hard disk, 4: Network disk, 5: Compact disk
for /F "skip=1" %%d IN ('wmic logicaldisk where drivetype^=5 get deviceid ^| findstr /r /v "^$"') DO (
IF NOT "%%d"=="" (set ievms_dvd_drive=%%d)
)

cd /d %ievms_dvd_drive%\
cd \cert
VBoxCertUtil.exe add-trusted-publisher oracle-vbox.cer --root oracle-vbox.cer
cd \
VBoxWindowsAdditions.exe /S
REM regedit.exe /S C:\reuac.reg
REM del C:\reuac.reg
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST=%%i
IF "%HOST%"=="IE9Win7" (
 schtasks.exe /create /s %HOST% /ru %HOST%\IEUser /rp Passw0rd! /tn ievms /xml C:\ievms.xml
) ELSE (
 schtasks.exe /Create /tn ievms /tr C:\ievms.bat /sc once /st 00:00
)
echo slmgr.vbs /ato >C:\Users\IEUser\ievms.bat
schtasks.exe /run /tn ievms
timeout /t 30
del C:\Users\IEUser\ievms.bat
shutdown.exe /s /t 00
del %0