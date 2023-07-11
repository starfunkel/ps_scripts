function get-loggedon-users {

  Get-CimInstance Win32_UserProfile -ComputerName ComputerName |
  Select-Object LocalPath,Loaded
}
