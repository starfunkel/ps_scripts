<#
.SYNOPSIS
Cra's Powershell Profile 

.DESCRIPTION
2020 - 2022
 
.NOTES
<<<<<<< HEAD
All additional scripts and functions which should be loaded by default wwhen a new ps session starts have to be placed in 
C:\support\code\_git-repos\POSH\ps_functions ( See line 55 in code ) 
Test

Set custom profile path

powershell -noprofile -noexit -command "invoke-expression '. ''$PATHprofile.ps1''' "
=======
All additional scripts and functions which should be loaded by default when a new ps session starts have to be placed according to line 59

To Do:

Build variables for custom location folders

>>>>>>> 6427c361d34083c30841c047062ec40ae2ef70be
#>

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

$host.ui.RawUI.WindowTitle='Black Magic'

Clear-Host

<#
Write-Host "##########################" -ForegroundColor Yellow 
Write-Host "#                        #" -ForegroundColor Yellow
Write-Host "#      Hello Friend!     #" -ForegroundColor Yellow
Write-Host "#                        #" -ForegroundColor Yellow
Write-Host "##########################" -ForegroundColor Yellow
#>

### Colored and timy time promt
function prompt

{   # Write the time and dir
    write-host "[" -noNewLine
    write-host $(Get-Time) -foreground yellow -noNewLine
    write-host "] " -noNewLine
    # Write the path
    write-host $($(Get-Location).Path.replace($home,"~").replace("\","/")) -foreground green -noNewLine
    write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
    return "> "
}

### Get weather
function getw       {(Invoke-WebRequest http://wttr.in/:Berlin?0M -UserAgent "curl" -ErrorAction SilentlyContinue ).Content}
getw

### Get time for prompt
function Get-Time   { return $(get-date | ForEach-Object { $_.ToLongTimeString() } ) }


### Handling & Moving

### Autocompletion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

### Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

### Import ps scripts and definitions by iterating through each folder 
$Path = "C:\support\code\_git-repos\cras_stuff\POSH\ps_functions"
Get-ChildItem -Path $Path  -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}

<<<<<<< HEAD
# Set custom Module Path
=======
### Set Custom PS module directory
>>>>>>> 6427c361d34083c30841c047062ec40ae2ef70be
$env:PSModulePath = ((@("C:\support\code\_git-repos\cras_stuff\POSH\ps-modules") + ($env:PSModulePath -split ";")) -join ";")

### Setting Start Dir
Set-Location c:\support

