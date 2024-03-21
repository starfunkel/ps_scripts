## Show a user's group memberships and the dates they were added to those groups

function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
      [String]$STRINGANME_TO_BE_APENND_TO_FUNCTION
      [String]username 
      [String]server
   )
}

$userobj  = Get-ADUser $username
Get-ADUser $userobj.DistinguishedName -Properties memberOf |
 Select-Object -ExpandProperty memberOf |
 ForEach-Object {
    Get-ADReplicationAttributeMetadata $_ -Server $server -ShowAllLinkedValues | 
      Where-Object {$_.AttributeName -eq 'member' -and 
      $_.AttributeValue -eq $userobj.DistinguishedName} |
      Select-Object FirstOriginatingCreateTime, Object, AttributeValue
    } |
    Sort-Object FirstOriginatingCreateTime -Descending |
    Out-GridView
