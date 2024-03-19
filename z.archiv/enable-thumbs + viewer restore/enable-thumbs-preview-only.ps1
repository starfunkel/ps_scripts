#  +++++ Reaktiviert den Thumbnail Cache und das Anzeigen von Thumbs im Windows Explorer
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

#   Code

Write-ProgressHelper -Message 'Erstelle HKEY_USERS Hive' -StepNumber ($stepCounter++) 
New-PSDrive HKU Registry HKEY_USERS | Out-Null
New-PSDrive HKCR Registry HKEY_CLASSES_ROOT | Out-Null
Write-ProgressHelper -Message 'Erstelle HKEY_USERS Hive' -StepNumber ($stepCounter++)
Write-ProgressHelper -Message 'Erstelle HKEY_USERS Hive' -StepNumber ($stepCounter++)
Write-ProgressHelper -Message 'Loesche Key 1' -StepNumber ($stepCounter++)
Set-Location HKU:\${sid}\Software\Microsoft\Windows\
Remove-ItemProperty -Path "DWM" -Name "AlwaysHibernateThumbnails" -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path ".\DWM" -Name "AlwaysHibernateThumbnails" -Value "0"  -PropertyType "String"
Write-ProgressHelper -Message 'Loesche Key 2' -StepNumber ($stepCounter++)
Set-Location HKU:\${sid}\Software\Microsoft\Windows\CurrentVersion\Policies\    
Remove-ItemProperty -Path "Explorer" -Name "NoThumbnailCache" -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path ".\Explorer" -Name "NoThumbnailCache" -Value "0"  -PropertyType "String"
Write-ProgressHelper -Message 'Loesche Key 3' -StepNumber ($stepCounter++)
Set-Location HKU:\${sid}\Software\Policies\Microsoft\Windows\
Remove-ItemProperty -Path "Explorer" -Name "DisableThumbsDBOnNetworkFolders" -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path ".\Explorer" -Name "DisableThumbsDBOnNetworkFolders" -Value "0"  -PropertyType "String"
Write-ProgressHelper -Message 'Loesche Key 4' -StepNumber ($stepCounter++)
Set-Location HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies
Remove-ItemProperty -Path "Explorer" -Name "DisableThumbnails" -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path ".\Explorer" -Name "DisableThumbnails" -Value "0"  -PropertyType "String"

Write-ProgressHelper -Message 'Miniaturansichten sind wieder aktiviert.' -StepNumber ($stepCounter++)
Start-Sleep 1
Write-ProgressHelper -Message 'Beende explorer.exe' -StepNumber ($stepCounter++)
Stop-Process -ProcessName explorer -Force 
Set-Location C:\support\