Get-ADComputer -Filter 'operatingsystem -like "*Windows 10*"' -Properties  Name, OperatingSystemVersion |
Where-Object {$_.OperatingSystemVersion -like "*1836*"} |
Select-Object -ExpandProperty Name
