function Get-DHCPLease  {Get-DhcpServerv4Scope |
 foreach-object {Get-DhcpServerv4Lease -computername $env:computername -allleases -ScopeId ($_.ScopeId)}}