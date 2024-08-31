# export apw audit script
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$DirectoryName = "AD_AUDIT_$((Get-Date).ToString('yyyyMMdd'))"
$AuditFolder = Join-Path $DesktopPath $DirectoryName


get-ADUser  -Properties *  -Filter {name -like "IUS*"} |
select-object DistinguishedName, SamAccountName, LastLogonDate |
Export-Csv $AuditFolder\iusr_user_accounts.csv -NoTypeInformation

get-ADUser  -Properties *  -Filter {name -like "IWAM*"} |
select-object DistinguishedName, SamAccountName, LastLogonDate |
Export-Csv $AuditFolder\iwam_user_accounts.csv -NoTypeInformation