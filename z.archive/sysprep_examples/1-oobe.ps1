#  +++++ Nach dem Cloning ausführen --> wenn frisch wie oobe, als admin 

#  +++++ Firewall Regeln ändern
 netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes # Enable Network Discovery (https://serverfault.com/questions/969771/how-to-check-if-network-discovery-is-on-using-powershell)
 netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

 #  +++++ DE LangPack Install
Add-WindowsPackage -online -PackagePath "C:\support\Ersteinrichtung\11 Customs\lp-de.cab" -NoRestart 
Set-WinUserLanguageList -Force -LanguageList "de-de"
Set-WinSystemLocale -SystemLocale de-de
Set-WinDefaultInputMethodOverride -InputTip "0407:00000407" # german
Set-WinSystemLocale -SystemLocale en-US
Set-WinUserLanguageList  -LanguageList "de-DE" -Force
set-winhomelocation -geoid 0x5e #Region
Set-WinUILanguageOverride -Language en-us

#  ++++++ MS Word starten um Update Dialog wegzunicken
Write-Host "Bitte in MS Word die Updates aktivieren" -ForegroundColor Green
start-sleep 5
set-location "C:\Program Files (x86)\Microsoft Office\Office16"
./WINWORD.EXE
start-sleep 25
 #  +++++ Windows Updates für alle MS Produkte suchen + installieren + Neustart
 Install-WindowsUpdate -AcceptAll -Install -AutoReboot