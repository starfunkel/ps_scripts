audit Pol
auditpol.exe /get /category:* /r  | ConvertFrom-Csv |
Format-Table Richtlinienziel,Unterkategorie,Aufnahmeeinstellung,Ausschlusseinstellung

auditpol.exe /get /category:*

#### stale ad computers

Get-ADComputer -filter * -Proper Name, DisplayName, SamAccountName, lastlogondate, PasswordLastSet, enabled |
sort lastlogondate |
ft Name, DisplayName, SamAccountName, lastlogondate, PasswordLastSet, enabled