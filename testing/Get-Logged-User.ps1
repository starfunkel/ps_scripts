# function Get-LoggedUser
# {
#     [CmdletBinding()]
#     param
#     (
#         [string[]]$ComputerName 
#     )
#     foreach ($comp in $ComputerName)
#     {
#         $output = @{'Computer' = $comp }
#         $output.UserName = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).UserName
#         [PSCustomObject]$output
#     }
# }

# function Get-RemoteLoggedUser
# {
#     [CmdletBinding()]
#     param
#     (
#         [string[]]$ComputerName 
#     )
#     foreach ($comp in $ComputerName)
#     {
#         if ((Test-NetConnection $comp -WarningAction SilentlyContinue).PingSucceeded -eq $true) 
#             {  
#                 $output = @{'Computer' = $comp }
#                 $output.UserName = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).UserName
#             }
#             else
#             {
#                 $output = @{'Computer' = $comp }
#                          $output.UserName = "offline"
#             }
#          [PSCustomObject]$output 
#     }
# }
# $computers = (Get-AdComputer -Filter {enabled -eq "true"} -SearchBase 'OU=Berlin,DC=woshub,DC=com').Name
# Get-LoggedUser $computers |ft -AutoSize