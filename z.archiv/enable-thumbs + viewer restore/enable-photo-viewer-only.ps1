#  +++++ Reaktiviert den Windows photo Viewer und verknüpft Dateiendungen und das Anzeigen von Thumbs im Windows Explorer
#  +++++ (c) cra

#  +++++ Parameter 
param([switch]$Elevated)
function Test-Admin # https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
 {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} 
#  ++++++ Funktionen

function Write-ProgressHelper { # https://adamtheautomator.com/write-progress/
	param (
	    [int]$StepNumber,
	    [string]$Message
	)

	Write-Progress -Activity "..." -Status $Message -PercentComplete (($StepNumber / $steps) * 100)
}



#  ++++++ Variablen

$User = New-Object System.Security.Principal.NTAccount($env:UserName)
$sid = $User.Translate([System.Security.Principal.SecurityIdentifier]).value

$script:steps = ([System.Management.Automation.PsParser]::Tokenize((gc "$PSScriptRoot\$($MyInvocation.MyCommand.Name)"), [ref]$null) | where { $_.Type -eq "Command" -and $_.Content -eq "Write-ProgressHelper" }).Count
$stepCounter = 0

#  ++++++ Code
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

Write-ProgressHelper -Message 'Erstelle HKEY_USERS Hive' -StepNumber ($stepCounter++) 
New-PSDrive HKU Registry HKEY_USERS | Out-Null
New-PSDrive HKCR Registry HKEY_CLASSES_ROOT | Out-Null
Write-ProgressHelper -Message 'Reaktiviere "Windows Old Picture Viewer" ' -StepNumber ($stepCounter++)
Start-Sleep 1
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type string -Value "@photoviewer.dll,-3043"| Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00"
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"| Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap" -Name "ImageOptionFlags" -Type dword -Value 0x00000001 | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap" -Name "FriendlyTypeName" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3056" | Out-Null
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\imageres.dll,-70" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\print" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\print" -Name "NeverDefault" -Type string -Value "" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\print\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\print\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\print\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\print\DropTarget" -Name "Clsid" -Type string -Value "{60fd46de-f830-4894-a628-6fa81bc0190d}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.JFIF" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF" -Name "EditFlags" -Type dword -Value "0x00010000" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF" -Name "ImageOptionFlags" -Type dword -Value "0x00000001" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF" -Name "FriendlyTypeName" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055" | Out-Null
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\DefaultIcon" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\imageres.dll,-72" | Out-Null
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open" -Name "MuiVerb" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg" -Name "EditFlags" -Type dword -Value "0x00010000" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg" -Name "ImageOptionFlags" -Type dword -Value "0x00000001" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg" -Name "FriendlyTypeName" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\imageres.dll,-72" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open" -Name "MuiVerb" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Gif" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Gif" -Name "ImageOptionFlags" -Type dword -Value "0x00000001" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Gif" -Name "FriendlyTypeName" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Gif\DefaultIcon" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Gif\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\imageres.dll,-83" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Png" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Png" -Name "ImageOptionFlags" -Type dword -Value "0x00000001" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Png" -Name "FriendlyTypeName" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057" | Out-Null
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Png\DefaultIcon" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Png\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\imageres.dll,-71" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Wdp" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp" -Name "EditFlags" -Type dword -Value "0x00010000" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp" -Name "ImageOptionFlags" -Type dword -Value "0x00000001" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\DefaultIcon" -Force| Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++) 
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\DefaultIcon" -Name "(Default)" -Type string -Value "%SystemRoot%\\System32\\wmphoto.dll,-400" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open" -Name "MuiVerb" -Type expandstring -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" -Name "Clsid" -Type string -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\SystemFileAssociations\image\shell\Image Preview\command" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\SystemFileAssociations\image\shell\Image Preview\command" -Name "(Default)" -Type string -Value "hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,00,31,00,00,00" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKCR:\SystemFileAssociations\image\shell\Image Preview\DropTarget" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKCR:\SystemFileAssociations\image\shell\Image Preview\DropTarget" -Name "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" -Type string -Value "" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" -Name "ApplicationDescription" -Type string -Value "@%ProgramFiles%\\Windows Photo Viewer\\photoviewer.dll,-3069"| Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" -Name "ApplicationName" -Type string -Value "@%ProgramFiles%\\Windows Photo Viewer\\photoviewer.dll,-3009" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Force | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".cr2" -Type string -Value "PhotoViewer.FileAssoc.Tiff" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".jpg" -Type string -Value "PhotoViewer.FileAssoc.Jpeg" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".wdp" -Type string -Value "PhotoViewer.FileAssoc.Wdp" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".jfif" -Type string -Value "PhotoViewer.FileAssoc.JFIF" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".dib" -Type string -Value "PhotoViewer.FileAssoc.Bitmap" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".png" -Type string -Value "PhotoViewer.FileAssoc.Png" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".jxr" -Type string -Value "PhotoViewer.FileAssoc.Wdp" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".bmp" -Type string -Value "PhotoViewer.FileAssoc.Bitmap" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".jpe" -Type string -Value "PhotoViewer.FileAssoc.Jpeg" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".jpeg" -Type string -Value "PhotoViewer.FileAssoc.Jpeg" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".gif" -Type string -Value "PhotoViewer.FileAssoc.Gif" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".tif" -Type string -Value "PhotoViewer.FileAssoc.Tiff" | Out-Null
Write-ProgressHelper -Message 'Schreibe Keys' -StepNumber ($stepCounter++)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name ".tiff" -Type string -Value "PhotoViewer.FileAssoc.Tiff" | Out-Null
Write-ProgressHelper -Message 'Beende explorer.exe' -StepNumber ($stepCounter++)
Stop-Process -ProcessName explorer -Force 
Set-Location C:\support\
