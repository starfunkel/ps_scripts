#  +++++++++++++++++++++++__++++++__+.____++_____++__.________+++++++++++++++++++++++++
#  ++++++++++++++++++++++/++\++++/++\|++++||+++++|/+_|\_____++\++++++++++++++++++++++++
#  ++++++++++++++++++++++\+++\/\/+++/|++++||+++++++<+++/+++|+++\+++++++++++++++++++++++
#  +++++++++++++++++++++++\++++++++/+|++++||+++++|++\+/++++|++++\++++++++++++++++++++++
#  ++++++++++++++++++++++++\__/\++/++|____||_____|__+\\_______++/++++++++++++++++++++++
#  +++++++++++++++++++++++++++++\/++++++++++++++++++\/++++++++\/+++++++++++++++++++++++
#  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  ++++                                                                            ++++
#  ++++     Personalisierungsscript mit Logging Funktion by Christian Rathnau      ++++
#  ++++                                                                            ++++
#  ++++                           Fellow Jahrgang 20/21                            ++++
#  ++++																			   ++++
#  ++++     Prinzip des Scriptes ist es alles was unter c:\support\mui_settings in ++++
#  ++++     den Ordnern \en und \de zu finden ist, sowie alle jew. lokalisierten   ++++
#  ++++     Reg-Schlüssel und Werte an ihre jew. Orte im System zu verteilen. 	   ++++
#  ++++     																	   ++++
#  ++++     Zweitens installiert dieses Script das Englische (en-us) Sprachpaket   ++++
#  ++++     für Windows und aktiviert es sofern die Option [en] ausgewählt worden  ++++
#  ++++     ist.																   ++++
#  ++++        																	   ++++
#  ++++     Drittens erledigt das Script die Personalisierung der Benutzkonten der ++++
#  ++++     Fellows. Hierzu gehört:                                                ++++
#  ++++                                                                            ++++
#  ++++     - Das Setzen des Wiko Hintergrundbildes                                ++++
#  ++++     - Die Erstellung von Programm & URL Shortcuts auf dem Desktop und in   ++++
#  ++++       der Taskleiste                                                       ++++
#  ++++                                                                            ++++
#  ++++    Viertens Aktiviert das Script selbststängig Windows 10 Enterprise 2019  ++++
#  ++++    LTSC und Office 2016 Std 64 Bit mit einem im Script liegenden MAK Key   ++++
#  ++++                                                                            ++++
#  ++++    Das Script verfügt über eine weitreichende Logging Funktion die es      ++++
#  ++++    ermöglicht Fehler abzufangen und in einem Log zur Verfügung zu          ++++
#  ++++    stellen.                                                                ++++
#  ++++                                                                            ++++
#  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

############# TO DO #############

# Do While Schleife bauen um die einzelenen Teile des Scripts auszuführen und andere aus zulassen
# else statements einbauen um Fehlereingaben zu überwinden
# Logging Funktionen erweitern
# try catch finally anstatt der if elseif Statments einführen (im Block "ins Dateisystem schreiben")

param([switch]$Elevated)

function Test-Admin # https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
 {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} 

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

'running with full privileges'

##### Variablen #####

[string] $langselect = $en; $de

[string[]] $supd = "C:\support"
[string[]] $muid = "C:\support\mui_settings"
[string[]] $appd = "C:\Users\${env:UserName}\AppData\Roaming"
[string[]] $icos = "C:\support\icons"

$userprofile = $env:UserName
$Time = (Get-Date -f dd:MM:yyyy:hh:mm:ss)

set-location "${supd}"
set-location "${appd}"

function Write-Log # https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0
{
    #Log Funktion Besipiele
#.EXAMPLE
#   Write-Log -Message 'Log message' 
#   Writes the message to c:\Logs\PowerShellLog.log.
#.EXAMPLE
#   Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log
#   Writes the content to the specified log file and creates the path and file specified. 
#.EXAMPLE
#   Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error
        
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path='C:\support\logs\Pers_log.txt', # Pfad angepasst
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warnung","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process
    {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        else {
            # Nothing to see here yet.
            }


        # Make Path outside available

      #  $owrite = New-Object -TypeName psobject
      #  Add-Member -InputObject $owrite -MemberType NoteProperty -Name owrite -Value $Path $obj,

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
                }
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
                }
            'Info' {
                Write-Verbose $Message # Verbose Nachrichten an oder aus machen
                $LevelText = 'INFO:'
                }
            }
        
        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End
    {
    }
}

Function Set-WallPaper($Value)
 {
    Set-ItemProperty -path "HKCU:\Control Panel\Desktop\" -name wallpaper -value $value
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
 }

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
        $InstallLocations1 = $InstallLocations1 | Select -ExpandProperty InstallLocation
        $InstallLocations2 = $InstallLocations2 | Select -ExpandProperty InstallLocation
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

    $TempFolderName = "tmp$((48..57 + 97..122| get-random -Count 4 |% {[char][byte]$_}) -join '')"
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

write-host ""
write-host "#####################################################################"
write-host "#                                                                   #"
write-host "# Wiko Fellow Language Select Script für Lokalisationseinstellunegn #"
write-host "#                                                                   #"
write-host "#####################################################################"
write-host ""
write-host ""
write-host ""
write-host "Ablauf des Scripts:"
write-host ""
write-host "1. Wallpaper und Desktop/Taskbar Shortcuts setzen"
write-host "2. Sprachliche Individualiserung starten"
write-host "3. Windows und Office Aktivierung"
write-Host ""
$execute = Read-Host "Soll Teil 1 (Wallpaper und Desktop/Taskbar Shortcuts setzen) des Scripts jetzt gestartet werden? [Ja] oder [Nein]"



if ($execute -eq "JA" ){
    
    write-host "Das Script führt nun Schritt 1. aus!"
    write-host ""
    write-host ""
    Start-Sleep -Seconds 4 
    write-host ""

        # Background Wallpaper setzen
        Set-Location 'HKCU:\Control Panel\Desktop'
        write-Host "Hintergrundbild wird gesetzt"
        Set-WallPaper -value "C:\support\wiko-desktop-large.jpg"
        Set-Location c:\
        write-host ""

        # Shortcuts auf dem Desktop und in der Taskbar setzen setzen
        write-host "Shortcuts werden auf den Desktop und in die Taskbar gesetzt"
        write-host ""

        # Word
        write-Host "Word Shortcut wird gesetzt"
        $TargetFile =  "C:\Program Files\Microsoft Office\Office16\WINWORD.EXE"
        $ShortcutFile = "$env:USERPROFILE\Desktop\Word 2016.lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        #$Shortcut.Arguments="C:\Program Files\Microsoft Office\Office16\WINWORD.exe"
        $Shortcut.TargetPath = $TargetFile
        $Shortcut.Save()

        New-PinnedItem -Path "C:\Program Files\Microsoft Office\Office16\WINWORD.EXE"
        write-host ""

        # Excel

        write-Host "Excel Shortcut wird gesetzt"
        $TargetFile =  "C:\Program Files\Microsoft Office\Office16\EXCEL.EXE"
        $ShortcutFile = "$env:USERPROFILE\Desktop\Excel 2016.lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        #$Shortcut.Arguments="shell:AppsFolder\Microsoft.SDKSamples.AdventureWorks.CS_8wekyb3d8bbwe!App"
        $Shortcut.TargetPath = $TargetFile
        $Shortcut.Save()

        New-PinnedItem -Path "C:\Program Files\Microsoft Office\Office16\EXCEL.EXE"
        write-host ""

        # Powerpoint

        write-Host "Powerpoint Shortcut wird gesetzt"
        $TargetFile =  "C:\Program Files\Microsoft Office\Office16\POWERPNT.EXE"
        $ShortcutFile = "$env:USERPROFILE\Desktop\PowerPoint 2016.lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        #$Shortcut.Arguments="shell:AppsFolder\Microsoft.SDKSamples.AdventureWorks.CS_8wekyb3d8bbwe!App"
        $Shortcut.TargetPath = $TargetFile
        $Shortcut.Save()

        New-PinnedItem -Path "C:\Program Files\Microsoft Office\Office16\POWERPNT.EXE"
        write-host ""

        # Library, Calender, Wiko Mail Shortcuts setzen und Icons anheften 
        # https://stackoverflow.com/questions/41707358/how-can-i-change-icons-for-existing-url-shortcuts-using-powershell

        # Library

        write-Host "Wiko Library Shortcut wird gesetzt"
        $WshShell = New-Object -comObject WScript.Shell
        $path = "$env:USERPROFILE\Desktop\Wiko Library.url"
        $targetpath = "https://library.wiko-berlin.de/index.php?id=2/"
        $iconlocation = "${icos}\Library request forms.ico"
        $iconfile = "IconFile=" + $iconlocation
        $Shortcut = $WshShell.CreateShortcut($path)
        $Shortcut.TargetPath = $targetpath
        $Shortcut.Save()
        Add-Content $path "HotKey=0"
        Add-Content $path "$iconfile"
        Add-Content $path "IconIndex=0"
        write-host ""

        # Calender

        write-Host "Wiko Kalender Shortcut wird gesetzt"
        $WshShell = New-Object -comObject WScript.Shell
        $path = "$env:USERPROFILE\Desktop\Calender.url"
        $targetpath = "https://www.wiko-berlin.de/en/wiko-welcome/calendar/"
        $iconlocation = "${icos}\Calendar of Events.ico"
        $iconfile = "IconFile=" + $iconlocation
        $Shortcut = $WshShell.CreateShortcut($path)
        $Shortcut.TargetPath = $targetpath
        $Shortcut.Save()
        Add-Content $path "HotKey=0"
        Add-Content $path "$iconfile"
        Add-Content $path "IconIndex=0"
        write-host ""

        # Wiko Mail

        write-Host "Wiko Mail Shortcut wird gesetzt"
        $WshShell = New-Object -comObject WScript.Shell
        $path = "$env:USERPROFILE\Desktop\Wiko Mail.url"
        $targetpath = "https://maild.wiko-berlin.de/"
        $iconlocation = "${icos}\WIKO Mail.ico"
        $iconfile = "IconFile=" + $iconlocation
        $Shortcut = $WshShell.CreateShortcut($path)
        $Shortcut.TargetPath = $targetpath
        $Shortcut.Save()
        Add-Content $path "HotKey=0"
        Add-Content $path "$iconfile"
        Add-Content $path "IconIndex=0"
        write-host ""

    }


write-host ""
write-host ""
write-host "                              Schritt 2"
write-host ""
write-host  "               Welche Sprache soll installiert werden?"
write-host ""
write-host  "                  [en] Englisch, oder [de] Deutsch"
write-host ""
$langselect = Read-Host "                 Bitte eine Sprache waehlen en / de"


##### Beginn der Sprach Abfrage und der Lokalisierung #####

if ($langselect -eq 'en' ) {
   
        write-host ""
        write-host ""
        write-host "Das Script konfiguriert nun das System für englischsprachige Benutzer"
        write-host ""
        Start-Sleep -Seconds 5

 ##### Registry Einträge schreiben

    # Adobe Schlüssel testen und schreiben
        write-log "Adobe Language Select Schlüssel wird gesetzt"
        write-host "1. Adobe Language Select Schlüssel setzen"
        Set-Location HKCU:
        New-Item -Path ".\Software\Adobe\Acrobat Reader\DC\language" -Name select -Force | out-file C:\support\logs\Pers_log.txt -append
        Get-Childitem ".\Software\Adobe\Acrobat Reader\DC\Language" | out-file C:\support\logs\Pers_log.txt -append
        write-host  ""
        write-host  "Beim Adobe Start kann nun eine Sprache ausgewaehlt werden"
        write-host  ""

    # VLC Schlüssel schreiben 
        write-host "VLC Lang Key wird auf [en] gesetzt:"
        Write-Log 'VLC Key wird auf [en] gesetzt.' -Level Info
        Set-Location HKCU:
        Get-ItemProperty ".\Software\VideoLAN\VLC" -ErrorAction SilentlyContinue | out-file C:\support\logs\Pers_log.txt -append
        write-log "Lösche Wert des Lang Schlüssels"
        Remove-ItemProperty -Path ".\Software\VideoLAN\VLC\" -Name "Lang" -ErrorAction SilentlyContinue | out-file C:\support\logs\Pers_log.txt -append
        write-log "Setzte neuen Wert [en] für Schlüssel Lang"
        New-Item  ".\Software\VideoLAN\VLC" -Force
        New-ItemProperty -Path ".\Software\VideoLAN\VLC\" -Name "Lang" -Value ”en”  -PropertyType "String" -Force | out-file C:\support\logs\Pers_log.txt -append
        write-log " VLC String Lang mit dem Wert [en] wurde erfolgreich unter HKCU:\Software\Video Lan\VLC  gesetzt."

    ##### Dateien ins Dateisystem schreiben #####

    # vlcrc: keine Fragen beim ersten Start / auto update / kein netzwerk discovery
        write-host ""
        write-host  "angepasste vlcrc nach %APPDATA% schreiben"
        write-log "Angepasste vlcrc ins Dateisystem schreiben. "
        Set-Location C:
        write-log "Teste ob vlc Ordner in APPDATA vorhanden ist"
                       
        if ((Test-Path "${appd}\vlc") -eq $true) {
         
            write-host "Angepasste vlcrc ist vorhanden und wird gelöscht."
            write-log "Angepasste vlcrc ist vorhanden. Löschen und neue schreiben" -Level INFO
            Remove-Item "${appd}\vlc" -Force -recurse
            Copy-Item -Path "${muid}\vlc\vlc" -Destination "$appd\" -Recurse
        }
        elseif ((Test-Path "${appd}\vlc") -eq $false) {
            write-host "Angepasste vlcrc wird nach APPDATA geschrieben"
            Copy-Item -Path "${muid}\vlc\vlc" -Destination "$appd\" -Recurse
        }

    # deutsche Sprache aus Notepad++ löschen
        write-host ""
        write-host "Notepad++ wird Englisch"
        write-log "Notepad++ für en-US konfigurieren"

        if ((Test-Path "C:\Program Files\Notepad++\localization\german.xml") -eq $true) {
         
            write-host "Notepad++ german.xml wird gelöscht."
            write-log "Notepad++ german.xml wird gelöscht" -Level INFO
            Remove-Item "C:\Program Files\Notepad++\localization\german.xml" -Force -recurse
                }
        elseif ((Test-Path "C:\Program Files\Notepad++\localization\german.xml") -eq $false) {
                write-log "Notepad++ ist für en-US konfiguriert" -Level Info
        }

        
    # Libre Office zu Englisch machen
        write-host ""
        write-host "Libre OFfice zu en-US"

       Remove-Item "${appd}\LibreOffice" -Force -Recurse -ErrorAction SilentlyContinue
       Copy-Item -Path "${muid}\Libre Office\en\LibreOffice" -Destination "$appd\" -Recurse -Force


        #if ((Test-Path "${appd}\LibreOffice") -eq $true){
        #    write-host "Libre office wird gelöscht"
        #    Remove-Item "${appd}\LibreOffice" -Force -Recurse -ErrorAction SilentlyContinue
        #    Copy-Item -Path "${muid}\Libre Office\en\LibreOffice" -Destination "$appd\" -Recurse -Force
        #    }
        #elseif ((Test-Path "${appd}\LibreOffice") -eq $true){
        #    Copy-Item -Path "${muid}\Libre Office\en\LibreOffice" -Destination "$appd\" -Recurse -Force
        #    Write-Log "Libre Office ist en-US" -Level Info
        #    }

    # Firefox Standard profil kopieren
       write-host ""
        write-host "Firefox Profil für deutsche Benutzer wird nach %APPDATA% kopiert"
        write-log "Firefox en-US wird nach APPDATA kopiert"

        if ((Test-Path "${appd}\Mozilla\Firefox") -eq $true) {
         
            write-host "Firefox profile sind vorhanden und werden gelöscht"
            write-log "Firefox profile werden gelöscht" -Level INFO
            Remove-Item "${appd}\Mozilla\" -Force -recurse
            Copy-Item "${muid}\FF\profile\en\Mozilla" -Destination "$appd\Mozilla\" -Recurse
                }
        elseif ((Test-Path "${appd}\Mozilla\Firefox") -eq $false) {
                Copy-Item "${muid}\FF\profile\en\Mozilla\" -Destination "$appd\Mozilla" -Recurse
                write-log "Firefox ist für en-US konfiguriert" -Level Info
        }
        

    # 7-Zip 
        write-host ""
        write-host "7-Zip wird  Englisch"
        write-log "7-Zip wird Englisch"
        Remove-Item "C:\Program Files\7-Zip\Lang" -Recurse | out-null
        Copy-Item "${muid}\7-zip\en\Lang" -Destination "C:\Program Files\7-Zip" -Recurse

        Set-Location C:\

    # Betriebsystem auf en-US stellen
    # Informationen einholen und bereitstellen

        write-log "Starte Languagepack install"
        write-host ""
        write-host ""
        write-host ""
        Write-Host "###################################################################"
        Write-Host " Aktuelle aktiviertes Culture Set :"$((Get-Culture).Name)
        write-log "System Informationen:"
        [System.Environment]::OSVersion | out-file C:\support\logs\Pers_log.txt -append
        write-log "Pre Language Pack Install Einstellungen:"
        get-culture  | out-file C:\support\logs\Pers_log.txt -append


                write-host "Beginne Language Pack Install"
                write-log "Beginne mit der Installation des Language Packs"

                Add-WindowsPackage -online -PackagePath C:\support\mui_settings\lp..cab -NoRestart -logpath C:\support\logs\langpack_instal_log.txt

                $A = Get-WinUserLanguageList | out-file C:\support\logs\Pers_log.txt -append
                $A.Add("en-us")
                Set-WinUserLanguageList $A -force
                Set-Culture -CultureInfo en-US
                Set-WinSystemLocale -SystemLocale en-US
                Set-WinUserLanguageList -Force -LanguageList "en-US" 
                Set-WinUILanguageOverride -Language en-us
                
                write-host "Das Language Pack en-US wurde installiert."
                write-log "Das Language Pack wurde installiert. Es folgen weitere Informationen zum aktuellen Zustand des Betriebssystems:"
                
                Get-WinHomeLocation | out-file C:\support\logs\Pers_log.txt -append
                Get-WinLanguageBarOption | out-file C:\support\logs\Pers_log.txt -append
                Get-WinSystemLocale | out-file C:\support\logs\Pers_log.txt -append
                Get-WinUserLanguageList | out-file C:\support\logs\Pers_log.txt -append

            
    # Das funktioniert leider nicht
    # Windows Logon Screen Sprache ändern
    #    write-Host " "Systemsteuerung/Region/Administrative Vorlagen/ Willkommensseite und neue User Accounts" Sprache ändern"
    #    write-log "Lade den das aktuelle Benutzer Registry Hive um Sprachänderunegen vorzunehmen"
    #    write-log "Standard System Tastatureinstellung auf Englisch setzten"
          
    # Wens interessiert, its quite magic:
    # https://stackoverflow.com/questions/10908727/how-can-i-programmatically-find-a-users-hkey-users-registry-key-using-powershell
    # Man löst die SID des aktuell angemeldeten Benutzer auf, 
    # kommt so in den HKU Hive (den es std.mäßig nicht als PSDrive gibt), welchselt dann in den .Default Schlüssel und kann da seinenm freien Lauf lassen.

        $User = New-Object System.Security.Principal.NTAccount($env:UserName)
        $sid = $User.Translate([System.Security.Principal.SecurityIdentifier]).value
        New-PSDrive HKU Registry HKEY_USERS
        # Get-Item "HKU:\${sid}" # Das ist der aktuell angemeldete Benutzer
        set-location "HKU:\.DEFAULT\Keyboard Layout\Preload"
        write-log "Schlüsselwerte von HKU:\.DEFAULT\Keyboard Layout\Preload : "
        Get-Item .\ | out-file C:\support\logs\Pers_log.txt -append
        write-log "Lösche Werte des Schlüssels 1 und 2"
        Remove-ItemProperty -Path ".\" -Name "1"
       # Remove-ItemProperty -Path ".\" -Name "2"
        write-log "Setzte neuen Wert [00000409] (en-US) für für beide Werte ein"
        New-ItemProperty -Path ".\" -Name "1" -Value ”00000409”  -PropertyType "String" | out-file C:\support\logs\Pers_log.txt -append
        New-ItemProperty -Path ".\" -Name "2" -Value ”00000409”  -PropertyType "String" | out-file C:\support\logs\Pers_log.txt -append
        write-log "Standard Keyboard Input Sprache ist Englisch"
        
        SET-Location HKLM:\SYSTEM\CurrentControlSet\Control\MUI\Settings
        New-ItemProperty -Path ".\" -Name "PreferredUILanguages" -Value ”en-US”  -PropertyType "String" | out-file C:\support\logs\Pers_log.txt -append
       
    
    set-location "${supd}"
        
    # Ende der englischen Schleife
}



elseif ($langselect -eq 'de') {

        write-host ""
        write-host ""
        write-host "Das Script konfiguriert nun das System für deutschsprachige Benutzer"
        write-host ""
        Start-Sleep -Seconds 5


 ##### Registry Einträge schreiben #####

      # Adobe Schlüssel testen und schreiben
        write-log "Adobe Language Select Schlüssel wird gesetzt"
        write-host "1. Adobe Language Select Schlüssel setzen"
        Set-Location HKCU:
        New-Item -Path ".\Software\Adobe\Acrobat Reader\DC\language" -Name select -Force | out-file C:\support\logs\Pers_log.txt -append
        Get-Childitem ".\Software\Adobe\Acrobat Reader\DC\Language" | out-file C:\support\logs\Pers_log.txt -append
        write-host  ""
        write-host  "Beim Adobe Start kann nun eine Sprache ausgewaehlt werden"
        write-host  ""

    # VLC Schlüssel schreiben 
        write-host "VLC Lang Key wird auf [de] gesetzt:"
        Write-Log 'VLC Key wird auf [de] gesetzt.' -Level Info
        Set-Location HKCU:
        Get-ItemProperty ".\Software\VideoLAN\VLC" -ErrorAction SilentlyContinue | out-file C:\support\logs\Pers_log.txt -append
        write-log "Lösche Wert des Lang Schlüssels"
        Remove-ItemProperty -Path ".\Software\VideoLAN\VLC\" -Name "Lang" -ErrorAction SilentlyContinue | out-file C:\support\logs\Pers_log.txt -append
        write-log "Setzte neuen Wert [de] für Schlüssel Lang"
        New-Item  ".\Software\VideoLAN\VLC" -Force
        New-ItemProperty -Path ".\Software\VideoLAN\VLC\" -Name "Lang" -Value ”de”  -PropertyType "String" -Force | out-file C:\support\logs\Pers_log.txt -append
        write-log " VLC String Lang mit dem Wert [de] wurde erfolgreich unter HKCU:\Software\Video Lan\VLC  gesetzt."

 ##### Dateien ins Dateisystem schreiben #####

    # vlcrc: keine Fragen beim ersten Start / auto update / kein netzwerk discovery
        write-host ""
        write-host  "angepasste vlcrc nach %APPDATA% schreiben"
        write-log "Angepasste vlcrc ins Dateisystem schreiben. "
        Set-Location C:
        write-log "Teste ob vlc Ordner in APPDATA vorhanden ist"
                       
        if ((Test-Path "${appd}\vlc") -eq $true) {
         
            write-host "Angepasste vlcrc ist vorhanden und wird gelöscht."
            write-log "Angepasste vlcrc ist vorhanden. Löschen und neue schreiben" -Level INFO
            Remove-Item "${appd}\vlc" -Force -recurse
            Copy-Item -Path "${muid}\vlc\vlc" -Destination "$appd\" -Recurse
        }
        elseif ((Test-Path "${appd}\vlc") -eq $false) {
            write-host "Angepasste vlcrc wird nach APPDATA geschrieben"
            Copy-Item -Path "${muid}\vlc\vlc" -Destination "$appd\" -Recurse
        }

    # deutsche Sprache aus Notepad++ löschen

        write-host ""
        write-host "Notepad++ wird Englisch"
        write-log "Notepad++ für en-US konfigurieren"

        if ((Test-Path "C:\Program Files\Notepad++\localization\english.xml") -eq $true) {
         
            write-host "Notepad++ english.xml wird gelöscht."
            write-log "Notepad++ english.xml wird gelöscht" -Level INFO
            Remove-Item "C:\Program Files\Notepad++\localization\english.xml" -Force -recurse
                }
        elseif ((Test-Path "C:\Program Files\Notepad++\localization\english.xml") -eq $false) {
                write-log "Notepad++ ist für en-US konfiguriert" -Level Info
        }

    # Libre Office zu deutsch machen
        write-host ""
        write-host "Libre OFfice "
        Remove-Item "${appd}\LibreOffice" -Recurse  -ErrorAction SilentlyContinue | out-null
        Copy-Item -Path "${muid}\Libre Office\de\LibreOffice" -Destination "$appd\" -Recurse -Force -ErrorAction Ignore

    # Firefox Standard profil kopieren
        write-host ""
        write-host "Firefox Profil für deutsche Benutzer wird nach %APPDATA% kopiert"
        write-log "Firefox de-DE wird nach APPDATA kopiert"

                if ((Test-Path "${appd}\Mozilla\Firefox") -eq $true) {
         
            write-host "Firefox profile sind vorhanden und werden gelöscht"
            write-log "Firefox profile werden gelöscht" -Level INFO
            Remove-Item "${appd}\Mozilla\Firefox" -Force -recurse
            Copy-Item "${muid}\FF\profile\de\Mozilla\" -Destination "$appd\Mozilla\" -Recurse
                }
        elseif ((Test-Path "${appd}\Mozilla\Firefox") -eq $false) {
               Copy-Item "${muid}\FF\profile\de\Mozilla\" -Destination "$appd\Mozilla" -Recurse
               write-log "Firefox ist für de-DE konfiguriert" -Level Info
        }

    # 7-Zip 
        write-host ""
        write-host "7-Zip wird  Deutsch"
        write-log "7-Zip wird Deutsch"
        Remove-Item "C:\Program Files\7-Zip\Lang" -Recurse | out-null
        Copy-Item "${muid}\7-zip\de\Lang" -Destination "C:\Program Files\7-Zip" -Recurse

        Set-Location "${supd}"

    # IrfranView
        write-host ""
        write-host "IrfranView wird deutsch"
        Remove-Item "C:\Program Files\IrfanView\i_view64.ini"
        Copy-Item "${muid}\IrfranView\de\i_view64.ini" -Destination "C:\Program Files\IrfanView\"
        }      
# Ende der deutschen Schleife



##### Windows Aktivierung #####
write-host ""
write-host ""
write-host ""
write-host ""
write-host "Windows und Office werden nun aktiviert"




$OSVer = (Get-WmiObject -class Win32_OperatingSystem).Caption
Write-Output "$OSVer , Found!"
$OSA = $OSVer.Replace(" ","")

    $OSKey = ""
    cscript c:\windows\system32\slmgr.vbs /ipk $OSkey
    cscript c:\windows\system32\slmgr.vbs /dli
    write-host ""
    Write-Host "Das Betriebsystem wurde erfolgreich aktiviert" -ForegroundColor Green
    write-host ""

##### Office Aktivierung #####

write-host ""
write-host "Office Wird nun aktiviert"
Write-Log "Status der Office Installation wird abgerufen" -Level Info
Write-Host ""
Set-Location "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /dstatus | out-file C:\support\logs\Pers_log.txt -append
cscript ospp.vbs /inpkey:
cscript ospp.vbs /act
cscript ospp.vbs /dstatus


write-host ""
Write-Host "Das Script endet hier...... cya!"
Start-Sleep -Seconds 2
exit