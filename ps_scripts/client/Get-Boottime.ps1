Get-EventLog -LogName System |Where-Object {$_.EventID -in (6005,6006,6008,6009,1074,1076)} |
Format-Table TimeGenerated,EventId,Message -AutoSize -wrap
