Vmware
Get IP addresses of all the vms

Connect-VIServer $IP
Get-VM | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}
