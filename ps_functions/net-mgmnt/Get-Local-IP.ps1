function ip {
    Process {
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
 }