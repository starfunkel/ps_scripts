function Get-Mac
{
    <#
  .Synopsis
    Search DHCP for the specified MAC address
  .DESCRIPTION
    This function enumerates through each scope in either a defined site or the current site and displays any DHCP lease or reservation that matches the MAC address specified 
  .EXAMPLE 
    Get-Mac -Mac 000000000000 
  .EXAMPLE
    Get-Mac -Mac 0000 -DhcpSite CONTOSO 
  .EXAMPLE
    Get-Mac -Mac 000000 -DhcpSite *
    #>

    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Mac,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$false,
                   Position=1)]
        $DhcpSite
    )

    Begin
    {
        $MacAddress = $Mac -replace '..(?!$)', '$&-:'
        $Leases = @()
        $DhcpServers = Get-DhcpServerInDC | Where-Object {$_.DnsName -like "$DhcpSite*"}
    }
    Process
    {
        $i = 1
        foreach ($DhcpServer in $DhcpServers.DnsName)
        {
            Write-Progress -Id 1 -Activity "Gathering DHCP Scopes" -Status "from $DhcpServer" -PercentComplete ($i++ / $DhcpServers.Count * 100)
            $DhcpScopes = Get-DhcpServerv4Scope -ComputerName $DhcpServer
            
            $j = 1
            foreach ($DhcpScope in $DhcpScopes.ScopeId)
            {
                Write-Progress -ParentId 1 -Activity "Gathering DHCP Leases" -Status "from $DhcpScope" -PercentComplete ($j++ / $DhcpScopes.Count * 100)
                $Leases += Get-DhcpServerv4Lease -ComputerName $DhcpServer -ScopeId $DhcpScope
            }
        }
    }
    End
    {
        Write-Host "Found MAC Address $MacAddress in the following locations:"
        $Leases | Where-Object {$_.ClientId -Match "$MacAddress"}
    }
}