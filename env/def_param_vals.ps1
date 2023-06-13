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
    'Title'
)

$PSDefaultParameterValues['Export-Csv:NoTypeInformation'] = @(
    '$true',
    'Encoding Default'