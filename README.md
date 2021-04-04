# launchandfixcod.bat

04-05-2021

Decided to archive this project, as it appears the game client no longer forces high CPU priority. The recent update to the b.net client broke the scripts way of checking for succesful login (window title checking), but I uploaded [a new and final version](https://github.com/nooberfrombaldursgate/launchandfixcod/blob/master/modernwarfare2019-new.bat), that cuts out the loging prompt check and just keeps attempting to launch the game until it detects the modernwarfare.exe process in case anyone still find any use for this script.


## About

### Description

A batch script that launches Call of Duty: Modern Warfare (2019) through the Blizzard Battle.net client, changes the default CPU priority from 'high' to 'normal' and self terminates.

### Demonstration

Brief demo showing the launching process:

![Picture](https://github.com/atyourservicesire/launchandfixcod/blob/master/assets/demo.gif)

Captured using the awesome [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)

### Why is it necessary to change the CPU priority of the game?

It might not be necessary for you. A lot of PC users (especially people running an Intel i5 CPU) have been experiencing fps drops in the game lobby and general micro stutters in-game. Changing the CPU priority seems to fix these issues for a lot of people. Furthermore, changing the priority will free more resources to background processes, making alt-tabbing faster and smoother. 

The game launches in 'high' priority mode, so the user is left with a choice between continuously changing it manually or installing a dedicated process priority optimizer like Process Lasso and make a rule for the Modern Warfare executable. Installing an application like Process Lasso is associated with minor overhead (resource allocation) and if you don't own a license you are regularly met with a prompt requesting to buy the full version, which can be a minor annoyance to some.

This script aims to offer an automated solution with no overhead and no annoying prompts.

### Does this script access my battle.net login details?

No, it does not. The script simply waits for the appropriate processes to appear (like Blizzard login prompt) by checking generic window titles and image names.

## Getting started

### Download or create a .bat file

Simply download the [latest release](https://github.com/atyourservicesire/launchandfixcod/files/4048762/launchandfixcod-v0.1.0.zip) and extract the .bat file to a location of your choosing

OR 

create a .bat file of your own, edit it with notepad or your preferred text editor, paste [the source code](https://github.com/atyourservicesire/launchandfixcod/blob/master/launchandfixcod.bat) and save it.

### Editing the .bat file

If your Blizzard Battle.net client is located at a different path than the default installation path (C:/Program Files (x86)/Battle.net) you need to edit line 3 in the .bat file. As an example you would need to change the following line:

```
set battlenet_path=C:/Program Files (x86)/Battle.net
```

to

```
set battlenet_path=E:/My Applications/Battle.net
```

Note: It does not matter where your Call of Duty: Modern Warfare game files are located, since the script launches the game through the Battle.net Launcher executable.

### Language support

English (US) is the **only supported language**.

It's recommended to set your language to English (US) in the Battle.net client under the general tab, unless you add support to your local language.

If the Battle.net language is set to German, the Battle.net login process name will appear as "In Battle.net einloggen" in Windows. The script however is looking for a process named "Battle.net Login.

Adding support to your local language is easy: 
1) Right click the .bat and select edit in NotePad
2) Press CTRL+H to bring forth the replace window
3) Input the following in the 'Find what' form: Blizzard Battle.net Login
4) Input the translated process name (can easily be located in task manager) in the 'Replace with' form: In Battle.net einloggen
5) Replace line 22, 32, 84

Line 22:
```
call :check_if_process_exist "In Battle.net einloggen" "Battle.net login prompt" 1 0
```

Line 32:
```
call :loop_until_process_exist "In Battle.net einloggen" "Battle.net login prompt" 1
```

Line 84:
```
call :loop_until_process_not_exist "In Battle.net einloggen" "Battle.net login prompt" 1
```

6) Save 
