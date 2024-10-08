### Powershell Funcions

### Compute file hashes 
function md5            { Get-FileHash -Algorithm MD5 $args }
function sha1           { Get-FileHash -Algorithm SHA1 $args }
function sha256         { Get-FileHash -Algorithm SHA256 $args }

### Unix like commands
function pwd            { Get-Location }
function ll             { Get-Childitem | Sort-Object -Property LastWriteTime }
function help           { get-help $args[0] | out-host -paging }
function man            { get-help $args[0] -Full | out-host -paging }
function cat            { get-content $args[0] }
function less           { get-content $args[0] | out-host -paging }
function tail           { get-content $args[0] -Wait -tail 25}
function find           { Get-Childitem -Filter $args[0] -Recurse -File | out-host -paging }
function sudo           { Start-Process -verb RunAs $args[0] }
function hist           { Get-Content (Get-PSReadlineOption).HistorySavePath | more }

##### Search hist with params
# function shist          { Get-History | Where-Object {$_.CommandLine -like "$args[0]"}}

function fg              {Remove-Item -Path (Get-PSReadlineOption).HistorySavePath -Force
                            Clear-Host
                            pwsh.exe
                        }
function touch          { New-Item $args[0] }
function zip            { Compress-Archive -Path $args[0] -DestinationPath $args[1] }
function unzip          { Expand-Archive -LiteralPath $args[0] -DestinationPath $args[1] }

function uname          { $PROPERTIES = 'Caption', 'CSName', 'Version', 'BuildType', 'OSArchitecture'; Get-CimInstance Win32_OperatingSystem | 
                            Select-Object $PROPERTIES |
                            Format-Table -AutoSize 
                        }

### Custom functions
function pong           { Test-Connection $args[0] | Format-Table -Autosize }
function imp            { Import-Module -Name $args[0] }

### Windows Shortcuts
function credman        { rundll32 keymgr.dll, KRShowKeyMgr }
function boottime       {(Get-CimInstance Win32_OperatingSystem).LastBootUpTime}
function userprofiles   { rundll32 sysdm.cpl,EditUserProfiles }
function mycreds        { Get-ChildItem -path cert:\LocalMachine\My }
function sessions        {gwmi Win32_LogonSession |
                             Foreach-Object { $one = $_ ; $one.GetRelated('Win32_Account') |
                                Select-Object Domain, Name, SID, 
                                    @{ n = 'LogonSessionHEX' ; e = { '0x{0:X}' -f ([int] $one.LogonId) } }, 
                                    @{ n = 'LogonSessionDEC' ; e = { $one.LogonId } } , 
                                    @{ n = 'LogonType' ; e = { $one.LogonType } } } 
                                }
function bcat           { Get-Content $args[0] -Raw | Write-CodeBlock -SyntaxHighlight -ShowLineNumbers }
function w              { 
                          Write-Host
                          Write-Host SID:
                          [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
                          Write-Host ---------------------------------------------------------------------------------
                          Write-Host Name:
                          [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
                          Write-Host ---------------------------------------------------------------------------------
                          Write-Host Sessions:
                          quser
                          Write-Host ---------------------------------------------------------------------------------
                          qwinsta
                          Write-Host ---------------------------------------------------------------------------------
                          Write-Host
                        }