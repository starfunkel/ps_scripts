$users = Get-ADUser -Filter 'adminCount -eq 1' -Properties adminCount
foreach ($user in $users) {
        $user | Set-ADObject -Clear adminCount -whatif
}