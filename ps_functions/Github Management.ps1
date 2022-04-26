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
                        
                        param([string]$message = "auto commit - nothing to special")

                        git add .
                        git commit -m $message
                        git push
                        Remove-Variable -Name message
}

function gitc     {

                        $LINEDELIMITERS=Write-Host "zzz-------------------------------------------------------------------`n###################################################################`n-------------------------------------------------------------------"                    

                        ### powershell_profile (System32) Commit

                        $current_path = (Get-Location).path                    
                        $LINEDELIMITERS
                        Write-Host "Elevating for Powershell Profile commit..." -ForegroundColor Yellow
                        start-Sleep 1
                        
                        Start-Process -FilePath powershell.exe -ArgumentList {
                            $PID
                            Clear-Host
                            ""
                            Write-Host "-------------------------------------------------------------------"
                            Write-Host "###################################################################"
                            Write-Host "-------------------------------------------------------------------"
                            Write-Host "Powershell Profile commit"
                            Set-Location $PSHOME
                            ""
                            git add .\profile.ps1
                            ""
                            git commit -m "Profile_Updated"
                            ""
                            git push
                            ""
                            Write-Host "Profile comitted" -ForegroundColor Green
                            Write-Host "-------------------------------------------------------------------"
                            Write-Host "###################################################################"
                            Write-Host "-------------------------------------------------------------------"
                            start-Sleep 4
                            stop-process -id $PID
                        } -verb RunAs
                        

                        ### powershell_stuff Repo in C:\support\code\_git-repos\POSH

                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "###################################################################"
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "POSH Repo commit" -ForegroundColor Yellow
                        ""
                        Set-Location C:\support\code\_git-repos\POSH
                        git add .
                        ""
                        git commit -m "Auto-commit" 
                        ""
                        git push
                        ""
                        Write-Host "POSH Repo comitted" -ForegroundColor Green

                        ###  get-adinfo Repo in C:\support\code\_git-repos\get-ADInfo

                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "###################################################################"
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "Get-ADInfo Repo commit" -ForegroundColor Yellow
                        ""
                        Set-Location "C:\support\code\_git-repos\get-ADInfo"
                        git add .
                        ""
                        git commit -m "Auto-commit" 
                        ""
                        git push
                        ""
                        Write-Host "Get-ADInfo Repo comitted" -ForegroundColor Green

                        ### Verwaltungstool Repo C:\support\code\_git-repos\Verwaltungstool

                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "###################################################################"
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "Verwaltungstool Repo commit" -ForegroundColor Yellow
                        ""
                        Set-Location "C:\support\code\_git-repos\Verwaltungstool"
                        git add .
                        ""
                        git commit -m "Auto commit"
                        ""
                        git push
                        ""
                        Write-Host "Verwaltungstool Repo comitted" -ForegroundColor Green
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "###################################################################"
                        Write-Host "-------------------------------------------------------------------"

                        Set-Location $current_path
                        Remove-Variable -Name current_path

}