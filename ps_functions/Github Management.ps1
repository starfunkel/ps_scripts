<#
    .SYNOPSIS
    Powershell & Git  combined functions to easy commit and push repos to Github

    .DESCRIPTION
    These functions will programmatically utilize git add . , auto commit -m ; and push.  

    Beware that repo directories have to be hardoced in here to make it function
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

function git-ps     {

                        Write-Host ""
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "Powershell Profile commit" -ForegroundColor Yellow
                        $current_path = (Get-Location).path
                        
                        Start-Process -FilePath powershell.exe -ArgumentList {
                            Set-Location $PSHOME
                            git add .\profile.ps1
                            git commit -m "Profile_Updated"
                            git push
                        } -verb RunAs 
                        
                        Write-Host "Profile commited" -ForegroundColor Green
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "-------------------------------------------------------------------"
                        Write-Host "POSH Repo commit" -ForegroundColor Yellow

                        Set-Location C:\support\code\_git-repos\POSH
                        git add .
                        git commit -m "Functions and Definitions Update" 
                        git push
                        Write-Host "POSH Repo commited" -ForegroundColor Green
                        Write-Host "-------------------------------------------------------------------"
                        
                        Set-Location $current_path
                        Remove-Variable -Name current_path
                        ""
}