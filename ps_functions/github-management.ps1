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

                        $CURRENT_PATH = (Get-Location).path                    
                        Write-Host "-------------------------------------------------------------------`n###################################################################`n-------------------------------------------------------------------"   -InformationVariable LINEDELIMITERS

                        ### powershell_stuff Repo in C:\support\code\_git-repos\cras_stuff\POSH
                        Write-Host "PS Helper functions Repo commit (powershell_stuff)" -ForegroundColor Yellow
                        Set-Location "C:\support\code\_git-repos\cras_stuff\POSH"
                        git add .
                        git commit -m "Auto-commit" 
                        git push
                        Write-Host "POSH Repo comitted" -ForegroundColor Green
                        
                        ###  get-adinfo Repo in C:\support\code\_git-repos\cras_stuff\get-ADInfo
                        $LINEDELIMITERS
                        Write-Host "Get-ADInfo Repo commit" -ForegroundColor Yellow
                        Set-Location "C:\support\code\_git-repos\cras_stuff\get-ADInfo"
                        git add .
                        git commit -m "Auto-commit" 
                        git push
                        Write-Host "Get-ADInfo Repo comitted" -ForegroundColor Green

                        ### iit-ansible-inventory C:\support\code\_git-repos\iit_\iit-ansible-inventory
                        $LINEDELIMITERS
                        Write-Host "iit-ansible Repo commit (iit-ansible-inventory)" -ForegroundColor Yellow
                        Set-Location "C:\support\code\_git-repos\iit_\iit-ansible-inventory"
                        git add .
                        git commit -m "Auto-commit" 
                        git push
                        Write-Host "iit-asible-inventory Repo comitted" -ForegroundColor Green
                                                
                        ### BKG-CLI-Onboarding C:\support\code\_git-repos\iit_\BKG-CLI-Onboarding
                        $LINEDELIMITERS
                        Write-Host "iit-ansible Repo commit (BKG-CLI-Onboarding)" -ForegroundColor Yellow
                        Set-Location "C:\support\code\_git-repos\iit_\BKG-CLI-Onboarding"
                        git add .
                        git commit -m "Auto-commit" 
                        git push
                        Write-Host "BKG-CLI-Onboarding" -ForegroundColor Green
                        
                        Set-Location $CURRENT_PATH
                        Remove-Variable -Name CURRENT_PATH
}