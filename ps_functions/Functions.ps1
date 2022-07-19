<#
  .SYNOPSIS

  .DESCRIPTION

  .PARAMETER InputPath

  .PARAMETER OutputPath

  .INPUTS

  .OUTPUTS

  .EXAMPLE
#>

### Funcions

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

function uname      { $PROPERTIES = 'Caption', 'CSName', 'Version', 'BuildType', 'OSArchitecture'; Get-CimInstance Win32_OperatingSystem | 
                        Select-Object $PROPERTIES |
                         Format-Table -AutoSize 
                    }
                    
function history    { get-history -Count 20 }

function touch      { New-Item $args[0] }

### Windows Terminal as Admin
function aterm      { Start-Process wt.exe -Verb runAs }

### Custom functions
function pong       { Test-Connection $args[0] | Format-Table -Autosize } 
function imp        { Import-Module $args[0] }

### Scripts
function mtr        { C:\support\code\ps-scripts\mtr.ps1 $args[0] }
function gpa        { C:\support\code\ps-scripts\GPAnalyser.ps1 }

### Tools
function lgpo       { C:\support\runners\lgpo.exe }

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

function py          { & "C:\Program Files\WindowsApps\PythonSoftwareFoundation.Python.3.10_3.10.1520.0_x64__qbz5n2kfra8p0\python3.10.exe" }

function c          { Get-Cowsay "$args" } # Install-Module -Name CowsaySharp
function t          { Get-Cowsay -cowfile tux "$args" }

### Directory jumpers

function dl         { Set-Location "C:\Users\rathnau\Downloads" }
function co         { Set-Location "C:\support\code"}
function da         { Set-Location D:\ }
