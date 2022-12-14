function ConvertFrom-X500 {

    [cmdletbinding()]
    param (
        [Parameter(Position=0,Mandatory)]
        [Alias("x500")]
        [string]$IMCEAEX
    )
    $IMCEAEX = ($IMCEAEX).Replace("IMCEAEX-", "")
    $IMCEAEX = ($IMCEAEX).Replace("_", "/")
    $IMCEAEX = ($IMCEAEX).Replace("+20", " ")
    $IMCEAEX = ($IMCEAEX).Replace("+28", "(")
    $IMCEAEX = ($IMCEAEX).Replace("+29", ")")
    $IMCEAEX = ($IMCEAEX).Replace("+2E", ".")

    Write-Host ""
    Write-Host "- Converted to X500" -ForegroundColor Yellow
    "X500:$($IMCEAEX)" | 
    clip
    Write-Host "- Copied to Clipboard" -ForegroundColor Yellow
    Write-Host ""
    Return "X500:$($IMCEAEX)"
}