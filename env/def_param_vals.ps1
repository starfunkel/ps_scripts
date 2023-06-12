$PSDefaultParameterValues['Get-ADUser:Properties'] = @(
    'DisplayName',
    'Description',
    'EmailAddress',
    'LockedOut',
    'telephoneNumber',
    'PasswordLastSet',
    'PasswordExpired',
    'LastLogonDate',
    'ProxyAddresses',
    'Title',
    'wwWHomePage'
)

$PSDefaultParameterValues['Export-Csv:NoTypeInformation'] = $true

<#
-Encoding Default
-Force 
#>