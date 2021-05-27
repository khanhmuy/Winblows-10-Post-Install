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

Write-Output "Uninstalling Internet Explorer..."
Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -like "Internet-Explorer-Optional*" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
Get-WindowsCapability -Online | Where-Object { $_.Name -like "Browser.InternetExplorer*" } | Remove-WindowsCapability -Online | Out-Null
Write-Output "done"
$return = Read-Host "return to main menu? (y/n)"
if ($return -eq "y") {
    & $PSScriptRoot\..\post_inst.ps1
}
else {
    stop-process -id $PID
}