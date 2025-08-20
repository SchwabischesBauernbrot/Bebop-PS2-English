@echo off

rem #
rem #  _ \  __|  __|__ __|
rem #  |  |(    (_ |   |
rem # ___/\___|\___|  _|
rem #

set EXPECTED_ISO_SHA1SUM=3e6968ec5b83d930b9536e96f8911c7f2256c19f
set EXPECTED_ISO_ALTERNATIVE_SHA1SUM=576529dac9ea566643fd76d0dd5147fa380efe53
set EXPECTED_PATCHED_ISO_SHA1SUM=966e76a618608c9b84bfaf9756974fc91ef99d5d

echo COWBOY BEBOP PS2 PATCHER
echo English v1.0.0 by SONICMAN69
echo ============================

echo [*] Applying patch to file
echo %~1

echo [*] Finding current patcher directory
set PATCHER_CWD=%~dp0
echo %PATCHER_CWD:~0,-1%

set PATCHED_ISO=%PATCHER_CWD%COWBOY_BEBOP_PS2_ENGLISH_PATCHED_1.0.0.iso
echo %PATCHED_ISO%

echo [*] Finding patching data
set PATCHDATA=%PATCHER_CWD%patching_data\BEBOP_PS2_DCGT_EN_1.0.0
echo %PATCHDATA%

if not exist "%PATCHDATA%" (
    echo [-] Missing or corrupt patching data.
    pause
    exit 1
)

echo [*] Computing hash on received file
"%PATCHER_CWD%patching_utils\7z.exe" h -scrcSHA1 "%~1" | find /i "%EXPECTED_ISO_SHA1SUM%"
if errorlevel 1 (
    echo [-] SHA1SUM does not match. Checking if it matches an alternative hash.
    "%PATCHER_CWD%patching_utils\7z.exe" h -scrcSHA1 "%~1" | find /i "%EXPECTED_ISO_ALTERNATIVE_SHA1SUM%"
    if errorlevel 1 (
        echo [-] Invalid ISO. SHA1SUM must match "%EXPECTED_ISO_SHA1SUM%".
        echo     Please ensure that you provided the correct file and that you dumped
        echo     your disc correctly.
        echo     Drop your correct ISO file onto this file WINDOWS_DROP_BEBOP_PS2_ISO_HERE.bat.
        pause
        exit 1
    ) else (
        echo [+] ISO Accepted.
    )
)

echo [*] Valid ISO confirmed

set PATCHER_TEMP=%PATCHER_CWD%temp
set PATCHER_PATCHED_TEMP=%PATCHER_CWD%temp/patched
set PATCHER_PATCHED_TEMP_DATA=%PATCHER_CWD%temp/patched/DATA

echo [*] Creating temp directory
echo %PATCHER_TEMP%

if not exist "%PATCHER_TEMP%" mkdir "%PATCHER_TEMP%"
if not exist "%PATCHER_PATCHED_TEMP%\MODULES\IRX\" mkdir "%PATCHER_PATCHED_TEMP%\MODULES\IRX\"
if not exist "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\" mkdir "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\"
if not exist "%PATCHER_PATCHED_TEMP_DATA%" mkdir "%PATCHER_PATCHED_TEMP_DATA%"

echo [*] Extracting ISO file
"%PATCHER_CWD%patching_utils\7z.exe" x -y "%~1" -o"%PATCHER_TEMP%" | find /i "Everything is Ok"
if errorlevel 1 (
    echo [-] Could not extract ISO.
    echo     Please ensure that you have enough available disk space ^(>4 GB^)
    pause
    exit 1
)



echo [*] ISO file extracted

echo [*] Patching extracted files

if exist "%PATCHER_TEMP%/SLPS_255.51" (
    echo [*] Converting SLPS_255.51 to SLPS_255.50

    "%PATCHER_CWD%patching_utils\zstd.exe" --long=31 --force --decompress --patch-from "%PATCHER_TEMP%/SLPS_255.51" "%PATCHDATA%/SLPS_255.51_to_SLPS_255.50.zstd" -o "%PATCHER_TEMP%/SLPS_255.50"
)

"%PATCHER_CWD%patching_utils\zstd.exe" --long=31 --force --decompress --patch-from "%PATCHER_TEMP%/SLPS_255.50" "%PATCHDATA%/ISOHEADER.zstd" -o "%PATCHER_PATCHED_TEMP%/ISOHEADER"
"%PATCHER_CWD%patching_utils\zstd.exe" --long=31 --force --decompress --patch-from "%PATCHER_TEMP%/SLPS_255.50" "%PATCHDATA%/SLPS_255.50.zstd" -o "%PATCHER_PATCHED_TEMP%/SLPS_255.50"

for %%d in (DMAP, SOUND, EXTRA, SHOOT, 2DMAP, STATUS, SYSTEM, THUMBS, MODULES, 3DMAP, 3DMAP2, ROOT) do (
    "%PATCHER_CWD%patching_utils\zstd.exe" --long=31 --force --decompress --patch-from "%PATCHER_TEMP%/DATA/%%d.DAT" "%PATCHDATA%/DATA/%%d.DAT.zstd" -o "%PATCHER_PATCHED_TEMP%/DATA/%%d.DAT"
    "%PATCHER_CWD%patching_utils\zstd.exe" --long=31 --force --decompress --patch-from "%PATCHER_TEMP%/DATA/%%d.HED" "%PATCHDATA%/DATA/%%d.HED.zstd" -o "%PATCHER_PATCHED_TEMP%/DATA/%%d.HED"
)

echo [*] Delete some temporary files to save space

del "%PATCHER_TEMP%\DATA\*.DAT

echo [*] Preparing build

call:create_slack "%PATCHER_PATCHED_TEMP%\SYSTEM.CNF.slack" 1991
call:create_slack "%PATCHER_PATCHED_TEMP%\DI..slack" 1920
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\EZMIDI.IRX.slack" 275
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\SUBDIR.HED.slack" 1972
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES.HED.slack" 1212
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\DMAP.HED.slack" 1068
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\EXTRA.HED.slack" 1704
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\ROOT.HED.slack" 1784
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\SHOOT.HED.slack" 1160
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\SOUND.HED.slack" 1476
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\STATUS.HED.slack" 796
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\SYSTEM.HED.slack" 1728
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\THUMBS.HED.slack" 160
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\2DMAP.HED.slack" 92
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\3DMAP.HED.slack" 1124
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\3DMAP2.HED.slack" 1564
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\LIBSD.IRX.slack" 11
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MCMAN.IRX.slack" 75
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MCSERV.IRX.slack" 807
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODHSYN.IRX.slack" 451
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODMIDI.IRX.slack" 587
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODSEIN.IRX.slack" 847
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODSESQ.IRX.slack" 619
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\PADMAN.IRX.slack" 1307
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\SDRDRV.IRX.slack" 1079
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\SIO2MAN.IRX.slack" 1551
call:create_slack "%PATCHER_PATCHED_TEMP%\MODULES\IRX\IOPRP300.IMG.slack" 1135
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\EZMIDI.IRX.slack" 275
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\LIBSD.IRX.slack" 11
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MCMAN.IRX.slack" 75
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MCSERV.IRX.slack" 807
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODHSYN.IRX.slack" 451
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODMIDI.IRX.slack" 587
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODSEIN.IRX.slack" 847
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODSESQ.IRX.slack" 619
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\PADMAN.IRX.slack" 1307
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\SDRDRV.IRX.slack" 1079
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\SIO2MAN.IRX.slack" 1551
call:create_slack "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\IOPRP300.IMG.slack" 1135


echo [*] Building patched iso

copy /b "%PATCHER_PATCHED_TEMP%\DATA\STATUS.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\STATUS.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\STATUS.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SYSTEM.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SYSTEM.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SYSTEM.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\THUMBS.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\THUMBS.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\THUMBS.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\2DMAP.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\2DMAP.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\2DMAP.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP2.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP2.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\3DMAP2.HED.slack"^
 "%PATCHER_TEMP%\TAIL_LIGHT"

copy /b "%PATCHER_TEMP%\MODULES\IRX\LIBSD.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\LIBSD.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MCMAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MCMAN.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MCSERV.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MCSERV.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MODHSYN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODHSYN.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MODMIDI.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODMIDI.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MODSEIN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODSEIN.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\MODSESQ.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\MODSESQ.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\PADMAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\PADMAN.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\SDRDRV.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\SDRDRV.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\SIO2MAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\SIO2MAN.IRX.slack"^
 + "%PATCHER_TEMP%\MODULES\IRX\IOPRP300.IMG"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\IRX\IOPRP300.IMG.slack"^
 "%PATCHER_TEMP%\TAIL_MODULES"

copy /b "%PATCHER_TEMP%\DATA\MODULES\EZMIDI.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\EZMIDI.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\LIBSD.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\LIBSD.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MCMAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MCMAN.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MCSERV.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MCSERV.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MODHSYN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODHSYN.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MODMIDI.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODMIDI.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MODSEIN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODSEIN.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\MODSESQ.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\MODSESQ.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\PADMAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\PADMAN.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\SDRDRV.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\SDRDRV.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\SIO2MAN.IRX"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\SIO2MAN.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\MODULES\IRX\IOPRP300.IMG"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES\IRX\IOPRP300.IMG.slack"^
 "%PATCHER_TEMP%\TAIL_DATA_MODULES"

copy /b "%PATCHER_PATCHED_TEMP%\ISOHEADER"^
 + "%PATCHDATA%\SYSTEM.CNF"^
 + "%PATCHER_PATCHED_TEMP%\SYSTEM.CNF.slack"^
 + "%PATCHER_TEMP%\DI."^
 + "%PATCHER_PATCHED_TEMP%\DI..slack"^
 + "%PATCHER_PATCHED_TEMP%\SLPS_255.50"^
 + "%PATCHER_TEMP%\MODULES\EZMIDI.IRX"^
 + "%PATCHER_PATCHED_TEMP%\MODULES\EZMIDI.IRX.slack"^
 + "%PATCHER_TEMP%\DATA\SUBDIR.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SUBDIR.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\MODULES.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\DMAP.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\DMAP.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\DMAP.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\EXTRA.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\EXTRA.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\EXTRA.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\ROOT.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\ROOT.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\ROOT.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SHOOT.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SHOOT.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SHOOT.HED.slack"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SOUND.DAT"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SOUND.HED"^
 + "%PATCHER_PATCHED_TEMP%\DATA\SOUND.HED.slack"^
 + "%PATCHER_TEMP%\TAIL_LIGHT"^
 + "%PATCHER_TEMP%\TAIL_MODULES"^
 + "%PATCHER_TEMP%\TAIL_DATA_MODULES"^
 "%PATCHED_ISO%"

echo [*] Cleaning temp directory

rmdir /S /Q "%PATCHER_TEMP%"

echo [*] Build finished.
echo %PATCHED_ISO%

echo [*] Verifying integrity on patched file
"%PATCHER_CWD%patching_utils\7z.exe" h -scrcSHA1 "%PATCHED_ISO%" | find /i "%EXPECTED_PATCHED_ISO_SHA1SUM%"
if errorlevel 1 (
    echo [-] Invalid patched ISO. SHA1SUM must match "%EXPECTED_PATCHED_ISO_SHA1SUM%".
    echo     There was an unexpected issue during patching. Please ensure :
    echo         - You are using windows 10 or superior.
    echo         - You have more than 2 GB RAM available.
    echo         - You have more than 4 GB of available disk space.
    echo         - The provided ISO and the patcher folder are located on the DESKTOP to prevent issues generated by long file paths.
    echo     Then try again.
    pause
    exit 1
)

echo Patched ISO integrity verified.
echo File patched successfully with SONICMAN69's English translation v1.0.0
echo Thank you for using this patcher.
echo Patched file is located here:
echo %PATCHED_ISO%

pause

exit

:create_slack
if exist "%~1" del "%~1"
fsutil file createnew "%~1" "%~2"
goto:eof


