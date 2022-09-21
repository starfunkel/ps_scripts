### Powershell Funcions

### Compute file hashes 
function md5        { Get-FileHash -Algorithm MD5 $args }
function sha1       { Get-FileHash -Algorithm SHA1 $args }
function sha256     { Get-FileHash -Algorithm SHA256 $args }

### Bash like commands
function pwd        { Get-Location }
function ll         { Get-Childitem | Sort-Object -Property LastWriteTime }
function help       { get-help $args[0] | out-host -paging }
function man        { get-help $args[0] -Full | out-host -paging }
function cat        { get-content $args[0] }
function less       { get-content $args[0] | out-host -paging }
function find       { Get-Childitem -Filter $args[0] -Recurse -File | out-host -paging }
function sudo       {Start-Process -verb RunAs wt}
function history    { get-history }
function touch      { New-Item $args[0] }
function zip        { Compress-Archive -Path $args[0] -DestinationPath $args[1] }
function unzip      { Expand-Archive -LiteralPath $args[0] -DestinationPath $args[1] }

function uname      { $PROPERTIES = 'Caption', 'CSName', 'Version', 'BuildType', 'OSArchitecture'; Get-CimInstance Win32_OperatingSystem | 
                        Select-Object $PROPERTIES |
                        Format-Table -AutoSize 
                    }

### Custom functions
function pong       { Test-Connection $args[0] | Format-Table -Autosize }

function imp        { Import-Module $args[0] }

### custom app shortcuts
function fla        { & "$env:ProgramFiles\flameshot\bin\flameshot.exe" }
function mmc        { & "C:\Windows\SysWOW64\mmc.exe" }
function cmmc       { & "C:\support\code\configs\cmmc.msc" }

### Firefox
function ffd        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p default }
function fft        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p Testing }
function ffp        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p }

### Reload Powershell Profile
function rel        { & powershell}

function ip         { $env:externalip = ( # gets external $ internal IPs of Localhost
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

### cowsay stuff
function cow        { Get-Cowsay "$args" } # Install-Module -Name CowsaySharp
function tux        { Get-Cowsay -cowfile tux "$args" }
