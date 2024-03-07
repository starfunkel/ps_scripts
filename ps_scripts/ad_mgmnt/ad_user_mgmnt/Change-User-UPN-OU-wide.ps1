# OU as searchbase
$ouDN = ""

# populate $users with all AD-users in search base
$users = Get-ADUser -Filter * -SearchBase $ouDN

foreach ($user in $users) {
    # Error handling - discard ad-user without email adress
    if ($user.EmailAddress) {
        $newUPN = $user.EmailAddress

        # Error handling - skip if already $newupn = $user.EmailAddress
        if ($user.UserPrincipalName -ne $newUPN) {

            Set-ADUser -Identity $user -UserPrincipalName $newUPN
            Write-Host "Updated UPN for $($user.SamAccountName) to $newUPN" -ForegroundColor Green
        }
    }
}