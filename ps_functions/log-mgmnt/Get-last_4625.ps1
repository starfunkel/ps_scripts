function get-4625 {

    $FilterXML = '<QueryList>
    <Query Id="0" Path="ForwardedEvents">
    <Select Path="ForwardedEvents">*[System[(EventID=4771 or EventID=4625 or EventID=4768) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
    </Query>
    </QueryList>'
    $LogonEvents = Get-WinEvent -FilterXml $FilterXML
    $LogonEvents | sort -Property TimeCreated 

}