<#
.SYNOPSIS
    This script retrieves all 4625 events from a file or the default security log file.
#>    
function Get-Event-4625 {
  [CmdletBinding()]
  param ()

  $logPath = Read-Host "Enter the full path to the .evtx log file (leave empty to use the live Security log)"

  $filter4625 = @"
<QueryList>
<Query Id="0" Path="Security">
  <Select Path="Security">*[System[(EventID=4625)]]</Select>
</Query>
</QueryList>
"@

  try {
      if ([string]::IsNullOrWhiteSpace($logPath)) {
          # Live Security log
          $logonEvents = Get-WinEvent -FilterXml $filter4625 -LogName Security
      }
      else {
          if (-not (Test-Path $logPath)) {
              Write-Error "The file path '$logPath' does not exist. Get out!"
              return
          }
          $logonEvents = Get-WinEvent -FilterXml $filter4625 -Path $logPath
      }

      $logonEvents | Sort-Object TimeCreated
  }
  catch {
      Write-Error "Failed to retrieve events: $_"
  }
}