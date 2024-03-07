function get-certificate  {
[CmdletBinding()]
param(
   [Parameter(Mandatory=$true)]
   [String]$Server
)

crip.exe print -u=https://$Server

}