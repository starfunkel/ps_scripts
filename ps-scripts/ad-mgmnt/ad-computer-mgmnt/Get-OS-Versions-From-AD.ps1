# to do
# add more versions

Get-ADComputer -Filter 'operatingsystem -like "*Windows 10*"' -Properties  Name, OperatingSystemVersion |
Select-Object -Property Name, OperatingSystemVersion |
Group-Object {
switch -regex ($_.OperatingSystemVersion) {
"19042" {"20.09";continue}
"19041" {"20.03";continue}
"18363" {"19.09";continue}
"18362" {"19.03";continue}
Default {"OLD"}
}
}| Select-Object Count,Name |
Sort-Object -Property @{Expression = "Name"; Descending = $false}

<#
(22H2) 22621
(21H2) 22000
(21H2) 19044
(21H1) 19043
(20H2) 19042
(20.04) 19041
(19.09) 18363
(19.03) 18362
(18.09) 17763
(18.03) 17134
(17.09) 16299
(17.03) 15063
(16.07) 14393
(15.11) 10586
10240
8  8.1 (Update 1) 6.3.9600
8.1 6.3.9200
8 6.2.9200
7  7 SP1 6.1.7601
7 6.1.7600
Vista  Vista SP2 6.0.6002
Vista SP1 6.0.6001
Vista 6.0.6000
XP  XP2 5.1.26003



#>