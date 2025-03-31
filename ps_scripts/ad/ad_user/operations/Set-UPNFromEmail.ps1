<#
.SYNOPSIS
    This script prompts for OU
    Skips users without email
    Avoids redundant changes

    #VIBE Coded ;-)
#>

function Update-UPNFromEmail {
    [CmdletBinding()]
    param ()

    # Prompt for OU Distinguished Name
    $ouDN = Read-Host "Enter the OU Distinguished Name (e.g. OU=Users,DC=domain,DC=local)"
    
    # Validate input
    if (-not $ouDN) {
        Write-Error "OU Distinguished Name cannot be empty. Exiting."
        return
    }

    # Get users from specified OU
    try {
        $users = Get-ADUser -Filter * -SearchBase $ouDN -Properties EmailAddress, UserPrincipalName, SamAccountName
    } catch {
        Write-Error "Failed to retrieve users. Check if the OU DN is valid."
        return
    }

    foreach ($user in $users) {
        if ($user.EmailAddress) {
            $newUPN = $user.EmailAddress

            if ($user.UserPrincipalName -ne $newUPN) {
                try {
                    Set-ADUser -Identity $user -UserPrincipalName $newUPN
                    Write-Host "Updated UPN for $($user.SamAccountName) to $newUPN" -ForegroundColor Green
                } catch {
                    Write-Warning "Failed to update UPN for $($user.SamAccountName): $_"
                }
            }
        }
    }
}