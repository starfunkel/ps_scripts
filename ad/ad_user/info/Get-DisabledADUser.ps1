<#
.SYNOPSIS
    Get detailed information about disabled AD-users in the current domain
#>

Function Get-DisabledADUser {
Get-ADUser -Filter {Enabled -eq $false} -Properties samaccountname, Name, lastlogondate, LastBadpasswordAttempt, PasswordLastSet |
Sort-Object LastLogonDate |
Format-Table samaccountname, Name, lastlogondate, LastBadpasswordAttempt, PasswordLastSet
}