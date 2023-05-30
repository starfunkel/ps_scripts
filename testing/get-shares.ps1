# ### enum shares

# ### Colors
# $R = 'Red'
# $Y = 'Yellow'
# $G = 'Green'
# $Re = @{ForegroundColor = $R}
# $Ye = @{ForegroundColor = $Y}
# $Gr = @{ForegroundColor = $G}
# $nRe = @{NoNewLine = $true; ForegroundColor = $R}
# $nYe = @{NoNewLine = $true; ForegroundColor = $Y}
# $nGr = @{NoNewLine = $true; ForegroundColor = $G}

# ### Usage
# Write-Host 'This' @nYe; 
# Write-Host 'is' @nRe; 
# Write-Host 'Handy' @Gr


# ### Fetch the domain PDC for future script usage
# $script:PDC = (Get-ADDomainController -Filter {OperationMasterRoles -like 'PDCE*'}).HostName

# ### Alternative Method
# Try {
#     $oRootDSE = Get-ADRootDSE -ErrorAction Stop
# } Catch {
#     Write-Warning -Message ('Could not get the root DSE. Error: {0}' -f $_.Exception.Message)
#     return
# }
# $script:PDC = ($oRootDSE.dnsHostName)


# ### Single line Progress bar
# Write-Progress -Activity 'Doing stuff' -PercentComplete ([array]::IndexOf($Things,$Item)/$Things.Count*100)

# ### Multiple Progress Bars
# ForEach ($Share in $ShareList) {
#     Write-Progress -Id 1 -Activity 'Enumerating shares' -PercentComplete ($ShareList.IndexOf($Share)/$ShareList.Count*100)
#     #Doing some stuff
#     ForEach ($File in $Share) {
#         Write-Progress -Id 2 -ParentId 1 -Activity 'Enumerating files' -PercentComplete ($Share.IndexOf($File)/$Share.Count*100) -Status "$($Share.indexof($File)) of $($Share.count)"
#         #Doing some stuff inside doing other stuff
#     }
# }

# ### A more readable way to write Progress bars offering more control
# #Initialize the Progress Bar
# $pi                    = 0
# $ProgressActivity = 'Gathering DC Events . . .'
# $Progress              = @{
#     Activity         = $ProgressActivity
#     CurrentOperation = 'Loading'
#     PercentComplete  = 0
# }

# ForEach ($whatever in $collection) {
#     #Increment and utilize the Progress Bar
#     $pi++
#     [int]$percentage           = ($pi / $collection.Count)*100
#     $Progress.CurrentOperation = "$pi of $($collection.Count) - $whatever"
#     $Progress.PercentComplete  = $percentage
#     Write-Progress @Progress

#     <# 
#         doing stuff
#         more stuff - bleh
#     #>
# }
# #End the Progress Bar properly
# Write-Progress -Activity $ProgressActivity -Status 'Ready' -Completed


# ### Rearange AD CanonicalName to be more human readable
# Get-ADUser -Identity <samaccountname> -Properties CanonicalName | 
# Select-Object -Property @{
#                             n = 'Container'
#                             e = {$_.CanonicalName -ireplace '\/[^\/]+$',''}
#                         }


# ### Sort a list of IP addresses actually numerically
# Sort-Object -Property {$_.IPv4Address -as [Version]}