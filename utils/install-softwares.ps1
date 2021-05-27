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

$title = "install software - winblows 10 post install"
$host.UI.RawUI.WindowTitle = $title
Write-Output "install software"
Read-Host "press enter to continue"

function show-pkgs {
    Write-Host "================$title================"
    Write-Host "1: install jre8"
    Write-Host "2: install visual studio code"
    Write-Host "3: install notepad++"
    Write-Host "4: install atom"
    Write-Host "5: install putty"
    Write-Host "6: install github desktop"
    Write-Host "7: install itunes"
    Write-Host "8: install spotify"
    Write-Host "9: install audacity"
    Write-Host "10: install steam"
    Write-Host "11: install sharex"
    Write-Host "12: install obs studio"
    Write-Host "13: install skype"
    Write-Host "14: install 7zip"
    Write-Host "15: install python"
    Write-Host "16: install vlc"
    Write-Host "17: install zoom"
    Write-Host "18: install discord"
    Write-Host "19: install chrome"
    Write-Host "20: install firefox"
    Write-Host "21: install winaero tweaker"
    Write-Host "q to quit"
    Write-Host "return to return to main menu"
    Write-Host "================$title================"
}

Write-Output "installing chocolately"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

do {
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
            choco install itunes
        }
        "8" {
            choco install spotify
        }
        "9" {
            choco install audacity
        }
        "10" {
            choco install steam-client
        }
        "11" {
            choco install sharex
        }
        "12" {
            choco install obs-studio
        }
        "13" {
            choco install skype
        }
        "14" {
            choco install 7zip.install
        }
        "15" {
            choco install python3
        }
        "16" {
            choco install vlc
        }
        "17" {
            choco install zoom
        }
        "18" {
            choco install discord
        }
        "19" {
            choco install googlechrome 
        }
        "20" {
            choco install firefox
        }
        "21" {
            choco install winaero-tweaker
        }
        "return" {
            & $PSScriptRoot\..\post_inst.ps1
        }
    }
}
until ($usrinput -eq "q")