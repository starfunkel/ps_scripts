# Fully Automated Powershell Profile Kickstarter
....
## To do:

- Auto Download and extract Systinternals and accpet EULA via Reg add
- Add Path for sysinternals

### How to use

#### Option 1 
```powershell
$dest = $PROFILE.CurrentUserAllHosts
if (-not (Test-Path $dest)) {New-Item $dest -Type File -Force }
Split-Path $dest | Push-Location
Start-BitsTransfer https://raw.githubusercontent.com/starfunkel....
Start-BitsTransfer https://raw.githubusercontent.com/starfunkel....
Start-BitsTransfer https://raw.githubusercontent.com/starfunkel....

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
. $dest
```

#### Clone the repo and do
```powershell
Copy-Item .\*.ps1 (Split-Path $PROFILE.CurrentUserAllHosts)
```
