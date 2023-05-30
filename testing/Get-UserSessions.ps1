# Query user session information using Get-WmiObject
# $sessionInfo = Get-WmiObject -Class Win32_LogonSession -Filter "LogonType='Interactive' OR LogonType='RemoteInteractive'"

# # Display session information
# foreach ($session in $sessionInfo) {
#     $user = $session.GetRelated("Win32_Account") | Select-Object -ExpandProperty Name
#     $logonTime = [Management.ManagementDateTimeConverter]::ToDateTime($session.StartTime)
#     $sessionType = $session.LogonType

#     Write-Output "User: $user"
#     Write-Output "Logon Time: $logonTime"
#     Write-Output "Session Type: $sessionType"
#     Write-Output "-------------------------"
# }