## Passwords not req
>Attribut userAccountControl=66082
```powershell
Get-ADUser -Filter {PasswordNotRequired -eq $true}
```
```powershell
# deactivated but no pw is enforced
Get-ADUser -property userAccountControl -LDAPfilter “(userAccountControl=66082)”
```
## Passwords req
>Attribut userAccountControl=66050
```powershell
# change it
Get-ADUser -Identity Guest | Set-ADUser -PasswordNotRequired $false
```
```powershell
# check if successfull
Get-ADUser -property userAccountControl -LDAPfilter “(userAccountControl=66050)” | Select-Object SamAccountName,Name,FirstName,LastName,UPN | Format-Table
```
