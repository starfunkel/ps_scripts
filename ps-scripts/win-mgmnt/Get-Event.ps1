function Get-Event {
    param(
        ## The Log to examine
        [Parameter(ParameterSetName='Log',ValueFromPipeline=$true,mandatory=$true,position=0)]
        [string]$Logname,
        [string]$First,
        [string[]]$IDs,
        [string]$Format
    )



   if ($Format -eq 'list') { 
    
        Foreach ($i in $IDs)
            {
                $ID_Array = [int[]]($IDs -split ',')
                $ID_Array.count
                Write-Host Events of Event ID $I
                Get-WinEvent -Logname $Logname | Where-object {$_.Id -in ($IDs)} |
                Select-Object -Property TimeCreated, Id, Message -first $First  |
                Format-List
            }
    }
    
    if ($Format -eq 'table') {

        Foreach ($i in $IDs)
            {
                $ID_Array = [int[]]($IDs -split ',')
                $ID_Array.count
                Write-Host Events of Event ID $I
                Get-WinEvent -Logname $Logname | Where-object {$_.Id -in ($IDs)} |
                Select-Object -Property TimeCreated, Id, Message -first $First  |
                Format-Table -Autosize
            }
    }
}



# function Get-Log {

#     param(
#         ## The Log to examine
#         [Parameter(ParameterSetName='Log',ValueFromPipeline=$true,mandatory=$true,position=0)]
#         [string]$Logname,
#         [string[]]$IDs
#         )

#         foreach ($i in $IDs)
#         {
#             Get-WinEvent -Logname $Logname | Where-object {$_.Id -in ($IDs)} |
#             Select-Object -Property TimeCreated, Id, Message | Format-Table -AutoSize 
#         }
# }
