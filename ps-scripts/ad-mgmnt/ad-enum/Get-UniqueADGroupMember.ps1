<# Count unique AD group members#>

# To Do: $groups variable call when executing ps1

$groups = $A_group, $B_Group 
$gm     = @() 

foreach ($group in $groups){
    $gm += Get-ADGroupMember $group -Recursive|
           Where-Object {$_.objectclass -eq 'user'}
} 

Write-Output "Total: $(($gm.samaccountname | select-object -Unique).count)"
Write-Output $gm | Select-Object name,distinguishedName,SID