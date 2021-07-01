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
$title = "Install Software - Windows 10 Post Install Scripts`n"
$host.UI.RawUI.WindowTitle = $title

Write-Output "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest https://chocolatey.org/Install.ps1 -UseBasicParsing | Invoke-Expression
choco feature enable -n allowGlobalConfirmation

Clear-Host

Function New-Menu (){
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$Columns = "Auto",
        [Parameter(Mandatory=$False)][int]$MaximumColumnWidth=20,
        [Parameter(Mandatory=$False)][bool]$ShowCurrentSelection=$False
    )

    $MaxValue = $MenuOptions.count-1
    $Selection = 0
    $EnterPressed = $False

    If ($Columns -eq "Auto"){
        $WindowWidth = (Get-Host).UI.RawUI.MaxWindowSize.Width
        $Columns = [Math]::Floor($WindowWidth/($MaximumColumnWidth+2))
    }

    If ([int]$Columns -gt $MenuOptions.count){
        $Columns = $MenuOptions.count
    }

    $RowQty = ([Math]::Ceiling(($MaxValue+1)/$Columns))
        
    $MenuListing = @()

    For($i=0; $i -lt $Columns; $i++){
            
        $ScratchArray = @()

        For($j=($RowQty*$i); $j -lt ($RowQty*($i+1)); $j++){

            $ScratchArray += $MenuOptions[$j]
        }

        $ColWidth = ($ScratchArray |Measure-Object -Maximum -Property length).Maximum

        If ($ColWidth -gt $MaximumColumnWidth){
            $ColWidth = $MaximumColumnWidth-1
        }

        For($j=0; $j -lt $ScratchArray.count; $j++){
            
            If(($ScratchArray[$j]).length -gt $($MaximumColumnWidth -2)){
                $ScratchArray[$j] = $($ScratchArray[$j]).Substring(0,$($MaximumColumnWidth-4))
                $ScratchArray[$j] = "$($ScratchArray[$j])..."
            } Else {
            
                For ($k=$ScratchArray[$j].length; $k -lt $ColWidth; $k++){
                    $ScratchArray[$j] = "$($ScratchArray[$j]) "
                }

            }
            
            $ScratchArray[$j] = " $($ScratchArray[$j]) "
        }
        $MenuListing += $ScratchArray
    }
    
    Clear-Host

    While($EnterPressed -eq $False){
        
        Write-Host "$MenuTitle"

        For ($i=0; $i -lt $RowQty; $i++){

            For($j=0; $j -le (($Columns-1)*$RowQty);$j+=$RowQty){

                If($j -eq (($Columns-1)*$RowQty)){
                    If(($i+$j) -eq $Selection){
                        Write-Host -BackgroundColor cyan -ForegroundColor Black "$($MenuListing[$i+$j])"
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])"
                    }
                } Else {

                    If(($i+$j) -eq $Selection){
                        Write-Host -BackgroundColor Cyan -ForegroundColor Black "$($MenuListing[$i+$j])" -NoNewline
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])" -NoNewline
                    }
                }
                
            }

        }

        #Uncomment the below line if you need to do live debugging of the current index selection. It will put it in green below the selection listing.
        #Write-Host -ForegroundColor Green "$Selection"

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($KeyInput){
            13{
                $EnterPressed = $True
                Return $Selection
                Clear-Host
                break
            }

            37{ #Left
                If ($Selection -ge $RowQty){
                    $Selection -= $RowQty
                } Else {
                    $Selection += ($Columns-1)*$RowQty
                }
                Clear-Host
                break
            }

            38{ #Up
                If ((($Selection+$RowQty)%$RowQty) -eq 0){
                    $Selection += $RowQty - 1
                } Else {
                    $Selection -= 1
                }
                Clear-Host
                break
            }

            39{ #Right
                If ([Math]::Ceiling($Selection/$RowQty) -eq $Columns -or ($Selection/$RowQty)+1 -eq $Columns){
                    $Selection -= ($Columns-1)*$RowQty
                } Else {
                    $Selection += $RowQty
                }
                Clear-Host
                break
            }

            40{ #Down
                If ((($Selection+1)%$RowQty) -eq 0 -or $Selection -eq $MaxValue){
                    $Selection = ([Math]::Floor(($Selection)/$RowQty))*$RowQty
                    
                } Else {
                    $Selection += 1
                }
                Clear-Host
                break
            }
            Default{
                Clear-Host
            }
        }
    }
}

$items = 
        "jre8", 
        "Visual Studio Code",
        "Notepad++",
        "Atom",
        "PuTTY",
        "Github Desktop",
        "Git",
        "Python 3",
        "WSL",
        "ITunes",
        "Spotify",
        "Audacity",
        "Steam",
        "ShareX",
        "OBS Studio",
        "Discord",
        "Chrome",
        "Firefox",
        "HyperV",
        "Zoom",
        "Skype",
        "7-Zip",
        "VLC",
        "Winaero Tweaker",
        "Github CLI",
        "Main Menu"

do {
    $Selection = New-Menu -MenuTitle $title -MenuOptions $items -Columns 3 -MaximumColumnWidth 15 -ShowCurrentSelection $True

    Clear-Host
    Switch($Selection){
        "0" {
            choco install jre8
        }
        "1" {
            choco install vscode
        }
        "2" {
            choco install notepadplusplus
        }
        "3" {
            choco install atom
        }
        "4" {
            choco install putty
        }
        "5" {
            choco install github-desktop
        }
        "6" {
            choco install git
        }
        "7" {
            choco install python3
        }
        "8" {
            installWSL
        }
        "9" {
            choco install itunes
        }
        "10" {
            choco install spotify
        }
        "11" {
            choco install audacity
        }
        "12" {
            choco install steam
        }
        "13" {
            choco install sharex
        }
        "14" {
            choco Install obs-studio
        }
        "15" {
            choco install discord
        }
        "16" {
            choco install googlechrome
        }
        "17" {
            choco install firefox
        }
        "18" {
            installHyperV
        }
        "19" {
            choco install zoom
        }
        "20" {
            choco install skype
        }
        "21" {
            choco install 7zip.install
        }
        "22" {
            choco install vlc
        }
        "23" {
            choco Install winaero-tweaker
        }
        "24" {
            choco Install gh
        }
        "25" {
            & $PSScriptRoot\..\post_inst.ps1
        }
    }
} until ($Selection -eq "69420")