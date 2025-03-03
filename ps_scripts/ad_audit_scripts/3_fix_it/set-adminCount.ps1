<#
.SYNOPSIS
    Resets AdminCount flag on AD-User's which have this flag. 
#>

function Reset-AdminCount {
    param (
        [CmdletBinding()]
        [switch]$ConfirmDeletion
    )

    $adminUsers = Get-ADUser -Filter 'adminCount -eq 1' -Properties adminCount | Select-Object Name, SamAccountName
    
    if ($adminUsers) {
        Write-Host "AD-Users with adminCount set to 1:" -ForegroundColor Yellow
        $adminUsers | Format-Table -AutoSize

        $response = Read-Host "Reset flag (Y/N)?"
        if ($ConfirmDeletion -or $response -eq 'Y') {
            foreach ($user in $adminUsers) {
                Set-ADUser -Identity $user.SamAccountName -Replace @{adminCount=0} -WhatIf
                Write-Host "Reset adminCount for: $($user.Name)" -ForegroundColor Green
            }
        } else {
            Write-Host "Aborting" -ForegroundColor Cyan
        }
    } else {
        Write-Host "No users found with adminCount set to 1." -ForegroundColor Cyan
    }
}