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
$title = "Privacy settings"
$host.UI.RawUI.WindowTitle = $title
Write-Host "$title"

$items =
    "Disable telemetry",
    "Fix privacy settings",
    "Disable app suggestions",
    "Disable Tailored Experiences",
    "Disable Advertising ID",
    "Disable Diagtrack",
    "Run all",
    "Main menu"
$host.UI.RawUI.WindowTitle = $title
function Get-MenuSelection {
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$MenuItems,
        [Parameter(Mandatory = $true)]
        [String]$MenuPrompt
    )
    # store initial cursor position
    $cursorPosition = $host.UI.RawUI.CursorPosition
    $pos = 0 # current item selection
     #==============
# 1. Draw menu
#==============
function Write-Menu
{
    param (
        [int]$selectedItemIndex
    )
    # reset the cursor position
    $Host.UI.RawUI.CursorPosition = $cursorPosition
    # Padding the menu prompt to center it
    $prompt = $MenuPrompt
    $maxLineLength = ($MenuItems | Measure-Object -Property Length -Maximum).Maximum + 4
    while ($prompt.Length -lt $maxLineLength+4)
    {
        $prompt = " $prompt "
    }
    Write-Host $prompt -ForegroundColor Green
    # Write the menu lines
    for ($i = 0; $i -lt $MenuItems.Count; $i++)
    {
        $line = "    $($MenuItems[$i])" + (" " * ($maxLineLength - $MenuItems[$i].Length))
        if ($selectedItemIndex -eq $i)
        {
            Write-Host $line -ForegroundColor Blue -BackgroundColor Gray
        }
        else
        {
            Write-Host $line
        }
    }
}

Write-Menu -selectedItemIndex $pos
$key = $null
while ($key -ne 13)
{
    #============================
    # 2. Read the keyboard input
    #============================
    $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
    $key = $press.virtualkeycode
    if ($key -eq 38)
    {
        $pos--
    }
    if ($key -eq 40)
    {
        $pos++
    }
    #handle out of bound selection cases
    if ($pos -lt 0) { $pos = 0 }
    if ($pos -eq $MenuItems.count) { $pos = $MenuItems.count - 1 }
    
    #==============
    # 1. Draw menu
    #==============
    Write-Menu -selectedItemIndex $pos
}

return $MenuItems[$pos]
}

do {
    Clear-Host
    $selection = Get-MenuSelection -MenuItems $items -MenuPrompt $title
    switch ($selection) {
        "Disable telemetry" {
            & $PSScriptRoot\block-telemetry.ps1
        }
        "Fix privacy settings" {
            & $PSScriptRoot\fix-privacy-settings.ps1
        }
        "Disable app suggestions" {
            DisableAppSuggestions
        }
        "Disable Tailored Experiences" {
            DisableTailoredExperiences
        }
        "Disable Advertising ID" {
            DisableAdvertisingID
        }
        "Disable Diagtrack" {
            DisableDiagTrack
        }
        "Run all" {
            & $PSScriptRoot\block-telemetry.ps1
            & $PSScriptRoot\fix-privacy-settings.ps1
            DisableAppSuggestions
            DisableTailoredExperiences
            DisableAdvertisingID
            DisableDiagTrack
        }
        "Main menu" {
            & $PSScriptRoot\..\post_inst.ps1
        }
    }
} until ($Selection -eq "Main menu")
