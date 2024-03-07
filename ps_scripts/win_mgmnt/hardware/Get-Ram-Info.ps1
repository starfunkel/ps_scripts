Get-CimInstance -Class Win32_PhysicalMemory  | 
Select-Object Manufacturer,BankLabel,ConfiguredClockSpeed,`
@{n="RAM"; e={[Math]::Round($_.Capacity/1GB,0)}}, SerialNumber 