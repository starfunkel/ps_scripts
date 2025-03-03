<#
.SYNOPSIS
    Get Empty OUs
#>
fucntion Get-Empty-OUs {
Get-ADOrganizationalUnit -filter * -Properties Description -PipelineVariable pv |
Select-Object DistinguishedName,Name,Description,
@{Name="Children"; Expression = {
Get-ADObject -filter * -SearchBase $pv.distinguishedname |
Where-Object { $_.objectclass -ne "organizationalunit"} |
Measure-Object | Select-Object -ExpandProperty Count }} |
Where-Object {$_.children -eq 0}
}