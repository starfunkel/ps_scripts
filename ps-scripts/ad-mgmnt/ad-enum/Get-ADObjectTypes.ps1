function Get-ADObjectTypes {

$ObjectTypeGUID = @{}

$GetADObjectParameter=@{
    SearchBase=(Get-ADRootDSE).SchemaNamingContext
    LDAPFilter='(SchemaIDGUID=*)'
    Properties=@("Name", "SchemaIDGUID")
}

$SchGUID=Get-ADObject @GetADObjectParameter
    Foreach ($SchemaItem in $SchGUID){
    $ObjectTypeGUID.Add([GUID]$SchemaItem.SchemaIDGUID,$SchemaItem.Name)
}

$ADObjExtPar=@{
    SearchBase="CN=Extended-Rights,$((Get-ADRootDSE).ConfigurationNamingContext)"
    LDAPFilter='(ObjectClass=ControlAccessRight)'
    Properties=@("Name", "RightsGUID")
}

$SchExtGUID=Get-ADObject @ADObjExtPar
    ForEach($SchExtItem in $SchExtGUID){
    $ObjectTypeGUID.Add([GUID]$SchExtItem.RightsGUID,$SchExtItem.Name)
}

$ObjectTypeGUID | Format-Table -AutoSize

}