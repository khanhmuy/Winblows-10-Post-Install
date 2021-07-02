#function made by hmuy for khanhmuy\windows10-post-install
Import-Module -DisableNameChecking $PSScriptRoot\take-own.psm1
##functions

function disable-cortana {
    Write-Output "Disabling Cortana..."
	If (!(Test-Path "HKCU:\Software\Microsoft\Personalization\Settings")) {
		New-Item -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	If (!(Test-Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore")) {
		New-Item -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" -Name "Value" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization" -Name "AllowInputPersonalization" -Type DWord -Value 0
	Get-AppxPackage "Microsoft.549981C3F5F10" | Remove-AppxPackage
Write-Output "done"
}

function uninstall-ie {
    Write-Output "Uninstalling Internet Explorer..."
    Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -like "Internet-Explorer-Optional*" } | Disable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
    Get-WindowsCapability -Online | Where-Object { $_.Name -like "Browser.InternetExplorer*" } | Remove-WindowsCapability -Online | Out-Null
    Write-Output "done"
}

function set-winx-menu-cmd {
    Write-Output "Setting Command prompt instead of PowerShell in WinX menu..."
    If ([System.Environment]::OSVersion.Version.Build -le 14393) {
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -ErrorAction SilentlyContinue
    } Else {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Type DWord -Value 1
    }
}


Function EnableXboxFeatures {
	Write-Output "Enabling Xbox features..."
	Get-AppxPackage -AllUsers "Microsoft.XboxApp" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Get-AppxPackage -AllUsers "Microsoft.XboxIdentityProvider" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Get-AppxPackage -AllUsers "Microsoft.XboxSpeechToTextOverlay" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Get-AppxPackage -AllUsers "Microsoft.XboxGameOverlay" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Get-AppxPackage -AllUsers "Microsoft.XboxGamingOverlay" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Get-AppxPackage -AllUsers "Microsoft.Xbox.TCUI" | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
	Remove-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
}

function synctime {
	& $PSScriptRoot\..\utils\sync_time.reg
}

Function InstallWSL {
	Write-Output "Installing Linux Subsystem..."
	Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "Microsoft-Windows-Subsystem-Linux" } | Enable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
}

Function InstallHyperV {
	Write-Output "Installing Hyper-V..."
	If ((Get-CimInstance -Class "Win32_OperatingSystem").ProductType -eq 1) {
		Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq "Microsoft-Hyper-V-All" } | Enable-WindowsOptionalFeature -Online -NoRestart -WarningAction SilentlyContinue | Out-Null
	} Else {
		Install-WindowsFeature -Name "Hyper-V" -IncludeManagementTools -WarningAction SilentlyContinue | Out-Null
	}
}

##privacy stuff
Function DisableAppSuggestions {
    Elevate-Privileges
	Write-Output "Disabling Application suggestions..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-314559Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement")) {
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowSuggestedAppsInWindowsInkWorkspace" -Type DWord -Value 0
	# Empty placeholder tile collection in registry cache and restart Start Menu process to reload the cache
	If ([System.Environment]::OSVersion.Version.Build -ge 17134) {
		$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current"
		Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $key.Data[0..15]
		Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue
		Write-Output "done"
	}
}

Function DisableTailoredExperiences {
    Elevate-Privileges
	Write-Output "Disabling Tailored Experiences..."
	If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	Write-Output "done"
}

Function DisableAdvertisingID {
    Elevate-Privileges
	Write-Output "Disabling Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	Write-Output "done"
}

Function DisableDiagTrack {
    Elevate-Privileges
	Write-Output "Stopping and disabling Connected User Experiences and Telemetry Service..."
	Stop-Service "DiagTrack" -WarningAction SilentlyContinue
	Set-Service "DiagTrack" -StartupType Disabled
	Write-Output "done"
}

#sub-scripts
function Tweaks {
	$items =
		"Lower RAM usage",
		"Enable Windows Photo Viewer",
		"Enable dark theme",
		"Disable memory compression",
		"Disable Prefetch prelaunch",
		"Disable Edge prelaunch",
		"Set Win+X menu to CMD",
		"Set Windows to use UTC time",
		"Re-enable Xbox features",
		"Disable ShellExperienceHost",
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
		$Selection = Get-MenuSelection -MenuItems $items -MenuPrompt $title
		switch ($selection) {
			"Lower RAM usage" {
				& $PSScriptRoot\..\utils\lower-ram-usage.reg
			}
			"Enable Windows Photo Viewer" {
				& $PSScriptRoot\..\utils\enable-photo-viewer.reg
			}
			"Enable dark theme" {
				& $PSScriptRoot\..\utils\dark-theme.reg
			}
			"Disable memory compression" {
				& $PSScriptRoot\..\utils\disable-memory-compression.ps1
			}
			"Disable Prefetch prelaunch" {
				& $PSScriptRoot\..\utils\disable-prefetch-prelaunch.ps1
			}
			"Disable Edge prelaunch" {
				& $PSScriptRoot\..\utils\disable-edge-prelaunch.reg
			}
			"Set Win+X menu to CMD" {
				set-winx-menu-cmd
			}
			"Set Windows to use UTC time" {
				synctime
			}
			"Re-enable Xbox features" {
				EnableXboxFeatures
			}
			"Disable ShellExperienceHost" {
				& $PSScriptRoot\..\utils\disable-ShellExperienceHost.ps1
			}
			"Main menu" {
				& $PSScriptRoot\..\post_inst.ps1
			}
		}
	} until ($Selection -eq "Main menu")
}

#misc functions
function Restart {
	Restart-Computer
}

function Quit {
	stop-process -id $PID
}

function Info {
    Write-Output "Windows 10 Post Install Scripts, Made by hmuy, mainly based on W4RH4WK/Debloat-Windows-10"
    Write-Output "Only the remove default apps script has a config (located at config.ps1), you have to edit the rest to your liking beforehand."
	Write-Output "Only Windows 10 is supported, however we are testing this on Windows 11"
	Write-Output "There is no undo, all scripts are provided AS-IS and you use them at your own risk"
}

Function New-Menu (){
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$Columns,
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

<#
    The MIT License (MIT)

    Copyright (c) 2016 QuietusPlus

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

function Write-Menu {
    [CmdletBinding()]

    <#
        Parameters
    #>

    param(
        # Array or hashtable containing the menu entries
        [Parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('InputObject')]
        $Entries,

        # Title shown at the top of the menu.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('Name')]
        [string]
        $Title,

        # Sort entries before they are displayed.
        [Parameter()]
        [switch]
        $Sort,

        # Select multiple menu entries using space, each selected entry will then get invoked (this will disable nested menu's).
        [Parameter()]
        [switch]
        $MultiSelect
    )

    <#
        Configuration
    #>

    # Entry prefix, suffix and padding
    $script:cfgPrefix = ' '
    $script:cfgPadding = 2
    $script:cfgSuffix = ' '
    $script:cfgNested = ' >'

    # Minimum page width
    $script:cfgWidth = 30

    # Hide cursor
    [System.Console]::CursorVisible = $false

    # Save initial colours
    $script:colorForeground = [System.Console]::ForegroundColor
    $script:colorBackground = [System.Console]::BackgroundColor

    <#
        Checks
    #>

    # Check if entries has been passed
    if ($Entries -like $null) {
        Write-Error "Missing -Entries parameter!"
        return
    }

    # Check if host is console
    if ($host.Name -ne 'ConsoleHost') {
        Write-Error "[$($host.Name)] Cannot run inside current host, please use a console window instead!"
        return
    }

    <#
        Set-Color
    #>

    function Set-Color ([switch]$Inverted) {
        switch ($Inverted) {
            $true {
                [System.Console]::ForegroundColor = $colorBackground
                [System.Console]::BackgroundColor = $colorForeground
            }
            Default {
                [System.Console]::ForegroundColor = $colorForeground
                [System.Console]::BackgroundColor = $colorBackground
            }
        }
    }

    <#
        Get-Menu
    #>

    function Get-Menu ($script:inputEntries) {
        # Clear console
        Clear-Host

        # Check if -Title has been provided, if so set window title, otherwise set default.
        if ($Title -notlike $null) {
            $host.UI.RawUI.WindowTitle = $Title
            $script:menuTitle = "$Title"
        } else {
            $script:menuTitle = 'Menu'
        }

        # Set menu height
        $script:pageSize = ($host.UI.RawUI.WindowSize.Height - 5)

        # Convert entries to object
        $script:menuEntries = @()
        switch ($inputEntries.GetType().Name) {
            'String' {
                # Set total entries
                $script:menuEntryTotal = 1
                # Create object
                $script:menuEntries = New-Object PSObject -Property @{
                    Command = ''
                    Name = $inputEntries
                    Selected = $false
                    onConfirm = 'Name'
                }; break
            }
            'Object[]' {
                # Get total entries
                $script:menuEntryTotal = $inputEntries.Length
                # Loop through array
                foreach ($i in 0..$($menuEntryTotal - 1)) {
                    # Create object
                    $script:menuEntries += New-Object PSObject -Property @{
                        Command = ''
                        Name = $($inputEntries)[$i]
                        Selected = $false
                        onConfirm = 'Name'
                    }; $i++
                }; break
            }
            'Hashtable' {
                # Get total entries
                $script:menuEntryTotal = $inputEntries.Count
                # Loop through hashtable
                foreach ($i in 0..($menuEntryTotal - 1)) {
                    # Check if hashtable contains a single entry, copy values directly if true
                    if ($menuEntryTotal -eq 1) {
                        $tempName = $($inputEntries.Keys)
                        $tempCommand = $($inputEntries.Values)
                    } else {
                        $tempName = $($inputEntries.Keys)[$i]
                        $tempCommand = $($inputEntries.Values)[$i]
                    }

                    # Check if command contains nested menu
                    if ($tempCommand.GetType().Name -eq 'Hashtable') {
                        $tempAction = 'Hashtable'
                    } elseif ($tempCommand.Substring(0,1) -eq '@') {
                        $tempAction = 'Invoke'
                    } else {
                        $tempAction = 'Command'
                    }

                    # Create object
                    $script:menuEntries += New-Object PSObject -Property @{
                        Name = $tempName
                        Command = $tempCommand
                        Selected = $false
                        onConfirm = $tempAction
                    }; $i++
                }; break
            }
            Default {
                Write-Error "Type `"$($inputEntries.GetType().Name)`" not supported, please use an array or hashtable."
                exit
            }
        }

        # Sort entries
        if ($Sort -eq $true) {
            $script:menuEntries = $menuEntries | Sort-Object -Property Name
        }

        # Get longest entry
        $script:entryWidth = ($menuEntries.Name | Measure-Object -Maximum -Property Length).Maximum
        # Widen if -MultiSelect is enabled
        if ($MultiSelect) { $script:entryWidth += 4 }
        # Set minimum entry width
        if ($entryWidth -lt $cfgWidth) { $script:entryWidth = $cfgWidth }
        # Set page width
        $script:pageWidth = $cfgPrefix.Length + $cfgPadding + $entryWidth + $cfgPadding + $cfgSuffix.Length

        # Set current + total pages
        $script:pageCurrent = 0
        $script:pageTotal = [math]::Ceiling((($menuEntryTotal - $pageSize) / $pageSize))

        # Insert new line
        [System.Console]::WriteLine("")

        # Save title line location + write title
        $script:lineTitle = [System.Console]::CursorTop
        [System.Console]::WriteLine("  $menuTitle" + "`n")

        # Save first entry line location
        $script:lineTop = [System.Console]::CursorTop
    }

    <#
        Get-Page
    #>

    function Get-Page {
        # Update header if multiple pages
        if ($pageTotal -ne 0) { Update-Header }

        # Clear entries
        for ($i = 0; $i -le $pageSize; $i++) {
            # Overwrite each entry with whitespace
            [System.Console]::WriteLine("".PadRight($pageWidth) + ' ')
        }

        # Move cursor to first entry
        [System.Console]::CursorTop = $lineTop

        # Get index of first entry
        $script:pageEntryFirst = ($pageSize * $pageCurrent)

        # Get amount of entries for last page + fully populated page
        if ($pageCurrent -eq $pageTotal) {
            $script:pageEntryTotal = ($menuEntryTotal - ($pageSize * $pageTotal))
        } else {
            $script:pageEntryTotal = $pageSize
        }

        # Set position within console
        $script:lineSelected = 0

        # Write all page entries
        for ($i = 0; $i -le ($pageEntryTotal - 1); $i++) {
            Write-Entry $i
        }
    }

    <#
        Write-Entry
    #>

    function Write-Entry ([int16]$Index, [switch]$Update) {
        # Check if entry should be highlighted
        switch ($Update) {
            $true { $lineHighlight = $false; break }
            Default { $lineHighlight = ($Index -eq $lineSelected) }
        }

        # Page entry name
        $pageEntry = $menuEntries[($pageEntryFirst + $Index)].Name

        # Prefix checkbox if -MultiSelect is enabled
        if ($MultiSelect) {
            switch ($menuEntries[($pageEntryFirst + $Index)].Selected) {
                $true { $pageEntry = "[X] $pageEntry"; break }
                Default { $pageEntry = "[ ] $pageEntry" }
            }
        }

        # Full width highlight + Nested menu indicator
        switch ($menuEntries[($pageEntryFirst + $Index)].onConfirm -in 'Hashtable', 'Invoke') {
            $true { $pageEntry = "$pageEntry".PadRight($entryWidth) + "$cfgNested"; break }
            Default { $pageEntry = "$pageEntry".PadRight($entryWidth + $cfgNested.Length) }
        }

        # Write new line and add whitespace without inverted colours
        [System.Console]::Write("`r" + $cfgPrefix)
        # Invert colours if selected
        if ($lineHighlight) { Set-Color -Inverted }
        # Write page entry
        [System.Console]::Write("".PadLeft($cfgPadding) + $pageEntry + "".PadRight($cfgPadding))
        # Restore colours if selected
        if ($lineHighlight) { Set-Color }
        # Entry suffix
        [System.Console]::Write($cfgSuffix + "`n")
    }

    <#
        Update-Entry
    #>

    function Update-Entry ([int16]$Index) {
        # Reset current entry
        [System.Console]::CursorTop = ($lineTop + $lineSelected)
        Write-Entry $lineSelected -Update

        # Write updated entry
        $script:lineSelected = $Index
        [System.Console]::CursorTop = ($lineTop + $Index)
        Write-Entry $lineSelected

        # Move cursor to first entry on page
        [System.Console]::CursorTop = $lineTop
    }

    <#
        Update-Header
    #>

    function Update-Header {
        # Set corrected page numbers
        $pCurrent = ($pageCurrent + 1)
        $pTotal = ($pageTotal + 1)

        # Calculate offset
        $pOffset = ($pTotal.ToString()).Length

        # Build string, use offset and padding to right align current page number
        $script:pageNumber = "{0,-$pOffset}{1,0}" -f "$("$pCurrent".PadLeft($pOffset))","/$pTotal"

        # Move cursor to title
        [System.Console]::CursorTop = $lineTitle
        # Move cursor to the right
        [System.Console]::CursorLeft = ($pageWidth - ($pOffset * 2) - 1)
        # Write page indicator
        [System.Console]::WriteLine("$pageNumber")
    }

    <#
        Initialisation
    #>

    # Get menu
    Get-Menu $Entries

    # Get page
    Get-Page

    # Declare hashtable for nested entries
    $menuNested = [ordered]@{}

    <#
        User Input
    #>

    # Loop through user input until valid key has been pressed
    do { $inputLoop = $true

        # Move cursor to first entry and beginning of line
        [System.Console]::CursorTop = $lineTop
        [System.Console]::Write("`r")

        # Get pressed key
        $menuInput = [System.Console]::ReadKey($false)

        # Define selected entry
        $entrySelected = $menuEntries[($pageEntryFirst + $lineSelected)]

        # Check if key has function attached to it
        switch ($menuInput.Key) {
            # Exit / Return
            { $_ -in 'Escape', 'Backspace' } {
                # Return to parent if current menu is nested
                if ($menuNested.Count -ne 0) {
                    $pageCurrent = 0
                    $Title = $($menuNested.GetEnumerator())[$menuNested.Count - 1].Name
                    Get-Menu $($menuNested.GetEnumerator())[$menuNested.Count - 1].Value
                    Get-Page
                    $menuNested.RemoveAt($menuNested.Count - 1) | Out-Null
                # Otherwise exit and return $null
                } else {
                    Clear-Host
                    $inputLoop = $false
                    [System.Console]::CursorVisible = $true
                    return $null
                }; break
            }

            # Next entry
            'DownArrow' {
                if ($lineSelected -lt ($pageEntryTotal - 1)) { # Check if entry isn't last on page
                    Update-Entry ($lineSelected + 1)
                } elseif ($pageCurrent -ne $pageTotal) { # Switch if not on last page
                    $pageCurrent++
                    Get-Page
                }; break
            }

            # Previous entry
            'UpArrow' {
                if ($lineSelected -gt 0) { # Check if entry isn't first on page
                    Update-Entry ($lineSelected - 1)
                } elseif ($pageCurrent -ne 0) { # Switch if not on first page
                    $pageCurrent--
                    Get-Page
                    Update-Entry ($pageEntryTotal - 1)
                }; break
            }

            # Select top entry
            'Home' {
                if ($lineSelected -ne 0) { # Check if top entry isn't already selected
                    Update-Entry 0
                } elseif ($pageCurrent -ne 0) { # Switch if not on first page
                    $pageCurrent--
                    Get-Page
                    Update-Entry ($pageEntryTotal - 1)
                }; break
            }

            # Select bottom entry
            'End' {
                if ($lineSelected -ne ($pageEntryTotal - 1)) { # Check if bottom entry isn't already selected
                    Update-Entry ($pageEntryTotal - 1)
                } elseif ($pageCurrent -ne $pageTotal) { # Switch if not on last page
                    $pageCurrent++
                    Get-Page
                }; break
            }

            # Next page
            { $_ -in 'RightArrow','PageDown' } {
                if ($pageCurrent -lt $pageTotal) { # Check if already on last page
                    $pageCurrent++
                    Get-Page
                }; break
            }

            # Previous page
            { $_ -in 'LeftArrow','PageUp' } { # Check if already on first page
                if ($pageCurrent -gt 0) {
                    $pageCurrent--
                    Get-Page
                }; break
            }

            # Select/check entry if -MultiSelect is enabled
            'Spacebar' {
                if ($MultiSelect) {
                    switch ($entrySelected.Selected) {
                        $true { $entrySelected.Selected = $false }
                        $false { $entrySelected.Selected = $true }
                    }
                    Update-Entry ($lineSelected)
                }; break
            }

            # Select all if -MultiSelect has been enabled
            'Insert' {
                if ($MultiSelect) {
                    $menuEntries | ForEach-Object {
                        $_.Selected = $true
                    }
                    Get-Page
                }; break
            }

            # Select none if -MultiSelect has been enabled
            'Delete' {
                if ($MultiSelect) {
                    $menuEntries | ForEach-Object {
                        $_.Selected = $false
                    }
                    Get-Page
                }; break
            }

            # Confirm selection
            'Enter' {
                # Check if -MultiSelect has been enabled
                if ($MultiSelect) {
                    Clear-Host
                    # Process checked/selected entries
                    $menuEntries | ForEach-Object {
                        # Entry contains command, invoke it
                        if (($_.Selected) -and ($_.Command -notlike $null) -and ($entrySelected.Command.GetType().Name -ne 'Hashtable')) {
                            Invoke-Expression -Command $_.Command
                        # Return name, entry does not contain command
                        } elseif ($_.Selected) {
                            return $_.Name
                        }
                    }
                    # Exit and re-enable cursor
                    $inputLoop = $false
                    [System.Console]::CursorVisible = $true
                    break
                }

                # Use onConfirm to process entry
                switch ($entrySelected.onConfirm) {
                    # Return hashtable as nested menu
                    'Hashtable' {
                        $menuNested.$Title = $inputEntries
                        $Title = $entrySelected.Name
                        Get-Menu $entrySelected.Command
                        Get-Page
                        break
                    }

                    # Invoke attached command and return as nested menu
                    'Invoke' {
                        $menuNested.$Title = $inputEntries
                        $Title = $entrySelected.Name
                        Get-Menu $(Invoke-Expression -Command $entrySelected.Command.Substring(1))
                        Get-Page
                        break
                    }

                    # Invoke attached command and exit
                    'Command' {
                        Clear-Host
                        Invoke-Expression -Command $entrySelected.Command
                        $inputLoop = $false
                        [System.Console]::CursorVisible = $true
                        break
                    }

                    # Return name and exit
                    'Name' {
                        Clear-Host
                        return $entrySelected.Name
                        $inputLoop = $false
                        [System.Console]::CursorVisible = $true
                    }
                }
            }
        }
    } while ($inputLoop)
}


