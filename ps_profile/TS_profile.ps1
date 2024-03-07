<#
.SYNOPSIS
Cras Powershell Profile Terminal Server Edition

.DESCRIPTION
2020 - 2024
 
.NOTES
Rename before use!
#>

# Powershell handling
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Enter' -Function ValidateAndAcceptLine
Set-PSReadlineOption -HistoryNoDuplicates

# fun and color
$host.ui.RawUI.WindowTitle='TS magic'
$console.backgroundcolor = "black"
$console.foregroundcolor = "white"

Set-StrictMode -Version 2

# Prompt
# Get the time
    function Get-Time
        { return $(get-date |
            ForEach-Object { $_.ToLongTimeString() } 
                )
        }

    ### Colored and fancy!
    function prompt
        {   
            # print the username, computername, time and direcory
            write-host "[" -noNewLine
            write-host "$env:username"  -ForegroundColor red -noNewLine
            write-host "@"  -ForegroundColor white -noNewLine
            write-host "$env:COMPUTERNAME " -ForegroundColor DarkCyan -noNewLine
            write-host $(Get-Time) -foreground yellow -noNewLine
            write-host "] "

            # print the path
            write-host $($(Get-Location).Path.replace($home,"~").replace("\","/")) -foreground green -noNewLine
            write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
            return "> "
        }