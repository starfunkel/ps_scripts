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
<<<<<<< HEAD
function sudo       { Start-Process -verb RunAs wt }
function su         { Start-Process -FilePath powershell.exe -ArgumentList[0] }
=======
function sudo       { Start-Process -verb RunAs powershell.exe }
>>>>>>> 8b445618ded4f5c22acbb59210a1b440324a2e3b
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
