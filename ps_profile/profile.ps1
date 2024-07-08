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

#$executionTime = Measure-Command `
#{

    # Set default console output to verbose
    # $PSDefaultParameterValues=@{"*:Verbose"=$True}

    # More debug
    #Set-PSDebug -Trace 1

    # Living on the edge of things
    # Set-ExecutionPolicy -ExecutionPolicy remotesigned -Scope CurrentUser 

    # The FEEL!
    # Autocompletion
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

    # Autocompletion for arrow keys
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

    # Better Powershell handling
    Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardWord
    Set-PSReadLineKeyHandler -Chord 'Enter' -Function ValidateAndAcceptLine

    # Hide duplicates entry in Powershells history
    Set-PSReadlineOption -HistoryNoDuplicates

    # Don't waste time; do the most important!
    $host.ui.RawUI.WindowTitle='Black Magic' # Set window title

    # Set meaningful output
    Set-StrictMode -Version 2

    # Import ps files
    $FuncPath = "C:\support\code\git-repos\starfunkel\powershell_stuff\ps_functions"
    Get-ChildItem -Path $FuncPath  -Recurse -Filter *.ps1 |
        ForEach-Object {
            . $_.FullName
        }

    # Set module dir
    $env:PSModulePath = (
        (
            @("C:\support\code\git-repos\starfunkel\powershell_stuff\ps-modules") + ($env:PSModulePath -split ";")
        ) -join ";"
    )

    # Set DefaultParameterDefinitions

    . C:\support\code\git-repos\starfunkel\powershell_stuff\env\def_param_vals.ps1
    . C:\support\code\git-repos\starfunkel\powershell_stuff\env\def_chainsaw_dir.ps1

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


if (!(Test-Path HKCR:)) {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
}

#}
#Write-Host "$PSCommandPath execution time: $executionTime"

# Set envs

$env:Path += ";C:\Program Files\OpenSSL\bin"
$env:OPENSSL_CONF = "C:\support\certs\openssl.cnf"