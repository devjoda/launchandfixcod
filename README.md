# launchandfixcod.bat

## About

### Description

A batch script that launches Call of Duty: Modern Warfare (2019) through the Blizzard Battle.net client, changes the default CPU priority from 'high' to 'normal' and self terminates.

### Demo

Brief demo showing the launching process:

![Picture](https://github.com/atyourservicesire/launchandfixcod/blob/master/assets/demo.gif)

Captured using ScreenToGif (https://github.com/NickeManarin/ScreenToGif)

### Why is it necessary to change the CPU priority of the game?

It might not be necessary for you. A lot of PC users (especially people running an Intel i5 CPU) have been experiencing fps drops in the game lobby and general micro stutters in-game. Changing the CPU priority seems to fix these issues for a lot of people. Furthermore, changing the priority will free more resources to background processes, making alt-tabbing faster and smoother. 

The game launches in 'high' priority mode, so the user is left with a choice between continuously changing it manually or installing a dedicated process priority optimizer like Process Lasso and make a rule for the Modern Warfare executable. Installing an application like Process Lasso is associated with minor overhead (resource allocation) and if you don't own a license you are regularly met with a prompt requesting to buy the full version, which can be a minor annoyance to some.

This script aims to offer an automated solution with no overhead and no annoying prompts.

### Does this script access my battle.net login details?

No, it does not. The script simply waits for the appropriate processes to appear (like Blizzard login prompt) by checking generic window titles and image names.

## Getting started

### Download or create a .bat file

Simply download the .bat file from [here](https://google.com/) and extract it to a location of your choosing

OR 

create a .bat file of your own, edit it with notepad or your preferred text editor, paste [the source code](https://google.com/) the source code and save it.

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

## Support

If you liked this script and you feel like it, you can buy me a cup of coffee [here](https://buymeacoff.ee/atyourservicesire) :) 

