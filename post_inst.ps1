if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

Import-Module -DisableNameChecking $PSScriptRoot\lib\take-own.psm1
Import-Module -DisableNameChecking $PSScriptRoot\lib\functions.psm1

$title = "Windows 10 Post Install Scripts"
$items =
    "Privacy settings",
    "Disable services",
    "Disable Windows Defender (NOT RECOMMENDED)",
    "Optimize user interface",
    "Optimize Windows Update",
    "Remove default apps",
    "Remove OneDrive",
    "Disable searchUI",
    "Disable Cortana",
    "Uninstall IE",
    "Other tweaks",
    "Install basic apps",
    "Quit",
    "Reboot"
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
    Info
    $Selection = Get-MenuSelection -MenuItems $items -MenuPrompt $title
    switch ($Selection) {
        "Privacy settings" {
            & $PSScriptRoot\scripts\privacy-stuff.ps1
        }
        "Disable services" {
            & $PSScriptRoot\scripts\disable-services.ps1
        }
        "Disable Windows Defender (NOT RECOMMENDED)" {
            & $PSScriptRoot\scripts\disable-windows-defender.ps1
        }
        "Optimize user interface" {
            & $PSScriptRoot\scripts\optimize-user-interface.ps1
        }
        "Optimize Windows Update" {
            & $PSScriptRoot\scripts\optimize-windows-update.ps1
        }
        "Remove default apps" {
            & $PSScriptRoot\scripts\remove-default-apps.ps1
        }
        "Remove OneDrive" {
            & $PSScriptRoot\scripts\remove-onedrive.ps1
        }
        "Disable searchUI" {
            & $PSScriptRoot\utils\disable-searchUI.bat
        }
        "Disable Cortana" {
            disable-cortana
        }
        "Uninstall IE" {
            uninstall-ie
        }
        "Other tweaks" {
            Tweaks
        }
        "Install basic apps" {
            & $PSScriptRoot\utils\install-softwares.ps1
        }
        "Quit" {
            Quit
        }
        "Reboot" {
            Restart
        }
    }
} until ($Selection -eq "Quit")