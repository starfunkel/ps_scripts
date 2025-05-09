#--------------------------------------------------------------------------------
# GPAnalyser.ps1
#
# Hondo, Karsten 
#
# Skript wurde erstellt um die tägliche Gruppenrichtlinien-Verarbeitung zu debuggen.
#
# Mögliche Aufrufparameter:
#   GPAnalyser.ps1 -Analyse -Computer N2030123 -ShowLastHours 24
#
#
# - Versionen - 
#
#  1.0 - Erstellung
#  ...
#
#  1.4 - Aufgrund von Bug in PS v2 & 3 Spracheinstellungen fest definiert.
# 
#--------------------------------------------------------------------------------          
          
          
Param ([Switch]$Analyse,[String]$Computer = $Env:ComputerName, [String]$ShowLastHours = 12)        



#--------------------------------------------------------------------
# Funktion Usage
#--------------------------------------------------------------------
Function Usage() 
{    
    Clear-Host
    
    ""
    "`t -----------------------------------------------"
    "`t     Analyse der Windows Gruppenrichtlinien"
    "`t -----------------------------------------------"    
    ""
    "     Aufrufparameter"
    ""
    "         -Analyse              Startet dieses Skript"
    ""
    "          -Computer             Angabe eines anderen Computer"
    "          -ShowLastHours        Angabe des Zeitraums der Analyse"
    ""
    ""
    "     Beispiele"
    ""
    "          .\GPAnalyser.ps1 -Computer D6256022"
    "          .\GPAnalyser.ps1 -Computer D6256022 -ShowLastHours 48"
    ""
    ""     
 Exit
}
#--------------------------------------------------------------------



                
#--------------------------------------------------------------------------------
# Funktion Show-GPO-Details
#----
# Diese Funktion dient dazu die ausgewähle GPO-Verarbeitung genauer zu analysieren.
# Dabei werden verschiedenste Events ausgewertet.
#
# Version 1.0 - 17.01.2013
#--------------------------------------------------------------------------------
Function Show-TopMenü
{
    Try
        {
            Clear-Host
            
            Write-Host ( "" )
            Write-Host ( "" )
            Write-Host ( "$T$T$T ----------------------------------------------------- " )                
            Write-Host ( "$T$T$T|     - Analyse der Windows-Gruppenrichtlinien -      |" )
            Write-Host ( "$T$T$T ----------------------------------------------------- " )
            Write-Host ( "" )                       
        }
    
    Catch { Throw $_ }
}
#--------------------------------------------------------------------------------




#--------------------------------------------------------------------------------
# Funktion Get-GPOReason
#----
# Diese Funktion dient dazu den Grund der GPO Verarbeitung auzszulesen
#
# Version 1.0 - 31.10.2013
#--------------------------------------------------------------------------------
Function Get-GPOReason([INT]$Nr)
{
    Try
        {        
            Switch( $Nr )
                {
                    4000 { $Text = " Start der Workstation" }
                    4001 { $Text = "Anmeldung"}
                    4002 { $Text = " Benutzer (Netzwerkänderung)" }
                    4003 { $Text = " Computer (Netzwerkänderung)" }
                    4004 { $Text = " Computer (manuell)" }
                    4005 { $Text = " Benutzer (manuell)" }
                    4006 { $Text = " Computer (periodisch)" }
                    4007 { $Text = " Benutzer (periodisch)" }
                
                    Default { $Text = " -" }
                
                }
            
            Return $Text
        }
    
    Catch { Throw $_ }     
}
#--------------------------------------------------------------------------------




#--------------------------------------------------------------------------------
# Funktion Show-GPO-Details
#----
# Diese Funktion dient dazu die ausgewähle GPO-Verarbeitung genauer zu analysieren.
# Dabei werden verschiedenste Events ausgewertet.
#
# Version 1.0 - 17.01.2013
#--------------------------------------------------------------------------------
Function Show-GPODetails
{
    Try
        {                
            # Top-Menü anzeigen
                Show-TopMenü
            
            # Auf Gruppenrichtlinien filtern
               $GPO_Prozess = $Init_Menü | Where-Object-Object { $_.ID -eq $ID }
        
            # Den gesuchten Gruppenrichtlinien-Prozess auslesen
               $Script:Search_GPO_Events = $ALL_GPO_Events | Where-Object-Object { $_.ActivityID -eq $GPO_Prozess.ActivityID }                            
                                                                                
            # Abfragen auf EventID "5310" ( Domäneninformationen )
               $GPI_Event = $Script:Search_GPO_Events | Where-Object-Object { ( $_.ID -eq "5310" ) | Select-Object-First 1 }
               
            # Abfragen auf EventID "5312" ( Ende der GPO-Ermittlungen )
               $GPA_Event = $Script:Search_GPO_Events | Where-Object-Object { ( $_.ID -eq "5312" ) | Select-Object-First 1 }   
                                    
            # Abfragen auf EventID "4016" ( Liste der anzuwendenden Gruppenrichtlienen )                                 
               $GPP_Events = $Script:Search_GPO_Events | Where-Object-Object { ( $_.ID -eq "4016" ) }    
                                        
            # Abfragen auf EventID "5016" ( Liste der abgearbeiteten Erweiterungen )                             
               $GPE_Events = $Script:Search_GPO_Events | Where-Object-Object { ( $_.ID -eq "5016" ) }
        
        
            
            # Anzeigen des Menüs
            #----------------------
        
                Write-Host ( "" )
                Write-Host ( "" )
                Write-Host ( "$T -- Details zur Verarbeitung Nr. {0}: ----------------------------------------------------" -F $ID )
                Write-Host ( "" )
                Write-Host ( "$T$T Beginn:   $T {0}" -F $GPO_Prozess.Uhrzeit )
                Write-Host ( "$T$T Ende:     $T {0}" -F $GPO_Prozess.Ende    )                        
                Write-Host ( "" )                                                                        
            
                        
                    #-------------------------------------------------------------
                    # Anzeigen der Domänen-Informationen
                    #-------------------------------------------------------------
                                                                                                
                        If ( $GPI_Event )
                            { 
                                # Verarbeiten der Event Daten ( Siehe $EventXML.Event.EventData.Data )
                                   [XML]$GPI_EventXML = $GPI_Event.ToXML()
                                        
                                # Werte aus Event auslesen...
                                   $GPO_PrincipalCNName     = $GPI_EventXML.SelectSingleNode( "//*[@Name='PrincipalCNName']"    )."#Text"
                                   $GPO_PrincipalDomainName = $GPI_EventXML.SelectSingleNode( "//*[@Name='PrincipalDomainName']")."#Text"
                                   $GPO_DCName              = $GPI_EventXML.SelectSingleNode( "//*[@Name='DCName']"             )."#Text"                                   
                                   
                                # Ausgabe                                                                       
                                   Write-Host ( "$T$T Konto:  $T {0}" -F $GPO_PrincipalCNName     )
                                   Write-Host ( "$T$T Server: $T {0}" -F $GPO_DCName              )
                                   Write-Host ( "$T$T Domain: $T {0}" -F $GPO_PrincipalDomainName )
                                   Write-Host ( "" )
                                   
                            }
                        else
                            {
                                # Wenn 'ReasonForSyncProcessing' ungleich 5 dann keine weitere Analyse.                            
                                   Write-Host ( "$T$T - Keine Domänen-Informationen vorhanden." )
                                   Write-Host ( "$T$T    Grund: Kein Event '5310' gefunden." )
                                   Write-Host ( "" )
                            }                                            
                                       
                                        
                
                    #-------------------------------------------------------------
                    # Anzeigen der Gruppenrichtlinien-Erweiterungen
                    #-------------------------------------------------------------
                                                        
                        If ( $GPE_Events )
                            {
                                  Write-Host ( "$T$T  Es wurden {0} Gruppenrichtlinien-Erweiterungen verarbeitet." -F $GPE_Events.Count )
                                  Write-Host ( "" )                                         
                                   
                                  # Ausgabe der Informationen  
                                        Foreach ( $Event in $GPE_Events )
                                            {                                                                                                                                                                                                                                    
                                                # Ausgabe der Gruppenrichtlinien-Erweiterung...
                                                   $ExtensionName  = $Event.Properties[2].Value                                                   
                                                   $ExtRunTime     = [Math]::Round(( $Event.Properties[0].Value / 1000 ),2)
                                                   $AllExtRunTime += [Math]::Round(( $Event.Properties[0].Value / 1000 ),2)
                                                    
                                                    Write-Host ( "$T$T$T{0}-Erweiterung" -F $ExtensionName )
                                                                                                                
                                                 # Ausgabe der einzelnen Gruppenrichtlinien....  
                                                    If ( $GPP_Events )
                                                        {                                                            
                                                           $EventText = $GPP_Events | Where-Object-Object { $_.Properties[1].Value -eq $ExtensionName } | Foreach { $_.Message.Split("`n") }                                                                                                                      
                                                           
                                                            If ( $EventText )
                                                                { $EventText = $EventText[4..($EventText.Count - 2)]                                                                            
                                                                   Foreach ( $GPO in $EventText ) { Write-Host ( "$T$T$T$T -> {0}" -F $GPO ) } }                                                                
                                                         
                                                          Write-Host ( "$T$T$T$T  - Laufzeit: {0} Sekunden" -F [String]$ExtRunTime )
                                                          Write-Host ( "" )      
                                                        }
                                            }                                                                                                                                                                                                                     
                            }
                        else
                            {
                                # Wenn kein Event 5016 vorhanden
                                    Write-Host ( "$T$T - Keine Erweiterungs-Informationen vorhanden." ) 
                                    Write-Host ( "$T$T    Grund: Kein Event '5016' vorhanden." )
                                    Write-Host ( "" )
                                    
                                    $AllExtRunTime = "-"      
                            }       
                    
                    
                    #-------------------------------------------------------------
                    # Ermittlte Laufzeit vor der GPO-Verarbeitung aus
                    #-------------------------------------------------------------
                        
                        If ( $GPA_Event )
                            {                                    
                              # Auslesen der Laufzeit bis Event 5312
                                 $GPO_Search_Time = [Math]::Round(($GPA_Event.TimeCreated - $GPO_Prozess.Uhrzeit).TotalSeconds,2)
                            }
                        else
                            { $GPO_Search_Time = "-" }    
                                                

                    
                Write-Host ( "" )
                Write-Host ( "$T$T Verarbeitungszeiten:" )                        
                Write-Host ( "" )
                Write-Host ( "$T$T   -> Ermittlung aller GP-Objekte:       $T {0} Sek." -F [String]$GPO_Search_Time )
                Write-Host ( "$T$T   -> Verarbeitung aller Erweiterungen:  $T {0} Sek." -F [String]$AllExtRunTime   )
                Write-Host ( "" )
                Write-Host ( "$T$T   -> Laufzeit der gesamten Verarbeitung:$T {0}"      -F $GPO_Prozess.Laufzeit    )
                Write-Host ( "" )
                Write-Host ( "$T ----------------------------------------------------------------------------------------" )
                Write-Host ( "" ) 
           
                    # Hinweis aus blanko Ansicht der Events einfügen...
                        If ( $GPO_Search_Time -eq "-" ) { Write-Host ( "$T$T Tipp: Siehe Experten-Modus für ein genaueres Fehlerbild!" ) }
                            
           
            # Auswahl-Menü
            #----------------                                              
                                                                            
                Write-Host ( "" ) 
                Write-Host ( "$T Auswahl-Menü" )
                Write-Host ( "$T ------------" ) 
                Write-Host ( "" ) 
                Write-Host ( "$T  1  -> Events dieser GPO-Verarbeitung anzeigen." )
                Write-Host ( "$T  2  -> Zurück zur Auswahl der GPO-Verarbeitungen." )
                Write-Host ( "$T  3  -> Analyse der Gruppenrichtlinien beenden." )
                Write-Host ( "" )
               
                  $Auswahl = Read-Host "$T Eingabe"        
            
                       
            # Eingabe auswerten
            #-------------------
                                                           
                Switch ( $Auswahl )
                    {
                        1 { Show-GPOEvents }
                        2 {                }
                        3 { Exit           }
                    }
         }
   
   Catch { Throw $_ }                                                                               
}
#--------------------------------------------------------------------------------



#--------------------------------------------------------------------------------
# Funktion Export-GPOEvents
#----
# Diese Funktion zeigt die reinen Events der gewünschten GP-Verarbeitung im Notepad an.
#
# Version 1.0 - 22.01.2013
#--------------------------------------------------------------------------------
Function Export-GPOEvents
{
    Try
        {
            # Gesamtansicht vorbereiten
                $Custom_Events = @()
                $Temp_Path     = "{0}\GPAnalyser_Events.txt" -F $ENV:Temp
                
            # Alle Events durchsuchen...
               Foreach ( $Event in $Script:Search_GPO_Events )
                 {                                                                                                                             
                   # Für Export merken                            
                      $Custom_Events += "{0} `t {1} `t {2}" -F $Event.TimeCreated, $Event.ID, [String]$Event.Message.Split("`n")
                 } 
            
            # Daten exportieren
               Set-Content -Path $Temp_Path -Value $Custom_Events
            
            # Notepad starten...
               Invoke-Expression( "Notepad.exe {0}" -F $Temp_Path )     
                
        }
        
   Catch { Throw $_ }     
}
#--------------------------------------------------------------------------------



#--------------------------------------------------------------------------------
# Funktion Show-GPOEvents
#----
# Diese Funktion zeigt die reinen Events der gewünschten GP-Verarbeitung an.
#
# Version 1.0 - 18.01.2013
#--------------------------------------------------------------------------------
Function Show-GPOEvents
{
    Try
        {
            # Top-Menü anzeigen
                Show-TopMenü
            
            # Anzeigen des Menüs
            #----------------------
        
                Write-Host ( "" )
                Write-Host ( "" )
                Write-Host ( "$T -- Experten-Modus zur Verarbeitung Nr. {0}: --------------------------------------------" -F $ID )
                Write-Host ( "" )
                Write-Host ( "$T Uhrzeit $T$T ID $T Message" )
                Write-Host ( "$T ------- $T$T -- $T -------" )
                  
                    # Alle Events ausgeben...
                       Foreach ( $Event in $Script:Search_GPO_Events )
                         {                                                                                                         
                            $Text1   = $Event.ID
                            $Text2   = $Event.TimeCreated
                            $Text3   = $Event.Message.Split("`n")[0]                                                                                                            
                            $Text4   = If ( $Text3.Length -le 70 ) { $Text3 } else { $Text3.SubString(0,70) + "..." }
                                                                                    
                            # Für Ausgabe anzeigen
                                Write-Host ( "$T {0} $T {1} $T {2}" -F $Text2, $Text1, $Text4 )
                         }
                    
                Write-Host ( "" )                                                                        
                Write-Host ( "$T ----------------------------------------------------------------------------------------" )
                Write-Host ( "" )                                                                        
            
            
            # Auswahl-Menü
            #----------------                                              
                                                                            
                Write-Host ( "" ) 
                Write-Host ( "$T Auswahl-Menü" )
                Write-Host ( "$T ------------" ) 
                Write-Host ( "" ) 
                Write-Host ( "$T  1  -> Diese Datensätze im Notepad öffnen." )
                Write-Host ( "$T  2  -> Details zu dieser GPO-Verarbeitung starten." )
                Write-Host ( "$T  3  -> Zurück zur Auswahl der GPO-Verarbeitungen." )
                Write-Host ( "$T  4  -> Analyse der Gruppenrichtlinien beenden." )
                Write-Host ( "" )
               
                  $Auswahl2 = Read-Host "$T Eingabe"        
            
                       
            # Eingabe auswerten
            #-------------------
                                                           
                Switch ( $Auswahl2 )
                    {
                        1 { Export-GPOEvents }
                        2 { Show-GPODetails  }
                        3 {                  }                        
                        4 { Exit             }
                    }
                
        }
    
    Catch { Throw $_ } 
}
#--------------------------------------------------------------------------------




#--------------------------------------------------------------------------------
# Funktion Show-MainMenü
#-----
# Diese Funktion zeigt das Hauptmenü des Tools an.
# Es dient zur Auswahl der verschiedenen Gruppenrichtlinien-Verarbeitungen
#
# Version 1.0  - 17.01.2013
#--------------------------------------------------------------------------------
Function Show-MainMenü
{
    Try
        {        
               # Auslesen der nötigen Informationen
               #------------------------------------
                        
                    # Inital Menü definieren
                        $Script:Init_Menü = @()
                        $Count            = 1    
                                        
                    # Sortierreihenfolge definieren
                        $GPS_Events = $GPS_Events | Sort-Object "TimeCreated" -Descending
                                        
                    # String-Array erstellen
                        Foreach ( $Event in $GPS_Events )
                            {                                                                             
                               # String-Array erzeugen
                                    $Array = "" | Select-Object "ID", "Uhrzeit", "ShortTime", "Anwender", "Laufzeit", "ActivityID", "Ende", "Art", "Status"
                                                                                
                                 # Werte direkt ermitteln...
                                    $Array.ID         = [String]$Count
                                    $Array.Uhrzeit    = $Event.TimeCreated
                                    $Array.ActivityID = $Event.ActivityID                                    
                                    $Array.Art        = (Get-GPOReason -Nr $Event.ID)
                                    $Array.ShortTime  = ("{0:dd.MM HH:mm:ss}" -F $Event.TimeCreated)
                                    
                                 # Verarbeiten der Event Properties...
                                    [XML]$EventXML    = $Event.ToXML()                                              
                                     $Anwender        = $EventXML.SelectSingleNode( "//*[@Name='PrincipalSamName']" )."#Text".Split("\")[1]        
                                     $Array.Anwender  = If ( $Anwender.Length -le 11 ) { $Anwender + ( " " * ( 11 - $Anwender.Length )) } else { $Anwender.SubString(0,11) }
                                                                                                      
                                 # Gesamtlaufzeit auslesen...
                                    $End_Event      = $GPE_Events | Where-Object { ($_.ActivityID -eq $Event.ActivityID) } | Sort-Object "TimeCreated" -Descending | Select-Object-First 1
                                     $Array.Ende      = $End_Event.TimeCreated
                                     $Array.Laufzeit  = [String][Math]::Round(($Array.Ende - $Array.Uhrzeit).TotalSeconds,2) + " Sek."       
                                                                                                                                                    
                                 # Status der Verarbeitung auslesen...                                        
                                    Switch ( ([String]$End_Event.ID)[0] )
                                        {
                                            4     { $Array.Status = "IN" }
                                            6     { $Array.Status = "WA" }
                                            7     { $Array.Status = "ER" }
                                            8     { $Array.Status = "OK" }
                                          Default { $Array.Status = "-"  }
                                        }                                                                                                            
                                                                     
                                 # Zuweisung in Inital Menü
                                    $Script:Init_Menü += $Array
                                    $Count            += 1                                                                                                                                                
                            }
                              
               
               # Anzeigen den Haupt-Menüs                         
               #--------------------------

                    Write-Host ( "" )
                    Write-Host ( "$T -- Gruppenrichtlinien-Verarbeitung: ----------------------------------------------------" )
                    Write-Host ( "" )
                    Write-Host ( "$T  ID$T Status$T Uhrzeit$T  Anwender$T Laufzeit$T Hinweis" )
                    Write-Host ( "$T  --$T ------$T -------$T  --------$T --------$T -------" )
                    
                      Foreach ( $Zeile in $Init_Menü )
                        {                                 
                            Write-Host ( "$T  {0}$T  {1}$T {2}$T  {3}$T {4}$T {5}" -F $Zeile.ID, $Zeile.Status, $Zeile.ShortTime, $Zeile.Anwender, $Zeile.Laufzeit, $Zeile.Art  )                            
                        }
                    
                    Write-Host ( "" )
                    Write-Host ( "$T ----------------------------------------------------------------------------------------" )                        
                    Write-Host ( "" )
                    Write-Host ( "" )                                                                   
        }
        
   Catch { Throw $_ }           
}
#--------------------------------------------------------------------------------





#--------------------------------------------------------------------------------
# Haupt-Teil
#--------------------------------------------------------------------------------

Try
    {
       
       # Usage
          If ( ! $Analyse ) { Usage }
      

       # Aufgrund eines PS-Bugs..
          [System.Threading.Thread]::CurrentThread.CurrentCulture = New-Object "System.Globalization.CultureInfo" "en-US"  
           
                                                       
       # Definiere Event-Log und Event-Source
          $Log    = "Microsoft-Windows-GroupPolicy/Operational"
          $Source = "Microsoft-Windows-GroupPolicy"           
       
       
       # Log-Ausgaben   
          $T = "`t"                 
       
       
       # Ausgabe einer kurzen Info 
          Write-Host ( "Daten werden geladen..." )

              
       # Auslesen aller Events dieses Computers
          If ( $Computer -eq $ENV:ComputerName )
              {  # Lokale Abfrage
                    $ALL_GPO_Events = Get-WinEvent -FilterHashtable @{ Logname=$Log;ProviderName=$Source;StartTime=(Get-Date).AddHours(-$ShowLastHours) } -ErrorAction 'Stop' }
          else
              {  # Remote Abfrage
                    $ALL_GPO_Events = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ Logname=$Log;ProviderName=$Source;StartTime=(Get-Date).AddHours(-$ShowLastHours) } -ErrorAction 'Stop' }
        
        
       # Auslesen der Start & Ende GPO Events ( EventID 4000 - 4007 bzw. 8000 - 8007 )
            $GPS_Events = $ALL_GPO_Events | Where-Object { ( $_.ID -ge "4000" ) -AND ( $_.ID -le "4007" ) }
            $GPE_Events = $ALL_GPO_Events | Where-Object { ( $_.ID -ge "6000" ) -AND ( $_.ID -le "8007" ) }
       
       
            # Start der Analyse           
                While ( $ALL_GPO_Events )
                    {                        
                                                                                                    
                           # Top-Menü anzeigen...          
                               Show-TopMenü                                   
                                            
                           # Haupt-Menp anzeigen...
                               Show-MainMenü  
                        
                           # Auswahlmenü anzeigen
                               Write-Host ( "$T Auswahl-Menü" )
                               Write-Host ( "$T ------------" ) 
                               Write-Host ( "" ) 
                               Write-Host ( "$T  ID   -> Auswahl einer Gruppenrichtlinien-Verarbeitung zu weiteren Analyse." )
                               Write-Host ( "$T  Exit -> Analyse der Gruppenrichtlinien beenden." )
                               Write-Host ( "" )  
                                
                                $ID = Read-Host "$T Eingabe"
            
            
                           # Eingabe auswerten 
                               Switch -Regex ( $ID )
                                 {                                    
                                    "^\d{1,2}$" { Show-GPODetails }                                                                         
                                    "Exit"      { Exit             }
                                    DEFAULT     {                  }
                                 }
                                  
                    }                                                 
    }

Catch { "ERROR: {0}" -F $_.Exception.Message }    

#--------------------------------------------------------------------------------                              