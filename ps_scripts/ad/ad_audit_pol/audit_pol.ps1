<#
.SYNOPSIS
    Get Audit Policy. Run on DC
#>
function FunctionName {
    auditpol.exe /get /category:* /r  | ConvertFrom-Csv |
    Format-Table Richtlinienziel,Unterkategorie,Aufnahmeeinstellung,Ausschlusseinstellung
}
