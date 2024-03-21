function $FUNCION_NAME{
   [CmdletBinding()]
   [Alias("$ALIASNAME")]
   param(
      [Parameter(Mandatory=$true)]
      [String]$STRINGANME_TO_BE_APENND_TO_FUNCTION
   )
}

Get-DnsClientServerAddress | Select-Object -ExpandProperty Serveraddresses
Process to Network Monitoring
Write-Host "---------------------------------------------------------"
Write-Host ""
Get-Process -Id (Get-NetTCPConnection -LocalPort YourPortNumberHere).OwningProcess
Write-Host "---------------------------------------------------------"
Write-Host ""
Get-Process -Id (Get-NetUDPEndpoint -LocalPort YourPortNumberHere).OwningProcess
