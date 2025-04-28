# Define base file path
$basePath = "$PSScriptRoot\SPN"

$userOutputFile = "$basePath`_User.csv"
$computerOutputFile = "$basePath`_Computer.csv"

# Get SPNs for users
$usersSPNs = Get-ADUser -Filter {ServicePrincipalName -like "*"} -Property ServicePrincipalName | 
    Select-Object SamAccountName, ServicePrincipalName

# Get SPNs for computers
$computersSPNs = Get-ADComputer -Filter {ServicePrincipalName -like "*"} -Property ServicePrincipalName | 
    Select-Object SamAccountName, ServicePrincipalName

# Export user SPNs to CSV
$usersSPNs | Export-Csv -Path $userOutputFile -NoTypeInformation

# Export computer SPNs to CSV 
$computersSPNs | Export-Csv -Path $computerOutputFile -NoTypeInformation