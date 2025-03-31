<#
.SYNOPSIS
    This script srearches every OU for users whoich have the flag password never expoires set to true. It sets this attribute 
    to false and exports the changed users to a cvs file
#>

# Specify the CSV export path
$csvPath = "C:\Admin\touched_ad_accounts_export.csv"

# Create an empty array to store the changed user accounts
$changedUsers = @()

# Get all OUs starting with "Hinterseer - Bereich"
$targetOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"'

# Iterate through each OU and update the user objects
foreach ($ou in $targetOUs) {
    # Get all users in the current OU with "PasswordNeverExpires" flag set to true
    $users = Get-ADUser -Filter {PasswordNeverExpires -eq $true} -SearchBase $ou.DistinguishedName -Properties PasswordNeverExpires

    # Iterate through each user
    foreach ($user in $users) {
        # Display the current state of the "PasswordNeverExpires" flag
        Write-Host "Current state of 'PasswordNeverExpires' flag for user '$($user.UserPrincipalName)': $($user.PasswordNeverExpires)"

        # Set the "PasswordNeverExpires" flag to false
        $user | Set-ADUser -PasswordNeverExpires:$false

        # Display the updated state of the "PasswordNeverExpires" flag
        Write-Host "Updated state of 'PasswordNeverExpires' flag for user '$($user.UserPrincipalName)': $($user.PasswordNeverExpires)"

        # Add the changed user to the array
        $changedUsers += $user
    }
}

# Export the changed user accounts to a CSV file
$changedUsers | Select-Object SamAccountName, UserPrincipalName, PasswordNeverExpires |
    Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "Changed user accounts exported to: $csvPath"