@echo off
SETLOCAL EnableDelayedExpansion
set battlenet_path=C:/Program Files (x86)/Battle.net
set changeCPUPriority=1
set waitMessageEnabled=1

call :handle_bnet_client 1
call :launch_modern_warfare 1
if %changeCPUPriority% equ 1 (
call :change_cpu_priority_to_high modernwarfare.exe "Call of Duty: Modern Warfare" 1
) else (
	call :exit_app
)
:: Arg1 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:handle_bnet_client
set bnetClientDetected=0
set bnetLoginPromptDetected=0
call :check_if_process_exist "Battle.net.exe" "Battle.net client" 0 %1
if %errorlevel% equ 1 (
	set bnetClientDetected=1
)
call :check_if_process_exist "Blizzard Battle.net Login" "Battle.net login prompt" 1 0
if %errorlevel% equ 1 (
	set bnetLoginPromptDetected=1
)
if %bnetClientDetected% equ 1 ( 
	if %bnetLoginPromptDetected% equ 1 (
		call :handle_bnet_login_prompt 1
	)
) else (
	call :launch_battlenet_client 1
	call :loop_until_process_exist "Blizzard Battle.net Login" "Battle.net login prompt" 1
	call :handle_bnet_login_prompt 1
)
goto:eof

:: Arg1 = Process search ID (string)
:: Arg2 = Command output friendly name of process (string)
:: Arg3 = Filter settings (input 0 to filter by image name, input 1 to filter by window title)
:: Arg4 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:check_if_process_exist
set arg1=%1
set trimmedArg1=%arg1:~1,-1%
set arg2=%2
set trimmedArg2=%arg2:~1,-1%
if %4 equ 1 (
call :println "Checking for %trimmedArg2%..."
)
if %3 equ 0 (
	tasklist /fi "imagename eq %trimmedArg1%" |find ":" > nul
)
if %3 equ 1 (
	tasklist /fi "windowtitle eq %trimmedArg1%" |find ":" > nul
)
if %errorlevel% equ 0 ( 
	if %4 equ 1 (
	call :println "  [%trimmedArg2% was not detected]"
	)
	goto:eof
)
if %errorlevel% equ 1 ( 
	if %4 equ 1 (
	call :println "  [%trimmedArg2% detected]"
	)
	goto:eof
)
call:throw_new_exception Error: An unhandled exception occured while determining the state of %trimmedOutput%."

:: Arg1 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:handle_bnet_login_prompt
if %1 equ 1 (
	echo Waiting for user to log on to Battle.net client...
)
call :loop_until_successful_bnet_login
call :check_if_process_exist "Blizzard Battle.net" "Battle.net login prompt" 1 0
if %errorlevel% equ 1 (
	if %1 equ 1 (
		call :println "  [User has successfully logged on to Battle.net client]"
		)
)
goto:eof

:loop_until_successful_bnet_login
call :loop_until_process_not_exist "Blizzard Battle.net Login" "Battle.net login prompt" 1
tasklist /fi "windowtitle eq Blizzard Battle.net" |find ":" > nul
if %errorlevel% neq 1 (
	goto:loop_until_successful_bnet_login
)
goto:eof

:: Arg1 = Process search ID (string)
:: Arg2 = Command output friendly name of process (string)
:: Arg3 = Filter settings (input 0 to filter by image name, input 1 to filter by window title)
:loop_until_process_exist
call :check_if_process_exist %1 %2 %3 0
if %errorlevel% equ 1 (
goto:eof
) else (
ping 127.0.0.1 -n 1 -w 500 > nul
goto:loop_until_process_exist
)

:: Arg1 = Process search ID (string)
:: Arg2 = Command output friendly name of process (string)
:: Arg3 = Filter settings (input 0 to filter by image name, input 1 to filter by window title)
:loop_until_process_not_exist
call :check_if_process_exist %1 %2 %3 0
if %errorlevel% equ 1 (
ping 127.0.0.1 -n 1 -w 500 > nul
goto:loop_until_process_not_exist
) else (
goto:eof
)

:: Arg1 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:launch_modern_warfare
set name=Call of Duty: Modern Warfare
if %1 equ 1 (
	echo Attempting to launch %name%...
)
start "" "%battlenet_path%/Battle.net" --exec="launch ODIN"
call :loop_until_process_exist "ModernWarfare.exe" "%name%" 0
if %1 equ 1 (
	call :println "  [%name% has successfully been launched]"
)
goto:eof

:: Arg1 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:launch_battlenet_client
set name=Battle.net client
if %1 equ 1 (
	echo Attempting to launch %name%...
)
start "" "%battlenet_path%/Battle.net Launcher.exe"
call :loop_until_process_exist "Battle.net Launcher.exe" "%name%" 0
if %1 equ 1 (
	call :println "  [%name% has successfully been launched]"
)
goto:eof

:: Arg1 = Process image name (string)
:: Arg2 = Command output friendly name of process (string)
:: Arg3 = Command output settings (input 0 to disable command output, input 1 to command enable output)
:change_cpu_priority_to_high
set arg2=%2
set trimmedArg2=%arg2:~1,-1%
call :check_if_process_exist "%1" %2 0 0
	if %errorlevel% equ 0 (
		call:throw_new_exception "Could not change CPU priority to 'normal': %trimmedArg2% has stopped running."
)
if %3 equ 1 (
	if %waitMessageEnabled% equ 1 (
		echo Waiting for %trimmedArg2% to set CPU priority to 'high'...
		set waitMessageEnabled=0
	)
)
set "wmic_cmd=wmic process where name^="%1" get /format:list ^| findstr Priority"
for /f "tokens=1* delims==" %%a in ('%wmic_cmd%') do set priority=%%b
ping 127.0.0.1 -n 1 -w 500 > nul
if %priority% equ 13 (
	wmic process where name="%1" CALL setpriority "32"
	cls
	if %errorlevel% equ 0 (
		call :println "CPU priority of %trimmedArg2% has successfully been changed from 'high' to 'normal'."
		ping 127.0.0.1 -n 3 > nul
		cls
	)
	if %errorlevel% equ 2 (
		call:throw_new_exception "Could not change CPU priority to 'normal': Access denied."
	) 
	if %errorlevel% equ 3 (
		call:throw_new_exception "Could not change CPU priority to 'normal': Insufficient privilege."
	) 
	if %errorlevel% equ 8 (
		call:throw_new_exception "Could not change CPU priority to 'normal': Unknown failure."
	) 
	if %errorlevel% equ 9 (
		call:throw_new_exception "Could not change CPU priority to 'normal': Path not found."
	) 
	if %errorlevel% equ 21 (
		call:throw_new_exception "Could not change CPU priority to 'normal': Invalid parameter."
	) 
	call :exit_app
) else (
ping 127.0.0.1 -n 1 -w 500 > nul
goto:change_cpu_priority_to_high
)

:throw_new_exception
call:println %1
ping 127.0.0.1 -n 3 > nul
call :exit_app
exit

:println
set message=%1
set trimmedMessage=%message:~1,-1%
echo %trimmedMessage%
goto:eof

:exit_app
echo Exiting...
ping 127.0.0.1 -n 3 > nul
exit
