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

Import-Module -DisableNameChecking $PSScriptRoot\lib\functions.psm1
Import-Module -DisableNameChecking $PSScriptRoot\lib\take-own.psm1
$title = "winblows 10 post-install"
$host.UI.RawUI.WindowTitle = $title

function Show-Menu {
    Write-Host "================$title================"
    Write-Host "1: privacy stuff"
    Write-Host "2: disable services"
    Write-Host "3: disable windows defender (NOT RECOMMENDED)"
    Write-Host "4: optimize user interface"
    Write-Host "5: optimize windows updates"
    Write-Host "6: remove default uwp apps"
    Write-Host "7: remove onedrive"
    Write-Host "8: disable searchUI"
    Write-Host "9: disable cortana"
    Write-Host "10: uninstall ie"
    Write-Host '"tweaks": tweaks, duh'
    Write-Host '"apps": install basic software'
    Write-Host '"q" to quit'
    Write-Host '"r" to restart (recommended after running)'
    Write-Host "========================================================"
}

do {
    Clear-Host
    Info
    Show-Menu
    $usrinput = Read-Host "select"
    switch ($usrinput) {
        "1" {
            & $PSScriptRoot\scripts\privacy-stuff.ps1
        }
        "2" {
            & $PSScriptRoot\scripts\disable-services.ps1
        }
        "3" {
            & $PSScriptRoot\scripts\disable-windows-defender.ps1
        }
        "4" {
            & $PSScriptRoot\scripts\optimize-user-interface.ps1
        }
        "5" {
            & $PSScriptRoot\scripts\optimize-windows-update.ps1
        }
        "6" {
            & $PSScriptRoot\scripts\remove-default-apps.ps1
        }
        "7" {
            & $PSScriptRoot\scripts\remove-onedrive.ps1
        }
        "8" {
            & $PSScriptRoot\utils\disable-searchUI.bat
        }
        "9" {
            disable-cortana
        }
        "10" {
            uninstall-ie
        }
        "tweaks" {
            Tweaks
        }
        "apps" {
            & $PSScriptRoot\utils\install-softwares.ps1
        }
        "q" {
            Quit
        }
        "r" {
            Restart
        }
    }
}
until ($usrinput -eq "q")