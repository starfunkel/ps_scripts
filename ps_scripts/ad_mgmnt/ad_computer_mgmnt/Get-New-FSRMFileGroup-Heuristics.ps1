function Get-New-FSRMFileGroupheuristics {

    param(
        ## The Log to examine
        [string]$Name
    )

$ex = (Get-FsrmFileGroup -Name $Name).ExcludePattern
$new = ((Invoke-WebRequest -Uri "https://fsrm.experiant.ca/api/v1/combined").content | convertfrom-json).filters
$res = $new | Where-Object {$ex -notcontains $_ }

}