# File handling tricks
## Search occurance of string in given file

function search {
    [CmdletBinding()]
    [Alias("srch")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$str
       [String]$file
    )


```powershell
#$str=""
$out = Select-String -Path ($file) -Pattern ([regex]::Escape($str)) -AllMatches
$out.Matches.Count
}