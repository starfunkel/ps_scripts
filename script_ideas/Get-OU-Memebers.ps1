Get a list of users from OU

$OU = 'OU=SALES,DC=SHELLPRO,DC=LOCAL'
# Use Get-AdUser to search within organizational unit to get users name
Get-ADUser -Filter * -SearchBase $OU |
 Select-object DistinguishedName,Name,UserPrincipalName 

Get all users in ou and sub ou

$OU = 'OU=SHELLUSERS,DC=SHELLPRO,DC=LOCAL'
Get-ADUser -Filter * -SearchBase $OU -SearchScope Subtree |
 Select-object DistinguishedName,Name,UserPrincipalName

Get AdUsers list from Multiple Organizational Units

# Specify multiple OU 
$OU = 'OU=SALES,DC=SHELLPRO,DC=LOCAL','OU=SHELLUSERS,DC=SHELLPRO,DC=LOCAL'
# Use foreach to iterate over multiple ou to get aduser
$OU |
 ForEach-Object {Get-AdUser -filter {enabled -eq $true} -searchbase $_ -properties canonicalname,userprincipalname } |
  Select-object SamAccountName,canonicalname,userprincipalname