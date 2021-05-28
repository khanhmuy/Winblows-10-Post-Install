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
$title = "privacy stuff"
$host.UI.RawUI.WindowTitle = $title
Write-Host "$title"
Read-Host "press enter to continue"

function privacymenu {
    Write-Host "================$title================"
    Write-Host "this is just like, some privacy settings"
    Write-Host "1: run scripts\fix-privacy-settings.ps1"
    Write-Host "2: disable app suggestions"
    Write-Host "3: disable tailored experiences"
    Write-Host "4: disable advertising id"
    Write-Host "5: disable diagtrack"
    Write-Host '"all" to do all'
    Write-Host '"q" to quit'
    Write-Host '"return" to return to main menu'
    Write-Host "================$title================"
}

do {
    privacymenu
    $usrinput = Read-Host "select"
    switch ($usrinput) {
        "1" {
            & fix-privacy-settings.ps1
        }
        "2" {
            DisableAppSuggestions
        }
        "3" {
            DisableTailoredExperiences
        }
        "4" {
            DisableAdvertisingID
        }
        "5" {
            DisableDiagTrack
        }
        "all" {
            & $PSScriptRoot\fix-privacy-settings.ps1
            DisableAppSuggestions
            DisableTailoredExperiences
            DisableAdvertisingID
            DisableDiagTrack
        }
        "return" {
            & $PSScriptRoot\..\post_inst.ps1
        }
        "q" {
            Quit
        }
    }
}
until ($usrinput -eq "q")