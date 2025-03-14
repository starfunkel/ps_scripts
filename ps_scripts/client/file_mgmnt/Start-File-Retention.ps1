<#
.SYNOPSIS
File retention powershell script

.DESCRIPTION
This script search in $folderPath for files older than 3 month and deletes them.
 
.NOTES

This script is meant to run in an unanttended manner, but can also be run manually.

Integrate 2024 Rathnau

#>

$folderPath = ""
$retentiontime = (Get-Date).AddMonths(-3)

# Path to the log file
$logFilePath = "E:\PROAD_BackUps\Backup-Cleanup-Log.txt"

# Current date
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Redirect output to log file
Start-Transcript -Path $logFilePath -Append

# Log the start of the cleanup
Write-Host "Cleanup started at $currentTime"

# Get files older than 3 months in the specified folder
$filesToDelete = Get-ChildItem -Path $folderPath | Where-Object { $_.LastWriteTime -lt $retentiontime }

# Delete each file
foreach ($file in $filesToDelete) {
    Write-Host "Deleting $($file.FullName)"
    Remove-Item -Path $file.FullName -Force -Whatif
}

# Log the completion of the cleanup
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "Cleanup completed at $currentTime"

# Stop transcript to close log file
Stop-Transcript