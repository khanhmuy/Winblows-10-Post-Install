# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

Clear-Host

Import-Module -DisableNameChecking $PSScriptRoot\lib\functions.psm1
Import-Module -DisableNameChecking $PSScriptRoot\lib\take-own.psm1
$menuReturn = Write-Menu -Title 'Advanced Menu' -Sort -Entries @{
    'Command Entry' = '(Get-AppxPackage).Name'
    'Invoke Entry' = '@(Get-AppxPackage).Name'
    'Hashtable Entry' = @{
        'Array Entry' = "@('Menu Option 1', 'Menu Option 2', 'Menu Option 3', 'Menu Option 4')"
    }
}

Write-Output $menuReturn
