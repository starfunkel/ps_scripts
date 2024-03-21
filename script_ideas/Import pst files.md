<#Source:
https://adamtheautomator.com/import-pst-to-outlook/
#>

function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
      [String]$PSTPath   
   )
}

Add-type -assembly "Microsoft.Office.Interop.Outlook"
$outlook = new-object -comobject outlook.application
$namespace = $outlook.GetNameSpace("MAPI")

Get-ChildItem $PSTPath -Filter *.pst |
ForEach-Object {
    $namespace.AddStore($_.FullName)
}
