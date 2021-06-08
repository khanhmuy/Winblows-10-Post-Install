param([switch]$Elevated)
function testAdmin {
	$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  }

if ((testAdmin) -eq $false)  {
    if ($elevated) {
        gimme elevation mf.
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Clear-Host

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\functions.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
$title = "install software - winblows 10 post install"
$host.UI.RawUI.WindowTitle = $title
Write-Output "install software"
Read-Host "press enter to continue"

function show-pkgs {
    Write-Host "================$title================"
    Write-Host "==========dev tools=========="
    Write-Host "1: install jre8"
    Write-Host "2: install visual studio code"
    Write-Host "3: install notepad++"
    Write-Host "4: install atom"
    Write-Host "5: install putty"
    Write-Host "6: install github desktop"
    Write-Host "7: install git"
    Write-Host "8: install python"
    Write-Host "9: install wsl"
    Write-Host "==========music stuff=========="
    Write-Host "10: install itunes"
    Write-Host "11: install spotify"
    Write-Host "12: install audacity"
    Write-Host "==========gaming/streaming=========="
    Write-Host "13: install steam"
    Write-Host "14: install sharex"
    Write-Host "15: install obs studio"
    Write-Host "16: install discord"
    Write-Host "==========browsers=========="
    Write-Host "17: install chrome"
    Write-Host "18: install firefox"
    Write-Host "==========virtualization=========="
    Write-Host "19: install hyper-v"
    Write-Host "==========other stuff=========="
    Write-Host "20: install zoom"
    Write-Host "21: install skype"
    Write-Host "22: install 7zip"
    Write-Host "23: install vlc"
    Write-Host "24: install winaero tweaker"
    Write-Host '"upgrade"" to upgrade chocolately'
    Write-Host '"q" to quit'
    Write-Host '"return" to return to main menu'
    Write-Host "================$title================"
}

Write-Output "installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
choco feature enable -n allowGlobalConfirmation

do {
    Clear-Host
    show-pkgs
    $usrinput = Read-Host "select"
    switch ($usrinput) {
        "1" {
            choco install jre8
        }
        "2" {
            choco install vscode
        }
        "3" {
            choco install notepadplusplus
        }
        "4" {
            choco install atom
        }
        "5" {
            choco install putty
        }
        "6" {
            choco install github-desktop
        }
        "7" {
            choco install git
        }
        "8" {
            choco install python3
        }
        "9" {
            InstallWSL
        }
        "10" {
            choco install itunes
        }
        "11" {
            choco install spotify
        }
        "12" {
            choco install audacity
        }
        "13" {
            choco install steam
        }
        "14" {
            choco install sharex
        }
        "15" {
            choco install obs-studio
        }
        "16" {
            choco install discord
        }
        "17" {
            choco install googlechrome
        }
        "18" {
            choco install firefox
        }
        "19" {
            InstallHyperV
        }
        "20" {
            choco install zoom
        }
        "21" {
            choco install skype
        }
        "22" {
            choco install 7zip.install
        }
        "23" {
            choco install vlc
        }
        "24" {
            choco install winaero-tweaker
        }
        "return" {
            & $PSScriptRoot\..\post_inst.ps1
        }
        "upgrade" {
            choco upgrade chocolatey
        }
        "q" {
            Quit
        }
    }
}
until ($usrinput -eq "q")