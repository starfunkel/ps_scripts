### temps

### Reimport get-adinfo.psm1 for development
function reimp      { import-module "C:\support\code\_git-repos\cras_stuff\get-ADInfo\get-adinfo.psm1" -force }


function ToBase64   {[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("$args[0]"))}

<#
function FromBase64 { $string=}

{[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("$args[0]"))}

#>