### Extract AD Domain Controller Registry SYSTEM Hive and ntds.dit

##### The driveby method with sauce and all the hits

- One can use different approaches to extract the needed data. 
- Important is that one starts a Powershell session as domain admin, or a user which has replication rights on the domain.

```powershell
# Set location
$output = [Environment]::CurrentDirectory = Get-Location
# ifm method
ntdsutil "activate instance ntds" "ifm" "create full $output\pw_audit\" q q

# vss method
vssadmin create shadow /for=C:

copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\NTDS\NTDS.dit $output\pw_audit\
copy \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\Windows\System32\config\SYSTEM $output\pw_audit\
```