## Get-AD-Object Information

function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
      [String]$STRINGANME_TO_BE_APENND_TO_FUNCTION
   )
}

- check extensionattributes

```powershell
# get ad-object extensionattr

Get-ADObject $usr -Properties * | select exten*

Get-ADReplicationAttributeMetadata -Object "CN" -Server |
Select-Object AttributeName, AttributeValue, LastOriginatingChangeTime, LastOriginatingChangeDirectoryServerInvocationId |
Out-GridView 
```
