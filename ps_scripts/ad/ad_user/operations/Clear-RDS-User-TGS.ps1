Get-WmiObject Win32_LogonSession |
Where-Object {$_.AuthenticationPackage -ne 'NTLM'} |
ForEach-Object {klist.exe purge -li ([Convert]::ToString($_.LogonId, 16))}
