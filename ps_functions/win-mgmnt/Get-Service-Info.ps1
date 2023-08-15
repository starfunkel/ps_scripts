function Get-Service-Info {
    Get-CimInstance Win32_Service |
    Select-Object Name,DisplayName,StartMode,State,Status,StartName,PathName |
    Sort-Object StartName |
    Format-Table
}