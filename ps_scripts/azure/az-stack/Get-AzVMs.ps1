function Get-AzVMs  () {
     Get-VM | Select-Object Name,ProcessorCount,`
        @{name='MemoryStartup';expression={[math]::Round($_.MemoryStartup/1GB,0).tostring() + ' GB'}},`
        @{name='MemoryAssigned';expression={[math]::Round($_.MemoryAssigned/1GB,0).tostring() + ' GB'}},`
        @{n='Uptime';e={(Get-Date) - $_.Uptime}},State,Version | Format-Table
}