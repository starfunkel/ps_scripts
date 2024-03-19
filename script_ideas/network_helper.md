Network

Get-DnsClientServerAddress | Select-Object -ExpandProperty Serveraddresses
Process to Network Monitoring

TCP

Get-Process -Id (Get-NetTCPConnection -LocalPort YourPortNumberHere).OwningProcess`

UDP

`Get-Process -Id (Get-NetUDPEndpoint -LocalPort YourPortNumberHere).OwningProcess`

cmd

`C:\> netstat -a -b`
