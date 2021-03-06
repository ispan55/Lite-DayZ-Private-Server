@echo off
TITLE Lite DayZ Private Server: Server Setup
goto MySQL_Login

:MySQL_Login
cls
echo.
echo MySQL Login Information
echo.
echo.
set /P mysqluser=Username: 
echo.
set /P mysqlpass=Password: 
echo.
set /P mysqldb=Database: 
echo.
goto Folder_Checker

:Folder_Checker
cls
if not exist MPMissions md MPMissions
if not exist Keys md Keys
goto Mod_Selection

:Mod_Selection
cls
echo.
set /P mod=Mod Code: 
if "%mod%"=="chernarus" set modname=DayZ& set clientmod=@DayZ& goto Mod_Downloader
if "%mod%"=="i44"  set modname=DayZInvasion-1944& set clientmod=@DayZ_i44;@I44;@CBA;@CBA_CO;@CBA_OA;@CBA_A2& goto Mod_Downloader
if "%mod%"=="plus"  set modname=DayZPlus& set clientmod=@DayZ+& goto Mod_Downloader
if "%mod%"=="2017" set modname=DayZ2017& set clientmod=@DayZ2017& goto Mod_Downloader
if "%mod%"=="namalsk"  set modname=DayZNamalsk& set clientmod=@DayZ;@DayZ_Namalsk& goto Mod_Downloader
if "%mod%"=="sahrani" set modname=DayZSahrani& set clientmod=@DayZ_Sahrani& goto Mod_Downloader
if "%mod%"=="isladuala" set modname=DayZIsladuala& set clientmod=@DayZIsladuala& goto Mod_Downloader
if "%mod%"=="thirsk" set modname=DayZThirsk& set clientmod=@DayZThirsk& goto Mod_Downloader
if "%mod%"=="thirskwinter" set modname=DayZThirsk-Winter& set clientmod=@DayZThirsk& goto Mod_Downloader
if "%mod%"=="lingor" set modname=DayZLingor& set clientmod=@DayZLingorSkaro& goto Mod_Downloader
if "%mod%"=="celle" set modname=DayZCelle& set clientmod=@DayZ_Celle;@Dayz_Conflicts;@mbg_celle& goto Mod_Downloader
if "%mod%"=="fallujah" set modname=DayZFallujah& set clientmod=@DayZFallujah& goto Mod_Downloader
if "%mod%"=="panthera" set modname=DayZPanthera& set clientmod=@DayZPanthera& goto Mod_Downloader
if "%mod%"=="takistan" set modname=DayZTakistan& set clientmod=@DayZTakistan& goto Mod_Downloader
if "%mod%"=="utes" set modname=DayZUtes& set clientmod=@DayZUtes& goto Mod_Downloader
if "%mod%"=="zargabad" set modname=DayZZargabad& set clientmod=@DayZZargabad& goto Mod_Downloader
if "%mod%"=="oring" set modname=DayZOring& set clientmod=@DayZ_Oring& goto Mod_Downloader
goto Mod_Error

:Mod_Error
cls
echo.
echo Invalid Mod Code, Press Any Key To Enter Another One...
pause > NUL
goto Mod_Selection

:Mod_Downloader
cls
if exist Config_%modname% del Config_%modname%
if exist @Server_%modname% del @Server_%modname%
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Config/Config.pbo
Resources\cpbo.exe -Y -E Config.pbo Config_%modname% > NUL
del Config.pbo
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Keys/Keys.pbo
Resources\cpbo.exe -Y -E Keys.pbo ./Keys/ > NUL
del Keys.pbo
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Mission/Mission.pbo
Resources\cpbo.exe -Y -E Mission.pbo ./MPMissions/ > NUL
del Mission.pbo
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Schema/Tables.sql
Resources\mysql.exe --user=%mysqluser% --password=%mysqlpass% --host=127.0.0.1 --port=3306 --database=%mysqldb% < Tables.sql
del Tables.sql
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Schema/Functions.sql
Resources\mysql.exe --user=%mysqluser% --password=%mysqlpass% --host=127.0.0.1 --port=3306 --database=%mysqldb% < Functions.sql
del Functions.sql
Resources\wget.exe -N --quiet --no-check-certificate https://github.com/Stapo/Lite-Repo/raw/master/Mods/%modname%/Server/Server.pbo
Resources\cpbo.exe -Y -E Server.pbo @Server_%modname% > NUL
del Server.pbo
goto Finish

:Finish
cls
echo.
echo You Have Successfully Built A %modname% Server
echo.
echo.
pause
if exist Start_%modname%_Server.bat del Start_%modname%_Server.bat
echo @echo off >> Start_%modname%_Server.bat
echo Resources\mysql.exe --user=%mysqluser% --password=%mysqlpass% --host=127.0.0.1 --port=3306 --database=%mysqldb% --execute="call pMain()" >> Start_%modname%_Server.bat
echo start .\Expansion\beta\arma2oaserver.exe -port=2302 -mod=expansion\beta;expansion\beta\expansion;%clientmod%;@Server_%modname% -name=DayZ -config=Config_%modname%\ServerSettings.cfg -cfg=Config_%modname%\Arma2Config.cfg -profiles=Config_%modname% >> Start_%modname%_Server.bat
echo exit >> Start_%modname%_Server.bat
if exist README.md move /Y README.md Resources 
if exist Server_Setup.bat move /Y Server_Setup.bat Resources 
exit