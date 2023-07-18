Get-ADComputer -Filter 'operatingsystem -like "*Windows Server*"' -Properties  Name,Operatingsystem, OperatingSystemVersion,IPv4Address |
Select-Object -Property Name, OperatingSystemVersion, IPv4Address #|
# Group-object OperatingSystemVersion| Select-Object Count,Name |
Sort-Object -Descending OperatingSystemVersion
