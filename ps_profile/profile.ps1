<#
.SYNOPSIS
 Powershell Profile 

.DESCRIPTION
2020 - 2022
 
.NOTES
All additional scripts and functions which should be loaded by default wwhen a new ps session starts have to be placed in 
C:\support\code\_git-repos\POSH\ps_functions
Test

Set custom profile path
powershell -noprofile -noexit -command "invoke-expression '. ''$PATHprofile.ps1''' "
#>

# Set default console output to verbose
# $PSDefaultParameterValues=@{"*:Verbose"=$True}

# More debug
Set-PSDebug -Trace 1

# Living on the edge of things
# Set-ExecutionPolicy -ExecutionPolicy remotesigned -Scope CurrentUser 

# The FEEL!
# Autocompletion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Don't waste time 
$host.ui.RawUI.WindowTitle='Black Magic' # Set window title



# Import ps files
$Path = "C:\support\code\git-repos\starfunkel\powershell_stuff\ps_functions"
Get-ChildItem -Path $Path  -Recurse -Filter *.ps1 |
    ForEach-Object {
        . $_.FullName
    }

# Set module dir
$env:PSModulePath = (
    (
        @("C:\support\code\git-repos\starfunkel\powershell_stuff\ps-modules") + ($env:PSModulePath -split ";")
    ) -join ";"
)



# Start with this:
#Clear-Host

# Start at that:
Set-Location c:\support

# Get the time
function Get-Time
    { return $(get-date |
        ForEach-Object { $_.ToLongTimeString() } 
              )
    }

### Colored and fancy!
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

# Get the weather
function getw       {(Invoke-WebRequest http://wttr.in/:Berlin?0M -UserAgent "curl" -ErrorAction SilentlyContinue ).Content}
getw

# Good luck! You are on your own now!
