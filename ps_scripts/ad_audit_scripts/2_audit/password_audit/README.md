## AD password Audit

### Prerequisities

#### Install Winget
```powershell
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."
```
[Link](https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget)

#### Install .NET SDK
```powershell
winget install Microsoft.DotNet.SDK.9
```
[Link](https://learn.microsoft.com/en-us/dotnet/core/install/windows?WT.mc_id=dotnet-35129-website#install-with-windows-package-manager-winget)

#### Install PwnedPasswordsDownloader
```powershell
dotnet tool install --global haveibeenpwned-downloader
```
[Link](https://github.com/HaveIBeenPwned/PwnedPasswordsDownloader)

##### Download HaveIBeenPwned Password NT hashes
- In decembre 2024 the downloaded data exceeds 38 GB. So make sure there is enough space on disk.
```powershell
haveibeenpwned-downloader.exe -n -s true -p 256 # if download fails reduce parallelism (-p) 
```

#### Install DSInternals
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name DSInternals -Force
Import-Module -Name DSInternals -Force
```

### Audit
#### The "On-the-fly" audit
- This is used to get a first impression of the current state of the company's password hygiene
```powershell
# # Output stdout
$Srv =
Get-ADReplAccount -All -Server $Srv

# Get-ADReplAccount pipes it's stdout to Test-PasswordQuality and among other things performs a basic 
# hash compare (diff) operation. Stdout gives hints on certain security misconfigurations.
$Srv =
$audit_file = ad_hashes.txt
$output_directory = [Environment]::CurrentDirectory = Get-Location

Get-ADReplAccount -All -Server $Srv |
Test-PasswordQuality |
Out-File $output_directory\$audit_file
```

#### The "I want them data, but with these user accounts and the hashes only"

```powershell
$output = [Environment]::CurrentDirectory = Get-Location
Get-ADReplAccount -All -Server ii-dc22-01 |
Format-Custom -View HashCatNT |
Out-File $output\user_and_hashes.txt -Encoding ascii
```

#### Compare the hashes and get usernames with pwned passwords
```powershell
# Downloaded HIBP hashes are mandantory!
$hashes = "user_and_hashes.txt"
$hibp_hashes = "pwnedpasswords.txt"
$outputfile = "pw_audit.csv"

# Source the script
. ./Match-Adhashes.ps1

# Do the magic
Match-Adhashes.ps1 -ADNTHashes $hashes -HashDictionary $hibp_hashes | Out-File $outputfile 

# Open another powershell instance and see he progress (set directory accordingly)
Get-Content $outputfile -wait
```


### Aftercare / Cleanup the mess
```powershell
# Uninstall DSinternals
Uninstall-Module DsInternals
 
# Manually uninstall DSInternalsmodule
  
# Search these locations for the module directory
(ls Env:\PSModulePath).value -split ';'
 
# Clean the Powershell history from prying eyes
 
# Manual approach | edit stuff until it please you!
$console_history = (Get-PSReadlineOption).HistorySavePath
notepad $console_history
 
# Full deletion
Remove-Item (Get-PSReadlineOption).HistorySavePath; Clear-History
 
# Full Wipe with sysinternals sdelte (no artifacts are left behind
# PSEventlogging might be logging to eventlog --> Caution!! )
$console_history = (Get-PSReadlineOption).HistorySavePath
sdelete.exe -c -z -p 16  $console_history
```
