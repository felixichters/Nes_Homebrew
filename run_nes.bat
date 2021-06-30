@echo off

set "day=%date:~0,2%"
set "month=%date:~3,2%"
set "year=%date:~6,4%"
set "hour=%time:~0,2%"
set "minute=%time:~3,2%"
set "second=%time:~6,2%"
set "backup_filename=%year%-%month%-%day%-%hour%-%minute%-%second%"

if not exist "C:\code\Homebrew\src\files\debug\" mkdir "C:\code\Homebrew\src\files\debug\"
if not exist "C:\code\Homebrew\src\files\config\" mkdir "C:\code\Homebrew\src\files\config\"
if not exist "C:\code\Homebrew\src\files\backups\" mkdir "C:\code\Homebrew\src\files\backups\"

if not exist "C:\code\Homebrew\src\files\config\name.txt" goto FileMissingName

set /p name=<"C:\code\Homebrew\src\files\config\name.txt"

if not exist "C:\code\Homebrew\src\%name%.asm" goto MakeFile

:GenerateFiles
echo generate files...
ca65 "C:\code\Homebrew\src\%name%.asm" -o "C:\code\Homebrew\src\files\debug\%name%.o" --debug-info -I C:\code\Homebrew\nesStd
echo ca65 object file generated 
ld65 "C:\code\Homebrew\src\files\debug\%name%.o" -o "C:\code\Homebrew\src\%name%.nes" -t nes --dbgfile "C:\code\Homebrew\src\files\debug\%name%.dbg"
echo ld65 nes file generated 
echo files generated
goto RunFile

:RunFile
echo starting...
start "" "C:\code\Homebrew\src\%name%.nes"
echo started
exit

:MakeFile
echo makefile...
echo ;------------------------------------------------------------------- >%name%.asm
echo ;NES ASM Project: %name% >>%name%.asm
echo ;Generated at %date% %time% >>%name%.asm
echo 
echo ;------------------------------------------------------------------- >>%name%.asm
start %name%.asm
exit

:FileMissingName
cls
echo File "C:\code\Homebrew\src\files\config\name.txt" is missing. Create it on your own
exit












