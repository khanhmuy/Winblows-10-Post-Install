# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

Clear-Host

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\functions.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
$title = "Install Software - Windows 10 Post Install Scripts`n"
$host.UI.RawUI.WindowTitle = $title

Write-Output "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest https://chocolatey.org/Install.ps1 -UseBasicParsing | Invoke-Expression
choco feature enable -n allowGlobalConfirmation

Clear-Host

$items = 
        "jre8", 
        "Visual Studio Code",
        "Notepad++",
        "Atom",
        "PuTTY",
        "Github Desktop",
        "Git",
        "Python 3",
        "WSL",
        "ITunes",
        "Spotify",
        "Audacity",
        "Steam",
        "ShareX",
        "OBS Studio",
        "Discord",
        "Chrome",
        "Firefox",
        "HyperV",
        "Zoom",
        "Skype",
        "7-Zip",
        "VLC",
        "Winaero Tweaker",
        "Github CLI",
        "Main Menu"

do {
    $Selection = New-Menu -MenuTitle $title -MenuOptions $items -Columns 3 -MaximumColumnWidth 15 -ShowCurrentSelection $True

    Clear-Host
    Switch($Selection){
        "0" {
            choco install jre8
        }
        "1" {
            choco install vscode
        }
        "2" {
            choco install notepadplusplus
        }
        "3" {
            choco install atom
        }
        "4" {
            choco install putty
        }
        "5" {
            choco install github-desktop
        }
        "6" {
            choco install git
        }
        "7" {
            choco install python3
        }
        "8" {
            installWSL
        }
        "9" {
            choco install itunes
        }
        "10" {
            choco install spotify
        }
        "11" {
            choco install audacity
        }
        "12" {
            choco install steam
        }
        "13" {
            choco install sharex
        }
        "14" {
            choco Install obs-studio
        }
        "15" {
            choco install discord
        }
        "16" {
            choco install googlechrome
        }
        "17" {
            choco install firefox
        }
        "18" {
            installHyperV
        }
        "19" {
            choco install zoom
        }
        "20" {
            choco install skype
        }
        "21" {
            choco install 7zip.install
        }
        "22" {
            choco install vlc
        }
        "23" {
            choco Install winaero-tweaker
        }
        "24" {
            choco Install gh
        }
        "25" {
            & $PSScriptRoot\..\post_inst.ps1
        }
    }
} until ($Selection -eq "69420")