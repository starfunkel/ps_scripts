function Get-Object-ACL {
    [CmdletBinding()]
    [Alias("gacl")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$name
    )

(Get-ADOrganizationalUnit -Filter 'OUName -eq $name').DistinguishedName
(get-acl "AD:$((Get-ADOrganizationalUnit -Identity $OUName).distinguishedname)").access |
where-object {($_.ActiveDirectoryRights -eq "GenericAll") -or ($_.ActiveDirectoryRights -eq  "GenericRead") -or ($_.ActiveDirectoryRights -eq "GenericWrite")} |
select-object IdentityReference,AccessControlType,ActiveDirectoryRights
}