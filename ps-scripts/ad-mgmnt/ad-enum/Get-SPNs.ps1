function Get-SPNS {
Get-ADUser -filter * -prop * |
where-object {$_.serviceprincipalname -ne $null} |
select name, serviceprincipalname -ExpandProperty serviceprincipalname
}