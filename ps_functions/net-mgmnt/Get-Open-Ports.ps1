# Adapted from https://superuser.com/a/1534911
Function Test-CommonTCPPorts {
    Param($address, $timeout=1000)
    $ports = @(21,22,23,25,53,80,81,110,111,113,135,139,143,179,199,443,445,465,514,548,554,587,993,995,1025,1026,1720,1723,2000,3306,3389,5060,5900,6001,8000,8080,8443,8888,10000,32768)
    ForEach ($port in $ports) {
        $socket=New-Object System.Net.Sockets.TcpClient
        try {
            $result=$socket.BeginConnect($address, $port, $null, $null)
            if (!$result.AsyncWaitHandle.WaitOne($timeout, $False)) {
                throw [System.Exception]::new("Connection Timeout")
            }
            "$port - open"
        } catch {
            "$port - closed"
        }
        finally {
            $socket.Close()
        }
    }
}
