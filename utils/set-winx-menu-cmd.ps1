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

Function SetWinXMenuCmd {
	Write-Output "Setting Command prompt instead of PowerShell in WinX menu..."
	If ([System.Environment]::OSVersion.Version.Build -le 14393) {
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -ErrorAction SilentlyContinue
	} Else {
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Type DWord -Value 1
	}
}