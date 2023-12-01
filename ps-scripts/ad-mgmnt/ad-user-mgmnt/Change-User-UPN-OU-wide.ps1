# Change UPN on Users in OU and sub OUs
# Prompt for Organizational Unit (OU)
$ou = Read-Host "Enter the Organizational Unit (OU)"

# Prompt for User Principal Name (UPN) to find
$currentUpn = Read-Host "Enter the current User Principal Name (UPN) to find"

# Search for users with the specified UPN
$users = Get-ADUser -Filter {UserPrincipalName -eq $currentUpn} -SearchBase $ou -SearchScope Subtree

# Display found UPNs
Write-Host "Found UPNs:"
$users | ForEach-Object { $_.UserPrincipalName }

# Ask for confirmation to proceed with the change
$confirmation = Read-Host "Do you want to change the UPN for the above users? (Y/N)"
if ($confirmation -eq 'Y') {
    # Prompt for the new UPN
    $newUpn = Read-Host "Enter the new User Principal Name (UPN)"

    # Update UPN for all users
    foreach ($user in $users) {
        Set-ADUser -Identity $user -UserPrincipalName $newUpn
        Write-Host "Updated UPN for $($user.SamAccountName)"
    }

    Write-Host "UPN update completed."
} else {
    Write-Host "UPN update aborted."
}