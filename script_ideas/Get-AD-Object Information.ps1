## Get-AD-Object Information

function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
   )
}

Get-ADObject $usr -Properties * | select exten*

Get-ADReplicationAttributeMetadata -Object "CN" -Server |
Select-Object AttributeName, AttributeValue, LastOriginatingChangeTime, LastOriginatingChangeDirectoryServerInvocationId |
Out-GridView 

