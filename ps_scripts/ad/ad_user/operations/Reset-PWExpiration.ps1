<#
.SYNOPSIS
    This script lists and resets the pw expiration state.

#>

function Reset-PWExpiration {
    [CmdletBinding()]
    [Alias("RPWE")]
    param(
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValueFromPipeline = $true)]
        [Alias("User")]
        [string[]]$User
    )

    Begin {}

    Process {
        foreach ($u in $User) {
            # Show current pwdLastSet
            $before = Get-ADUser $u -Properties pwdLastSet | 
                      Select-Object SamAccountName, @{Name="pwdLastSet";Expression={[datetime]::FromFileTime($_.pwdLastSet)}}
            Write-Host "`nCurrent password set time for $u :"
            $before | Format-Table -AutoSize

            # Prompt
            $confirm = Read-Host "Do you want to reset the password expiration for $u? (Y/N)"
            if ($confirm -match '^(Y|y)$') {
                # Reset logic
                Get-ADUser $u -Replace @{pwdLastSet='0'} | Out-Null
                Set-ADUser $u -Replace @{pwdLastSet='-1'}

                # Show updated pwdLastSet
                $after = Get-ADUser $u -Properties pwdLastSet | 
                         Select-Object SamAccountName, @{Name="pwdLastSet";Expression={[datetime]::FromFileTime($_.pwdLastSet)}}
                Write-Host "`nUpdated password set time for $u :"
                $after | Format-Table -AutoSize
            }
            else {
                Write-Host "Skipped $u" -ForegroundColor Yellow
            }
        }
    }

    End {}
}