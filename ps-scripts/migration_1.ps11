#  +++++++++++++++++++++++++++ $$$$$$   /$$$$$$  /$$$$$$$ ++++++++++++++++++++++++++
#  ++++++++++++++++++++++++++/$$__  $$ /$$__  $$| $$__  $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  \ $$| $$  \ $$| $$  \ $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$$$$$$$| $$$$$$$$| $$$$$$$ ++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$__  $$| $$__  $$| $$__  $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  | $$| $$  | $$| $$  \ $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  | $$| $$  | $$| $$$$$$$/++++++++++++++++++++++++++
#  +++++++++++++++++++++++++|__/  |__/|__/  |__/|_______/+++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  ++++++++                                                                 ++++++++   
#  +++++++            Export / Import Script für WX-VM Generation            +++++++
#  ++++++                         by Christian Rathnau                        ++++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                        Stand 11/2020                                  +++++
#  +++++                        Version 1.0                                    +++++
#  +++++                                                                       +++++
#  +++++    Das Script                                                         +++++
#  +++++              Export Userdaten von Programmen                          +++++
#  +++++                                                                       +++++
#  +++++              Outlook Connector                                        +++++
#  +++++              Mdaemon Messanger (nur Backup, Restore-> migration_2.ps1 +++++
#  +++++              Google Chrome                                            +++++
#  +++++              Internet Explorer                                        +++++
#  +++++              Edge                                                     +++++
#  +++++              Firefox                                                  +++++
#  +++++              Wallpaper Backup                                         +++++
#  +++++              Zippt den Backup     Ordner                              +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++              Import Userdaten auf neuer Maschine                      +++++
#  +++++                                                                       +++++
#  ++++++                                                                     ++++++
#  +++++++                                                                   +++++++
#  ++++++++                                                                 ++++++++   
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++    Changelog:                                                         +++++
#  +++++                                                                       +++++
#  +++++     Version 1.1                                                       +++++
#  +++++                                                                       +++++
#  +++++       - added Windows Explorer View Modifications                     +++++
#  +++++       - Dropped Outlook Profile Copy Support                          +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    #  +++++ MStore
    # Computer\HKEY_CURRENT_USER\SOFTWARE\Policies\deepinvent


#  +++++ params 

#  +++++ Funktionen

Function New-PinnedItem # https://stackoverflow.com/questions/59778951/pin-program-with-parameters-to-taskbar-using-ps-in-windows-10
 { 
    [CmdletBinding()]
    param (
        [ValidateScript( { $_.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -eq -1 })]
        [Parameter(ParameterSetName = 'Path')]
        [Parameter(Mandatory, ParameterSetName = 'Command')]
        [String]$Name,
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [ValidateNotNullOrEmpty()]
        [String]$Path,
        [Parameter(Mandatory, ParameterSetName = 'Command')]
        [scriptblock]$Command,
        [ValidateSet('Normal', 'Minimized', 'Maximized')]
        [String]$WindowStyle = 'Normal',
        [String]$Arguments,
        [String]$Description,
        [String]$Hotkey,
        [String]$IconLocation,
        [Switch]$RunAsAdmin,
        [String]$WorkingDirectory,
        [String]$RelativePath
    )
    $NoExtension = [System.IO.Path]::GetExtension($path) -eq ""
    $pinHandler = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.taskbarpin" -Name "ExplorerCommandHandler"
    New-Item -Path "HKCU:Software\Classes\*\shell\pin" -Force | Out-Null
    Set-ItemProperty -LiteralPath "HKCU:Software\Classes\*\shell\pin" -Name "ExplorerCommandHandler" -Type String -Value $pinHandler

    if ($PSCmdlet.ParameterSetName -eq 'Command') {
        #$Path = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $Path = "powershell.exe"
        $Arguments = ('-NoProfile -Command "&{{{0}}}"' -f ($Command.ToString().Trim("`r`n") -replace "`r`n", ';'))
        if (!$PsBoundParameters.ContainsKey('WindowStyle')) {
            $WindowStyle = 'Minimized'
        }
    }

    if (!(Test-Path -Path $Path)) {
        if ($NoExtension) {
            $Path = "$Path.exe"

        }
        $Found = $False
        $ShortName = [System.IO.Path]::GetFileNameWithoutExtension($path)
        # testing against installed programs (Registry)
        $loc = Get-ChildItem HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
        $names = ($loc | foreach-object { Get-ItemProperty $_.PsPath }).Where( { ![String]::IsNullOrWhiteSpace($_.InstallLocation) })
        $InstallLocations1, $InstallLocations2 = $names.Where( { $_.DisplayName -Like "*$ShortName*" }, 'split') 
        $InstallLocations1 = $InstallLocations1 | Select-Object -ExpandProperty InstallLocation
        $InstallLocations2 = $InstallLocations2 | Select-Object -ExpandProperty InstallLocation
        Foreach ($InsLoc in $InstallLocations1) {
            if (Test-Path -Path "$Insloc\$path") {
                $Path = "$Insloc\$path"
                $Found = $true
                break
            }
        }
        if (! $found) {
            $Result = $env:Path.split(';').where( { Test-Path -Path "$_\$Path" }, 'first') 
            if ($Result.count -eq 1) { $Found = $true }
        }

        # Processing remaining install location (less probable outcome)
        if (! $found) {
            Foreach ($InsLoc in $InstallLocations2) {
                if (Test-Path -Path "$Insloc\$path") {
                    $Path = "$Insloc\$path"
                    $Found = $true
                    exit for
                }
            }
        }

        if (!$found) {
            Write-Error -Message "The path $Path does not exist"
            return 
        }

    }


    if ($PSBoundParameters.ContainsKey('Name') -eq $false) {
        $Name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    }

    $TempFolderName = "tmp$((48..57 + 97..122| get-random -Count 4 |ForEach-Object {[char][byte]$_}) -join '')"
    $TempFolderPath = "$env:temp\$TempFolderName"
    $ShortcutPath = "$TempFolderPath\$Name.lnk"
    [Void](New-Item -ItemType Directory -Path $TempfolderPath)


    if ($Path.EndsWith(".lnk")) {
        Copy-Item -Path $Path -Destination $ShortcutPath
        $obj = New-Object -ComObject WScript.Shell 
        $link = $obj.CreateShortcut($ShortcutPath) 
    }
    else {
        $obj = New-Object -ComObject WScript.Shell 
        $link = $obj.CreateShortcut($ShortcutPath) 
        $link.TargetPath = $Path
    }

    switch ($WindowStyle) {
        'Minimized' { $WindowstyleID = 7 }
        'Maximized' { $WindowstyleID = 3 }
        'Normal' { $WindowstyleID = 1 }
    }

    $link.Arguments = $Arguments
    $Link.Description = $Description
    if ($PSBoundParameters.ContainsKey('IconLocation')) { $link.IconLocation = $IconLocation }
    $link.Hotkey = "$Hotkey"
    $link.WindowStyle = $WindowstyleID
    if ($PSBoundParameters.ContainsKey('WorkingDirectory')) { $link.WorkingDirectory = $WorkingDirectory }
    if ($PSBoundParameters.ContainsKey('RelativePath')) { $link.RelativePath = $RelativePath }
    $link.Save()

    if ($RunAsAdmin) {
        $bytes = [System.IO.File]::ReadAllBytes($ShortcutPath)
        $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
        [System.IO.File]::WriteAllBytes($ShortcutPath, $bytes)
    }

    $Shell = New-Object -ComObject "Shell.Application"
    $Folder = $Shell.Namespace((Get-Item $ShortcutPath).DirectoryName)
    $Item = $Folder.ParseName((Get-Item $ShortcutPath).Name)
    $Item.InvokeVerb("pin")

    Remove-Item -LiteralPath  "HKCU:Software\Classes\*\shell\pin\" -Recurse   
    Remove-item -path $ShortcutPath
    Remove-Item -Path $TempFolderPath 
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shell)
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$obj)
}

Function Set-WallPaper($Value)
 {
    Set-ItemProperty -path "HKCU:\Control Panel\Desktop\" -name wallpaper -value $value
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
 }

#  +++++ Globale Variablen

# [string[]] $supd = "C:\support"
[string[]] $extd = "C:\support\1_backup\export"
[string[]] $impd = "C:\Support\1_import\"
[string[]] $appd = "C:\Users\${env:UserName}\AppData\Roaming"

#  +++++ Code

Write-Host "#######################################################################################"
Write-Host "#####                                                                             #####"
Write-Host "#####             Fully automated Migration Script WX to WXL Generation           #####"
Write-Host "#####                            CC Christian Rathnau                             #####"
Write-Host "#####                                                                             #####"
Write-Host "#####                                 Version 1.0                                 #####"
Write-Host "#####                                                                             #####"
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
Write-Host "# Do you want to export or import user data?                                          #"
Write-Host "#                                                                                     #"
Write-Host "# Type 1 for Export                                                                   #"
Write-Host "# Type 2 for Import                                                                   #"
Write-Host "#                                                                                     #"
Write-Host "#                                                                                     #"
Write-Host "#                                                                                     #"
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
$migrate = Read-Host "# Select Option"
Write-Host "#                                                                                     #"


#  +++++ Export / Backup (auf alter Maschine)

if ($migrate -eq "1"){
    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"
    Write-Host "# Migration it is!                                                                    #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "# Starting in 5 seconds                                                               #"
    Start-Sleep 5

    #  +++++ Backup folder creation
    Write-Host "#                                                                                     #"
    Write-Host "# Creating Backuo folder                                                              #"
    Write-Host "#                                                                                     #"
    Set-Location "C:\Support"
    New-Item -Path "c:\support" -Name "1_Backup" -ItemType Directory | Out-Null
    Write-Host ""
    New-Item -Path "C:\support\1_Backup\" -Name "export" -ItemType Directory | Out-Null
    Write-Host ""
    Write-Host "# backup Directory is created                                                         #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"

    #  +++++ Outlook Connector
    Write-Host "# MD Connector Backup                                                                 #"
    Copy-Item -Path "${appd}\Alt-N\" -Destination "$extd\MD_Connector\Alt-N\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Mdaemon Messanger
    Write-Host "# MD Messanger Backup                                                                 #"
    Copy-Item -Path "C:\Program Files (x86)\MDaemon Technologies\ComAgent" -Destination "$extd\MD_Messanger\" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "${appd}\Microsoft\Windows\Start Menu\Programs\Startup\MDaemon Instant Messenger.lnk" -Destination "$extd\" -Recurse -Force
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Google Chrome
    Write-Host "# Google Chrome Profile Backup                                                        #"
    Copy-Item -Path "$env:LOCALAPPDATA\google\chrome\user data\default" -Destination "$extd\Chrome\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Internet Explorer
    Write-Host "# Internet Explorer Bookmarks Backup                                                  #"
    Set-Location $env:USERPROFILE
    Set-Location .\Favorites
    Copy-Item -Path ./ -Destination "$extd\IE_Favs\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  ++++++ Firefox
    Write-Host "# Firefox Profile Backup                                                              #"
    Copy-Item -Path "${appd}\Mozilla\Firefox\" -Destination "$extd\Mozilla\Firefox\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Wallpaper
    Set-Location HKCU:
    $wallp = (Get-ItemProperty -Path ".\Control Panel\Desktop\" -Name "wallpaper").wallpaper

        # Check if Value [wallpaper] is empty, if not copy file from value wallpaper location to $extd
        if ($wallp -eq ""){
            Write-Host "# No Wallpaper found! Skipping Step!                                                  #"
            Write-Host "#                                                                                     #"
        }
        else {
            Write-Host "# Wallaper Backup                                                                     #"
            Set-Location C:\
            Copy-Item -Path "$wallp" -Destination "$extd\wallpaper.jpg" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "#                                                                                     #"
            Write-Host "# Done!                                                                               #"  -ForegroundColor Green
            Write-Host "#                                                                                     #"
            }
            Write-Host "#                                                                                     #"

    Write-Host "# Compressing Backup Archive                                                          #"
    #  +++++ Zipping
    $compress = @{  
        Path = "$extd\*"
        CompressionLevel = "Fastest"
        DestinationPath = "C:\Support\1_backup\Backup.zip"
    }
    Compress-Archive @compress
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "# Backup fnished! Backup Archive Location:                                            #"  
    Write-Host "#                                          C:\Support\Backup.zip                      #"
    Write-Host "#                                                                                     #"
    Write-Host "# Please copy the Archive to the destination Host and run this Script again!          #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
    Set-Location "C:\Support"
}

# ++++++ Import (auf neuer Maschine)

if ($migrate -eq "2"){
    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"
    Write-Host "# Migration it is!                                                                    #"
    Write-Host "#                                                                                     #"
    Write-Host "# Starting in 5 seconds                                                               #"
    Start-Sleep 5

    New-PinnedItem -Path "C:\Windows\explorer.exe"
    New-PinnedItem -Path "C:\Program Files (x86)\Microsoft Office\Office16\WINWORD.EXE"
    New-PinnedItem -Path "C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE"
    New-PinnedItem -Path "C:\Program Files (x86)\Microsoft Office\Office16\POWERPNT.EXE"
    New-PinnedItem -Path "C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE"

    #  +++++ Backup folder creation
    Write-Host "#                                                                                     #"
    Write-Host "# Creating Import folder                                                              #"
    Write-Host "#                                                                                     #"
    Set-Location "C:\Support"
    New-Item -Path "c:\support" -Name "1_import" -ItemType Directory
    Write-Host ""
    Write-Host "# Import Directory is created                                                         #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "# Expanding Archive.... This could take a little while.                               #" -ForegroundColor Yellow

    #  +++++ Expanding Archive

    $archd = "C:\Support\1_import"
    Expand-Archive -LiteralPath "c:\support\Backup.zip" -DestinationPath $archd -Force
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"

    #  +++++ Outlook Connector
    Write-Host "# MD Connector Import                                                                 #"
    Copy-Item -Path "$impd\MD_Connector\ALT-N" -Recurse -Force -Destination "${appd}\" -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Google Chrome
    Write-Host "# Google Chrome Profile Import                                                        #"
    # New-Item -Path "$env:LOCALAPPDATA\google\chrome\user data\" -Name "default" -ItemType Directory
    Copy-Item -Path "$impd\Chrome\" -Destination  "$env:LOCALAPPDATA\google\chrome\user data\default" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ internet Explorer
    Write-Host "# Internet Explorer Bookmarks Import                                                  #"
    Copy-Item -Path "$impd\IE_Favs\*" -Destination "$env:USERPROFILE\Favorites\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  ++++++ Firefox
    Write-Host "# Firefox Profile Backup                                                              #"
    # Remove-Item "${appd}\Mozilla\Firefox" -Force -recurse | Out-Null
    Copy-Item -Path "$impd\Mozilla\Firefox\" -Destination  "${appd}\Mozilla\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  +++++ Wallpaper
    Write-Host "# Wallpaper Import (Save Location c:\users\xx\Pictures\wallaper.jpg)                  #"
    # $wallp = (Test-Path $impd\wallpaper.jpg)
    Copy-Item $impd\wallpaper.jpg -Destination "$env:USERPROFILE\Pictures\wallpaper.jpg"  -ErrorAction SilentlyContinue
    Set-WallPaper "$env:USERPROFILE\Pictures\wallpaper.jpg" 
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  ++++++ MD Messenger

    Write-Host "# MD Messenger Post configurution                                                      #"
    New-Item -Path "$appd\Microsoft\Windows\Start Menu\Programs\"  -Name "Startup" -ItemType Directory
    Copy-Item -Path "$impd\MDaemon Instant Messenger.lnk" -Destination "$appd\Microsoft\Windows\Start Menu\Programs\Startup" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"

    #  ++++++ Windows Explorer View Properties  https://stackoverflow.com/questions/4491999/configure-windows-explorer-folder-options-through-powershell

    Write-Host "#                                                                                     #"
    Write-Host "# Setting Explorer View Settings                                                      #"
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $key Hidden 1
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key ShowSuperHidden 1
    Stop-Process -processname explorer  
    Write-Host "#                                                                                     #"
    Write-Host "# Done!                                                                               #"  -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "# Elevating to admin for helper Script migration_2.ps1                                #"

    Start-Sleep 1
    & $PSScriptRoot\migration_2.ps1
}
