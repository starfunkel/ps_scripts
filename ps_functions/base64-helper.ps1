function ConvertTo-Base64 {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InputString
    )

    process {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
        $base64String = [System.Convert]::ToBase64String($bytes)
        $base64String
    }
}

function ConvertFrom-Base64 {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InputString
    )

    process {
        $bytes = [System.Convert]::FromBase64String($InputString)
        $plainText = [System.Text.Encoding]::UTF8.GetString($bytes)
        $plainText
    }
}

Set-Alias -Name ToBase64 -Value ConvertTo-Base64
Set-Alias -Name FromBase64 -Value ConvertFrom-Base64