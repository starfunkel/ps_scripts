function ip         {
    [CmdletBinding()]
    param(
        $Filter,
        $OrganizationalUnit
    )
    $env:externalip = ( # gets external $ internal IPs of Localhost
        Invoke-WebRequest "ifconfig.me/ip").Content;
        $LOCALIPADRESS = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
        Write-host ""
        Write-Output "External IP:"; 
        $env:externalip;
        Write-host ""
        Write-Host "Internal IP:"
        $LOCALIPADRESS
        Write-host ""
  }

function get-WifiInfo   {
    $logs=@()
    $date=Get-Date
    $cmd=netsh wlan show networks mode=bssid
    $n=$cmd.Count
    For($i=0;$i -lt $n;$i++)
    {
        If($cmd[$i] -Match '^SSID[^:]+:.(.*)$')
            {
            $ssid=$Matches[1]
            $i++
            $bool=$cmd[$i] -Match 'Type[^:]+:.(.+)$'
            $Type=$Matches[1]
            $i++
            $bool=$cmd[$i] -Match 'Authentication[^:]+:.(.+)$'
            $authent=$Matches[1]
            $i++
            $bool=$cmd[$i] -Match 'Cipher[^:]+:.(.+)$'
            $chiffrement=$Matches[1]
            $i++
            While($cmd[$i] -Match 'BSSID[^:]+:.(.+)$')
            {   
                $bssid=$Matches[1]
                $i++
                $bool=$cmd[$i] -Match 'Signal[^:]+:.(.+)$'
                $signal=$Matches[1]
                $i++
                $bool=$cmd[$i] -Match 'Type[^:]+:.(.+)$'
                $radio=$Matches[1]
                $i++
                $bool=$cmd[$i] -Match 'Channel[^:]+:.(.+)$'
                $Channel=$Matches[1]
                $i=$i+2
                $logs+=[PSCustomObject]@{date=$date;ssid=$ssid;Authentication=$authent;Cipher=$chiffrement;bssid=$bssid;signal=$signal;radio=$radio;Channel=$Channel}
            }
        }
    }
    $cmd=$null
    $logs |
     Out-GridView -Title 'Scan Wifi Script'
}