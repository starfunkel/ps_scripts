$time=Read-Host "How many days do you want to go back? (Press Q to escape )"
Get-ADUser -Filter {enabled -eq $false} -Properties LastLogonDate,enabled |
Where-Object {$_.lastlogondate -ne $null -and $_.lastlogondate -le ((get-date).adddays(-$time))} |
Sort-Object -Property LastLogonDate -Descending |
Format-Table Name,SamAccountName,LastLogonDate,enabled -AutoSize 