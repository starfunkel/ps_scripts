## Get-AD-Object Information

- check extensionattributes

```powershell
# get ad-object extensionattr

Get-ADObject $usr -Properties * | select exten*

Get-ADReplicationAttributeMetadata -Object "CN" -Server |
Select-Object AttributeName, AttributeValue, LastOriginatingChangeTime, LastOriginatingChangeDirectoryServerInvocationId |
Out-GridView 
```
