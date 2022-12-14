function gacl   ( $FOLDER ){ 
    (get-acl $FOLDER).access |
    Select-Object `
    @{Label="Identity";Expression={$_.IdentityReference}}, `
    @{Label="Right";Expression={$_.FileSystemRights}}, `
    @{Label="Access";Expression={$_.AccessControlType}}, `
    @{Label="Inherited";Expression={$_.IsInherited}}, `
    @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
    @{Label="Propagation Flags";Expression={$_.PropagationFlags}} |
    Format-Table -auto
    Sort-Object Identity -Descending
    }


function gacls  (){
    $PATH=(Get-Childitem).name
    ForEach ($FOLDER in $PATH) {
        Write-Host (Get-Childitem).name -ForegroundColor Yellow
        (get-acl $PATH).access |
        Select-Object `
        @{Label="Identity";Expression={$_.IdentityReference}}, `
        @{Label="Right";Expression={$_.FileSystemRights}}, `
        @{Label="Access";Expression={$_.AccessControlType}}, `
        @{Label="Inherited";Expression={$_.IsInherited}}, `
        @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
        @{Label="Propagation Flags";Expression={$_.PropagationFlags}} |
        Format-Table -auto
        Sort-Object Identity -Descending
    }
}