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
$title = "Undo Scripts - Windows 10 Post Install Scripts`n"
$host.UI.RawUI.WindowTitle = $title

$items = 
    "Unblock Telemetry",
    "Back"

do {
    $Selection = New-Menu -MenuTitle $title -MenuOptions $items -Columns 5 -MaximumColumnWidth 200 -ShowCurrentSelection $True

    Clear-Host
    Switch($Selection){
        "0" {
            & $PSScriptRoot\undoblock-telem.ps1
        }
        "1" {
            & $PSScriptRoot\..\post_inst.ps1
        }
    }
} until ($Selection -eq "69420")