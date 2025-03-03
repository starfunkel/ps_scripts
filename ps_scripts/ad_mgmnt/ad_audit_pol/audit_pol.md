audit Pol
auditpol.exe /get /category:* /r  | ConvertFrom-Csv |
Format-Table Richtlinienziel,Unterkategorie,Aufnahmeeinstellung,Ausschlusseinstellung

auditpol.exe /get /category:*

