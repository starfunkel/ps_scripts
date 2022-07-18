<#
    .SYNOPSIS
    Powershell functions for working with Git commands to easaly commit and push repos to Github even in system directories

    .DESCRIPTION
    These functions will programmatically utilize git add . ; auto commit -m ; and push.  

    Beware that repo directories have to be hardoced in here to make it work
    .EXAMPLE
            
    .NOTES
    Heavy work in progress
#>


### Github Management

function ga         {
                        
                        param([string]$MESSAGE = "auto commit - nothing to special")

                        git add .
                        git commit -m $MESSAGE
                        git push
                        Remove-Variable -Name MESSAGE
}

function gitc     { ### evtl Parameter: repo, message

                        $CURRENT_PATH = (Get-Location).path                    
                        Write-Host "-------------------------------------------------------------------`n###################################################################`n-------------------------------------------------------------------"   -InformationVariable LINEDELIMITERS
                        
                        <#
                        ### powershell_profile (System32) Commit
                        Write-Host "Elevating for Powershell Profile commit..." -ForegroundColor Yellow
                        start-Sleep 1
                        Start-Process -FilePath powershell.exe -ArgumentList { ### evtl Start-job hieraus machen
                            Write-Host "-------------------------------------------------------------------`n###################################################################`n-------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
                            $PID # Gets Process ID of current Process
                            Clear-Host
                            ""
                            $LINEDELIMITERS
                            Set-Location $PSHOME
                            Write-Host "Powershell Profile commit (Sys32)"
                            ""
                            git add .\profile.ps1
                            ""
                            git commit -m "Profile_Updated"
                            ""
                            git push
                            ""
                            Write-Host "Profile (Sys32) comitted" -ForegroundColor Green
                            $LINEDELIMITERS
                            start-Sleep 2
                            stop-process -id $PID
                        } -verb RunAs
                        #>
  
                        ### powershell_stuff Repo in C:\support\code\_git-repos\cras_stuff\POSH
                        $LINEDELIMITERS
                        Write-Host "PS Helper functions Repo commit (powershell_stuff)" -ForegroundColor Yellow
                        ""
                        Set-Location "C:\support\code\_git-repos\cras_stuff\POSH"
                        git add .
                        ""
                        git commit -m "Auto-commit" 
                        ""
                        git push
                        ""
                        Write-Host "POSH Repo comitted" -ForegroundColor Green
                        Write-Host ""
                        ###  get-adinfo Repo in C:\support\code\_git-repos\cras_stuff\get-ADInfo
                        $LINEDELIMITERS
                        Write-Host ""
                        Write-Host "Get-ADInfo Repo commit" -ForegroundColor Yellow
                        ""
                        Set-Location "C:\support\code\_git-repos\cras_stuff\get-ADInfo"
                        git add .
                        ""
                        git commit -m "Auto-commit" 
                        ""
                        git push
                        ""
                        Write-Host "Get-ADInfo Repo comitted" -ForegroundColor Green

                        Set-Location $CURRENT_PATH
                        Remove-Variable -Name CURRENT_PATH

}