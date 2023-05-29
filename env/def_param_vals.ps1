$PSDefaultParameterValues['Get-ADUser:Properties'] = @(
    'DisplayName',
    'Description',
    'EmailAddress',
    'LockedOut',
    'Manager',
    'MobilePhone',
    'telephoneNumber',
    'PasswordLastSet',
    'PasswordExpired',
    'ProxyAddresses',
    'Title',
    'wwWHomePage'
)

# $PSDefaultParameterValues['Export-Csv:NoTypeInformation'] = $true