### AD On-Prem Bitlocker recovery key Validation Check

- This script searches a specific OU and checks if a bitlocker recovery key is stored

```powershell
# Edit 
# OU defintion
$ou = "OU=xyc,DC=domain,DC=com"
$csvExportPath = "PATH\TO\CSV"
```