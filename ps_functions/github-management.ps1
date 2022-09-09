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

function ga         { ### auto commits all the things in the current directory
                        
                        param([string]$MESSAGE = "auto commit - nothing to special")

                        git add .
                        git commit -m $MESSAGE
                        git push
                        Remove-Variable -Name MESSAGE
}

function gitc     { ### evtl Parameter: repo, message

                    $repos =    "C:\support\code\_git-repos\cras_stuff\POSH",`
                                "C:\support\code\_git-repos\cras_stuff\get-ADInfo",`
                                "C:\support\code\_git-repos\iit_\iit-ansible-inventory",`
                                "C:\support\code\_git-repos\iit_\BKG-CLI-Onboarding",`
                                "C:\support\code\_git-repos\iit_\BKG-GUI-Verwaltungstool"

                    foreach ($repo in $repos) {

                    $CURRENT_PATH = (Get-Location).path
                    Set-Location $repo
                    Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
                    $folder = Split-Path -leaf -path (Get-Location)
                    Write-Host "              $folder" -ForegroundColor Green  
                    Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
                    git add .
                    git commit -m "Auto-commit" 
                    git push
                    Write-Host "" -ForegroundColor Green

                    Set-Location $CURRENT_PATH
                    Remove-Variable -Name CURRENT_PATH
                    }         
}