Get-ADUser -Filter 'adminCount -eq 1' -Properties adminCount | select name
#Set-ADUser -Identity $SAAMAccountname administrator -Replace @{adminCount=0}