function get-4625 {
    $filter4625='<QueryList>
    <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4625) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
    </Query>
    <QueryList>'
    $LogonEvents = Get-WinEvent -FilterXml $filter4625
    $LogonEvents | sort -Property TimeCreated 

}

$filter='<QueryList>
 <Query Id="0" Path="Security">
 <Select Path="Security">*[System[(EventID=4625) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
 </Query>
 </QueryList>'
 $LogonEvents = Get-WinEvent -FilterXml $filter
 $LogonEvents | sort -Property TimeCreated | Select-Object -First 1