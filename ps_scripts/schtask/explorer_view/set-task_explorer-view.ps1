# set Windows Explorer View options
$taskName = "Set Cras Explorer View"

# task action
$taskAction= New-ScheduledTaskAction `
    -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' `
    -Argument '-nop -executionpolicy bypass -file "set-explorer-view.ps1"'

# task Time and trigger
$taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30)

# Describe the scheduled task.
$description = "Set the Windows Explorer view every 30 minutes to full details"

# Register task
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
