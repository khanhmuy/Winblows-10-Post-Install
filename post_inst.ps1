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

$title = "winblows 10 post-install"
$host.UI.RawUI.WindowTitle = $title
Write-Output "winblows 10 post-install script, made by hmuy"
Write-Output "dependant on and made possible by: W4RH4WK/Debloat-Windows-10"
Write-Output "this script and all the others have no configurations, you have to edit the scripts yourself"
Read-Host "press enter to continue"

function show-menu {
    Write-Host "================$title================"
    Write-Host "1: press 1 to block telemetry"
    Write-Host "2: press 2 to disable services"
    Write-Host "3: press 3 to disable winblows defender (NOT RECOMMENDED)"
    Write-Host "4: press 4 to fix privacy settings"
    Write-Host "5: press 5 to optimize user interface"
    Write-Host "6: press 6 to optimize windows updates"
    Write-Host "7: press 7 to remove default uwp apps"
    Write-Host "8: press 8 to remove onedrive"
    Write-Host "9: press 9 to lower ram usage"
    Write-Host "10: press 10 to enable windows photo viewer"
    Write-Host "11: press 11 to disable shellexperiencehost"
    Write-Host "12: press 12 to enable dark theme"
    Write-Host "13: press 13 to disable memory compression"
    Write-Host "14: press 14 to disable searchUI"
    Write-Host "15: press 15 to disable prefetch prelaunch"
    Write-Host "16: press 16 to disable edge prelaunch"
    Write-Host "17: press 17 to install basic software"
    Write-Host "q to quit"
    Write-Host "========================================================"
}

do {
    show-menu
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
            & $PSScriptRoot\scripts\fix-privacy-settings.ps1
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
        "q" {
            stop-process -id $PID
        }
    }
}
until ($usrinput -eq "q")