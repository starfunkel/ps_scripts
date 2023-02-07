<#
.SYNOPSIS
Cra's Powershell Profile 

.DESCRIPTION
2020 - 2022
 
.NOTES
All additional scripts and functions which should be loaded by default wwhen a new ps session starts have to be placed in 
C:\support\code\_git-repos\POSH\ps_functions
Test

Set custom profile path
powershell -noprofile -noexit -command "invoke-expression '. ''$PATHprofile.ps1''' "
#>

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser # Living on the edge of things ;-)
$host.ui.RawUI.WindowTitle='Black Magic' # Set window title
Clear-Host

# Get time for prompt
function Get-Time
    { return $(get-date |
        ForEach-Object { $_.ToLongTimeString() } 
              )
    }

### Colored and tiny time prompt
function prompt

    {   
        # Write the username, computername, time and direcory
        write-host "[" -noNewLine
        write-host "$env:username"  -ForegroundColor red -noNewLine
        write-host "@"  -ForegroundColor white -noNewLine
        write-host "$env:COMPUTERNAME " -ForegroundColor DarkCyan -noNewLine
        write-host $(Get-Time) -foreground yellow -noNewLine
        write-host "] "

        # Write the path
        write-host $($(Get-Location).Path.replace($home,"~").replace("\","/")) -foreground green -noNewLine
        write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
        return "> "
    }

# Get weather forecast function
function getw       {(Invoke-WebRequest http://wttr.in/:Berlin?0M -UserAgent "curl" -ErrorAction SilentlyContinue ).Content}

# Handling & Moving in posh

# Autocompletion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Set default console output to verbose
# $PSDefaultParameterValues=@{"*:Verbose"=$True}

# Import ps scripts and definitions by iterating through each folder 
$Path = "C:\support\code\_git-repos\cras_stuff\POSH\ps_functions"
Get-ChildItem -Path $Path  -Recurse -Filter *.ps1 |
    ForEach-Object {
        . $_.FullName
    }

# Set Custom PS module directory
$env:PSModulePath = (
    (
        @("C:\support\code\_git-repos\cras_stuff\POSH\ps-modules") + ($env:PSModulePath -split ";")
    ) -join ";"
)

# Start with this:
getw

# Setting Start Dir
Set-Location c:\support

