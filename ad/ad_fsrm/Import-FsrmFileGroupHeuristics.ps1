<#
.SYNOPSIS
    Brief description of what the script does.

.DESCRIPTION
    Detailed explanation of the script's functionality.

.PARAMETER <ParameterName>
    Description of the parameter (if applicable).

.EXAMPLE
    Example usage of the script.

.NOTES
    Additional notes, author, version, etc.

#>

$importFile = "$PSScriptRoot\fsrm_anti_ransomware.txt"
$fsrmGroupName = "Anti Ransomware Group"

$extensions = Get-Content $importFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

if (Get-FsrmFileGroup -Name $fsrmGroupName -ErrorAction SilentlyContinue) {
    # Update existing group
    Set-FsrmFileGroup -Name $fsrmGroupName -IncludePattern $extensions
    Write-Host "Updated FSRM group: $fsrmGroupName with new blocked extensions."
} else {
    # Create new group if it doesn't exist
    New-FsrmFileGroup -Name $fsrmGroupName -IncludePattern $extensions
    Write-Host "Created new FSRM group: $fsrmGroupName with blocked extensions."
}
Write-Host ""
Write-Host "Import completed successfully!" -ForegroundColor Green
