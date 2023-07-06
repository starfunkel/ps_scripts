function Get-Service-Info {
    Get-CimInstance Win32_Service |
    Select-Object Name,DisplayName,Status,StartName,PathName |
    Sort-Object Name |
    Format-Table
}