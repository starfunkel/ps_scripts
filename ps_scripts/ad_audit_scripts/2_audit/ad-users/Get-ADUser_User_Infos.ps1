#
# export pw audit script
#

# define file path
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$DirectoryName = "AD_AUDIT_$((Get-Date).ToString('yyyyMMdd'))"
$AuditFolder = Join-Path $DesktopPath $DirectoryName
New-Item -Path $DesktopPath -Name $DirectoryName -ItemType Directory

# export users with pw not required
Get-ADUser -Filter {PasswordNotRequired -eq $true} `
    -Properties name,DistinguishedName, SamAccountName, LastLogonDate,PasswordLastSet,whenCreated,whenChanged |
    Export-Csv -Path $AuditFolder\pw_not_req.csv -NoTypeInformation 

#
# PW not required, logged on at least once
#

# logged on in the past 90 days
get-ADUser -Filter 'passwordNeverExpires -eq "false" -and lastlogondate -ne "$null -and $_.lastlogondate -le ((get-date).adddays(-90))"' `
    -Properties name, DistinguishedName, SamAccountName, passwordlastset, whencreated, lastlogondate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\user_pw_exp_status_D90.csv -NoTypeInformation

# logged on in the past 60 days
get-ADUser -Filter 'passwordNeverExpires -eq "false" -and lastlogondate -ne "$null and $_.lastlogondate -le ((get-date).adddays(-60))"' `
    -Properties name, DistinguishedName, SamAccountName, passwordlastset, whencreated, lastlogondate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\user_pw_exp_status_D60.csv -NoTypeInformation

# logged on in the past 30 days
get-ADUser -Filter 'passwordNeverExpires -eq "false" -and lastlogondate -ne "$null -and $_.lastlogondate -le ((get-date).adddays(-30))"' `
    -Properties name, DistinguishedName, SamAccountName, passwordlastset, whencreated, lastlogondate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\user_pw_exp_status_D30.csv -NoTypeInformation

#
# delegation check
#

# Admins who are delegated
Get-ADUser -Filter  "admincount -eq 1" `
    -Properties name, DistinguishedName, SamAccountName, passwordlastset, whencreated, lastlogondate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\admin_count_eq_1.csv -NoTypeInformation

# user account delegation
Get-ADUser -Filter  "admincount -eq 1 -and AccountNotDelegated -eq '$false'" `
    -Properties samaccountname, DistinguishedName, enabled, LastLogonDate, PasswordLastSet, SID |
    Export-Csv $AuditFolder\admin_delegation.csv -NoTypeInformation

#
# password never PasswordNeverExpires
#


# Accounts with password never exp
get-ADUser -Filter 'passwordNeverExpires -eq $true' `
    -Properties name, DistinguishedName, SamAccountName, passwordlastset, whencreated, lastlogondate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\user_pw_exp_status.csv -NoTypeInformation

# active accounts with password never expire
Get-ADUser -Filter "PasswordNeverExpires -eq '$true' -and Enabled -eq '$true'" `
    -Properties Name, DistinguishedName, SamAccountName, PasswordLastSet, WhenCreated, LastLogonDate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\active_user_pw_exp_status.csv -NoTypeInformation

# disabled users

Get-ADUser -Filter "Enabled -eq '$false'" `
    -Properties Name, DistinguishedName, SamAccountName, PasswordLastSet, WhenCreated, LastLogonDate, PasswordNeverExpires |
    Export-Csv -Path $AuditFolder\disabled_user_pw_exp_status.csv -NoTypeInformation