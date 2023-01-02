filter Get-ErrorLog ([switch]$Message)
{
if ($Message) { Out-Host -InputObject $_.Message }
else { $_ }
}

Get-WinEvent -LogName System -MaxEvents 100 | Get-ErrorLog -Message