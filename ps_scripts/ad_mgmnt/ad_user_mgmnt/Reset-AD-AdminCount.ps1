$users = Get-ADUser -Filter 'adminCount -eq 1' -Properties adminCount
foreach ($user in $users) {
        Set-Aduser -Identity $user -Replace @{adminCount=0} -whatif
}

