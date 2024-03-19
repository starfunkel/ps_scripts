# Powershell CMDletBinding Buidling

```powershell
function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
      [String]$STRINGANME_TO_BE_APENND_TO_FUNCTION
   )
}
```
moved to wiki