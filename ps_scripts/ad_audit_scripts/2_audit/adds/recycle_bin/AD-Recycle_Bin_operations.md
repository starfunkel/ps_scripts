###### Check contents
```powershell
Get-ADObject -Filter 'isDeleted -eq $True -and -not (isRecycled -eq $True) -and name -ne "Deleted Objects"' -IncludeDeletedObjects
```
###### Restore
```powershell
$object=""
get-adobject -filter 'name -like "Santa*"' -IncludeDeletedObjects |
 Restore-ADObject –TargetPath "OU,CN..." -passthru
```
###### Get deleted obkects and sort by modificationdate (this )
```powershell
 Get-ADObject -ldapFilter:"(msDS-LastKnownRDN=*)"  -IncludeDeletedObjects -Properties * | select msDS-LastKnownRDN,Deleted,modifyTimeStamp |sort modifyTimeStamp -Descending|  ft -AutoSize
```
###### Get Specific RDN (This attribute holds the original relative distinguished name (RDN) of a deleted object)
```powershell
Get-ADObject -ldapFilter:"(msDS-LastKnownRDN=$RDN)"  -IncludeDeletedObjects -Properties * | select msDS-LastKnownRDN,Deleted,modifyTimeStamp |sort modifyTimeStamp -Descending|  ft -AutoSize
```
###### Get RDn memebrships
```powershell
Get-ADObject -ldapFilter:"(msDS-LastKnownRDN=$RDN)"  -IncludeDeletedObjects -Properties * | select memberof -ExpandProperty memberof
```