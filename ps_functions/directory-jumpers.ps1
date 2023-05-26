### Directory Jumpers

function runners    { Set-Location C:\support\runners }
function sup        { Set-Location c:\support\ }
function HKLM       { Set-Location HKLM: }
function HKCU       { Set-Location HKCU: }
function Env        { Set-Location Env: }
function C          { Set-Location C:\ }
function ~          { Set-Location $env:UserProfile }
function gitd       { Set-Location C:\support\code\git-repos\starfunkel }
function dl         { Set-Location "C:\Users\rathnau\Downloads" }
function co         { Set-Location "C:\support\code"}
function da         { Set-Location D:\ }

### Directoriey movement

function cd..       { Set-Location .. }
function cd...      { Set-Location ..\.. }
function cd....     { Set-Location ..\..\.. }