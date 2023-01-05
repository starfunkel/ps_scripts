<#
    .SYNOPSIS
    Powershell functions for easy working with git commands to easaly commit and push repos to Github even in system directories

    .DESCRIPTION
    These functions will programmatically utilize git add . ; auto commit -m ; and push.  

    Beware that repo directories have to be hardoced in here to make it work
    .EXAMPLE
            
    .NOTES
    Heavy work in progress
#>


### Github Management

function ga { ### auto commits all the things in the current directory
                
    param([string]$MESSAGE = "auto commit")

    git add .
    git commit -m $MESSAGE
    git push
    Remove-Variable -Name MESSAGE
}

function gitc   { ### evtl ein Parameter: repo, message

    $CURRENT_PATH = (Get-Location).path
    $repos =    "C:\support\code\_git-repos\cras_stuff\POSH",`
                "C:\support\code\_git-repos\cras_stuff\get-ADInfo",`
                "C:\support\code\_git-repos\iit_\iit-ansible-inventory",`
                "C:\support\code\_git-repos\iit_\BKG-CLI-Onboarding",`
                "C:\support\code\_git-repos\iit_\BKG-GUI-Verwaltungstool",`
                "C:\support\code\_git-repos\iit_\Code-Snips"
                "C:\support\code\_git-repos\cras_stuff\code_snippets"

    foreach ($repo in $repos) {
        Set-Location $repo
        Write-Host "---------------------------------" -ForegroundColor Yellow
        $folder = Split-Path -leaf -path (Get-Location)
        Write-Host "$folder Repository" -ForegroundColor Green  
        Write-Host "---------------------------------" -ForegroundColor Yellow
        git pull
        git add .
        git commit -m "Auto-commit" 
        git push
        Write-Host "" -ForegroundColor Green
    }  
    
    Set-Location $CURRENT_PATH
    Remove-Variable -Name CURRENT_PATH
}