# windows-10-post-install

This project consists of PowerShell scripts for debloating and tweaking Windows 10 after installation, based on [W4RH4WK/Debloat-Windows-10](https://github.com/W4RH4WK/Debloat-Windows-10)

I have tested these scripts on a Windows 10 Professional 64-Bit (English) virtual
machine and multiple real Windows 10 Professional (English) installations. Please let me or [W4RH4WK](https://github.com/W4RH4WK) know if you encounter any issues. Home Edition and different languages are not supported. These scripts are intended for tech-savvy administrators, who know what they are doing and just want to
automate this phase of their setup. If this profile does not fit you, I
recommend using a different (more interactive) tool -- and there are a lot of
them out there. This is by no means a complete set of tweaks for Windows, just some stuff I like to do to my Windows installation to make the thing less fucking annoying, less obtrusive and less resource-hogging. 

Also, note that gaming-related apps and services will be removed/disabled. If
you intend to use your system for gaming, adjust the scripts accordingly.

**There is no undo**, I recommend only using these scripts on a fresh
installation (including Windows Updates). Test everything after running them
before doing anything else. Also, there is no guarantee that everything will
work after future updates since I cannot predict what Microsoft will do next.

Also, I would love to just have all the tweaks inside a single script module but i can't for various reasons

automated options eta s0n

## Interactivity

The scripts are designed to run without any user interaction. Modify them
beforehand. 

## Download Latest Version

- [Download [zip]](https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip) for W4RH4WK/Debloat-Windows-10

## Execution
Before launching the script(s), run these commands:

Enable execution of PowerShell scripts:

    PS> Set-ExecutionPolicy Unrestricted -Scope CurrentUser

Unblock PowerShell scripts and modules within this directory:

    PS> ls -Recurse *.ps*1 | Unblock-File

## Usage

Scripts can be run individually through the main script, pick what you need.

1. Install all available updates for your system.
2. Edit the scripts to fit your need.
3. Right-click `post_inst.ps1` and select `Run with PowerShell`
4. Select `restart computer` in the main menu

## Start menu

In the past I included small fixes to make the start menu more usable, like
removing default tiles, disabling web search and so on. This is no longer the
case since I am fed up with it. This fucking menu breaks for apparently
no reason, is slow, is a pain to configure / script and even shows ads out of
the box!

Please replace it with something better, either use [Open Shell] or [Start
is Back], but stop using that shit.

[Open Shell]: <https://open-shell.github.io/Open-Shell-Menu/>
[Start is Back]: <http://startisback.com/>

## Known Issues

All the same issues as [W4RH4WK/Debloat-Windows-10](https://github.com/W4RH4WK/Debloat-Windows-10)

## Liability

**All scripts are provided as-is and you use them at your own risk.**

### Thanks To

- [W4RH4WK](https://github.com/W4RH4WK)
- all the people who contributed to W4RH4WK\Debloat-Windows-10

## License

    "THE BEER-WARE LICENSE" (Revision 42):

    As long as you retain this notice you can do whatever you want with this
    stuff. If we meet someday, and you think this stuff is worth it, you can
    buy us a beer in return.

    This project is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.
