### Scripts & Tools Caller

### Scripts
function mtr        { C:\support\code\ps-scripts\mtr.ps1 $args[0] }
function gpa        { C:\support\code\ps-scripts\GPAnalyser.ps1 }
### Tools
function lgpo       { C:\support\runners\lgpo.exe }
function nmap       { C:\support\Nmap\nmap.exe $args[0] }

### Screen Captures
function fla        { & "$env:ProgramFiles\flameshot\bin\flameshot.exe"}

### Firefox
function ffd        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p default }
# function fft        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p testing }
# function ffp        { & "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -p }