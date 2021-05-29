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
function ShowInfo {
    Write-Output "winblows 10 post-install script, made by hmuy"
    Write-Output "an all-in-one script for W4RH4WK/Debloat-Windows-10, plus some extra features"
    Write-Output "this script and all the others have no configurations, you have to edit the scripts yourself :thishowitis:"
}


function Show-Menu {
    Write-Host "================$title================"
    Write-Host "1: block telemetry"
    Write-Host "2: disable services"
    Write-Host "3: disable winblows defender (NOT RECOMMENDED)"
    Write-Host "4: privacy stuff"
    Write-Host "5: optimize user interface"
    Write-Host "6: optimize windows updates"
    Write-Host "7: remove default uwp apps"
    Write-Host "8: remove onedrive"
    Write-Host "9: lower ram usage"
    Write-Host "10: enable windows photo viewer"
    Write-Host "11: disable shellexperiencehost (may break start menu and action center)"
    Write-Host "12: enable dark theme"
    Write-Host "13: disable memory compression"
    Write-Host "14: disable searchUI"
    Write-Host "15: disable prefetch prelaunch"
    Write-Host "16: disable edge prelaunch"
    Write-Host "17: disable cortana"
    Write-Host "18: to set win+x menu to command prompt"
    Write-Host "19: uninstall ie"
    Write-Host "20: sync time with other os"
    Write-Host "21: enable xbox stuff"
    Write-Host "22: install wsl"
    Write-Host "23: install hyper-v"
    Write-Host '"apps": install basic software'
    Write-Host '"q" to quit'
    Write-Host '"r" to restart (recommended after running)'
    Write-Host "========================================================"
}

do {
    Clear-Host
    ShowInfo
    Show-Menu
    $usrinput = Read-Host "select"
    switch ($usrinput) {
        "1" {
            & $PSScriptRoot\scripts\block-telemetry.ps1
        }
        "2" {
            & $PSScriptRoot\scripts\disable-services.ps1
        }
        "3" {
            & $PSScriptRoot\scripts\disable-windows-defender.ps1
        }
        "4" {
            & $PSScriptRoot\scripts\privacy-stuff.ps1
        }
        "5" {
            & $PSScriptRoot\scripts\optimize-user-interface.ps1
        }
        "6" {
            & $PSScriptRoot\scripts\optimize-windows-update.ps1
        }
        "7" {
            & $PSScriptRoot\scripts\remove-default-apps.ps1
        }
        "8" {
            & $PSScriptRoot\scripts\remove-onedrive.ps1
        }
        "9" {
            & $PSScriptRoot\utils\lower-ram-usage.reg
        }
        "10" {
            & $PSScriptRoot\utils\enable-photo-viewer.reg
        }
        "11" {
            & $PSScriptRoot\utils\disable-ShellExperienceHost.bat
        }
        "12" {
            & $PSScriptRoot\utils\dark-theme.reg
        }
        "13" {
            & $PSScriptRoot\utils\disable-memory-compression.ps1
        }
        "14" {
            & $PSScriptRoot\utils\disable-searchUI.bat
        }
        "15" {
            & $PSScriptRoot\utils\disable-prefetch-prelaunch.ps1
        }
        "16" {
            & $PSScriptRoot\utils\disable-edge-prelaunch.reg
        }
        "17" {
            disable-cortana
        }
        "18" {
            set-winx-menu-cmd
        }
        "19" {
            uninstall-ie
        }
        "20" {
            synctime
        }
        "21" {
            EnableXboxFeatures
        }
        "22" {
            InstallWSL
        }
        "23" {
            InstallHyperV
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