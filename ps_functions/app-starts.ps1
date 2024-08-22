# Start Apps

### custom app shortcuts
function fla            { & "$env:ProgramFiles\flameshot\bin\flameshot.exe" }
function mmc            { & "C:\Windows\SysWOW64\mmc.exe" }
function cmmc           { & "C:\support\code\configs\cmmc.msc" }
function winscp         { & "C:\support\tools\Portable_APPS\winscp\WinSCP.exe"} 
function baobab         { & "C:\support\tools\Portable_APPS\WinDirStatPortable\App\WinDirStat\windirstat.exe" }

### coding
function x64dgb     {    & "C:\support\tools\x64dgb\release\x64\x64dbg.exe"}
function hxd            { & "C:\Program Files\HxD\HxD.exe"}
function ghidra         { & "C:\support\tools\dig_deeper\debug\ghidra\ghidraRun.bat"}

### Firefox
function ffd            { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p default }
function fft            { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p Testing }
function ffp            { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p }

### Reload Powershell Profile
function rel            { & powershell -nop}

### cowsay stuff
function cow            { Get-Cowsay "$args" } # Install-Module -Name CowsaySharp
function tux            { Get-Cowsay -cowfile tux "$args" }

### winfetch
function winfetch       { "C:\support\code\_git-repos\foreign\winfetch\winfetch.ps1" }

### vrtualbox
# function vboxmanage   { & "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" $args[0] $args[1] $args[2] }
# function start-lab    { & "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" startvm "VM-LX-SRV-DEBIAN-11" --type headless}

### network
function nm             { & "C:\Program Files\Microsoft Network Monitor 3\netmon.exe"}
function nmwifi         { & "C:\Program Files\Microsoft Network Monitor 3\nmwifi.exe"}
function vim	        { & "C:\Program Files\Neovim\bin\nvim.exe" $args[0] }
function wifi           { & "C:\support\tools\network\WifiInfoView.exe"}

### Update Stuff
function update-pwsh    { winget install --id Microsoft.Powershell --source winget }