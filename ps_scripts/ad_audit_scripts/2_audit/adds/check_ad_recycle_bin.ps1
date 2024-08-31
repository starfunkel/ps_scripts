Get-ADObject -Filter 'isDeleted -eq $True -and -not (isRecycled -eq $True) -and name -ne "Deleted Objects"' -IncludeDeletedObjects 

# restore

<#
$object=""
get-adobject -filter 'name -like "Santa*"' -IncludeDeletedObjects |
 Restore-ADObject –TargetPath "OU,CN..." -passthru
 #>