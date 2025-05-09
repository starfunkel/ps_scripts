<#
.SYNOPSIS
    The script lists linked GPOs.
#>

[cmdletbinding(DefaultParameterSetName = "All")]
        [outputtype("myGPOLink")]
        Param(
            [parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Enter a GPO name. Wildcards are allowed")]
            [alias("gpo")]
            [ValidateNotNullOrEmpty()]
            [string]$Name,
            [Parameter(HelpMessage = "Specify the name of a specific domain controller to query.")]
            [ValidateNotNullOrEmpty()]
            [string]$Server,
            [Parameter(ValueFromPipelineByPropertyName)]
            [ValidateNotNullOrEmpty()]
            [string]$Domain,
            [Parameter(ParameterSetName = "enabled")]
            [switch]$Enabled,
            [Parameter(ParameterSetName = "disabled")]
            [switch]$Disabled
        )
    
        Begin {
            Write-Verbose "Starting $($myinvocation.mycommand)"
            #display some metadata information in the verbose output
            Write-Verbose "Running as $($env:USERDOMAIN)\$($env:USERNAME) on $($env:Computername)"
            Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
            Write-Verbose "Using ActiveDirectory module $((Get-Module ActiveDirectory).version)"
            Write-Verbose "Using GroupPolicy module $((Get-Module GroupPolicy).version)"
    
            #define a helper function to get site level GPOs
            #It is easier for this task to use the Group Policy Management COM objects.
            Function Get-GPSiteLink {
                [cmdletbinding()]
                Param (
                    [Parameter(Position = 0,ValueFromPipelineByPropertyName,ValueFromPipeline)]
                    [alias("Name")]
                    [string[]]$SiteName = "Default-First-Site-Name",
                    [Parameter(Position = 1)]
                    [string]$Domain,
                    [string]$Server
                )
    
                Begin {
                    Write-Verbose "Starting $($myinvocation.mycommand)"
    
                    #define the GPMC COM Objects
                    $gpm = New-Object -ComObject "GPMGMT.GPM"
                    $gpmConstants = $gpm.GetConstants()
    
                } #Begin
    
                Process {
                    $getParams = @{Current = "LoggedonUser"; ErrorAction = "Stop" }
                    if ($Server) {
                        $getParams.Add("Server", $Server)
                    }
                    if ( -Not $PSBoundParameters.ContainsKey("Domain")) {
                        Write-Verbose "Querying domain"
                        Try {
                            $Domain = (Get-ADDomain @getParams).DNSRoot
                        }
                        Catch {
                            Write-Warning "Failed to query the domain. $($_.exception.message)"
                            #Bail out of the function since we need this information
                            return
                        }
                    }
    
                    Try {
                        $Forest = (Get-ADForest @getParams).Name
                    }
                    Catch {
                        Write-Warning "Failed to query the forest. $($_.exception.message)"
                        #Bail out of the function since we need this information
                        return
                    }
    
                    $gpmDomain = $gpm.GetDomain($domain, $server, $gpmConstants.UseAnyDC)
                    foreach ($item in $siteName) {
                        #connect to site container
                        $SiteContainer = $gpm.GetSitesContainer($forest, $domain, $null, $gpmConstants.UseAnyDC)
                        Write-Verbose "Connected to site container on $($SiteContainer.domainController)"
                        #get sites
                        Write-Verbose "Getting $item"
                        $site = $SiteContainer.GetSite($item)
                        Write-Verbose "Found $($sites.count) site(s)"
                        if ($site) {
                            Write-Verbose "Getting site GPO links"
                            $links = $Site.GetGPOLinks()
                            if ($links) {
                                #add the GPO name
                                Write-Verbose "Found $($links.count) GPO link(s)"
                                foreach ($link in $links) {
                                    [pscustomobject]@{
                                        GpoId       = $link.GPOId -replace ("{|}", "")
                                        DisplayName = ($gpmDomain.GetGPO($link.GPOID)).DisplayName
                                        Enabled     = $link.Enabled
                                        Enforced    = $link.Enforced
                                        Target      = $link.som.path
                                        Order       = $link.somlinkorder
                                    } #custom object
                                }
                            } #if $links
                        } #if $site
                    } #foreach site
                } #process
    
                End {
                    Write-Verbose "Ending $($myinvocation.MyCommand)"
                } #end
            } #end function
    
        } #begin
        Process {
            Write-Verbose "Using these bound parameters"
            $PSBoundParameters | Out-String | Write-Verbose
    
            #use a generic list instead of an array for better performance
            $targets = [System.Collections.Generic.list[string]]::new()
    
            #use an internal $PSDefaultParameterValues instead of trying to
            #create parameter hashtables for splatting
            if ($Server) {
                $script:PSDefaultParameterValues["Get-AD*:Server"] = $server
                $script:PSDefaultParameterValues["Get-GP*:Server"] = $Server
            }
    
            if ($domain) {
                $script:PSDefaultParameterValues["Get-AD*:Domain"] = $domain
                $script:PSDefaultParameterValues["Get-ADDomain:Identity"] = $domain
                $script:PSDefaultParameterValues["Get-GP*:Domain"] = $domain
            }
    
            Try {
                Write-Verbose "Querying the domain"
                $mydomain = Get-ADDomain -ErrorAction Stop
                #add the DN to the list
                $targets.Add($mydomain.distinguishedname)
            }
            Catch {
                Write-Warning "Failed to get domain information. $($_.exception.message)"
                #bail out if the domain can't be queried
                Return
            }
    
            if ($targets) {
                #get OUs
                Write-Verbose "Querying organizational units"
                Get-ADOrganizationalUnit -Filter * |
                ForEach-Object { $targets.add($_.Distinguishedname) }
    
                #get all the links
                Write-Verbose "Getting GPO links from $($targets.count) targets"
                $links = [System.Collections.Generic.list[object]]::New()
                Try {
                    ($Targets | Get-GPInheritance -ErrorAction Stop).gpolinks | ForEach-Object { $links.Add($_) }
                }
                Catch {
                    Write-Warning "Failed to get GPO inheritance. If specifying a domain, be sure to use the DNS name. $($_.exception.message)"
                    #bail out
                    return
                }
    
                Write-Verbose "Querying sites"
                $getADO = @{
                    LDAPFilter = "(Objectclass=site)"
                    properties = "Name"
                    SearchBase = (Get-ADRootDSE).ConfigurationNamingContext
                }
                $sites = (Get-ADObject @getADO).name
                if ($sites) {
                    Write-Verbose "Processing $($sites.count) site(s)"
                    #call the private helper function
                    $sites | Get-GPSiteLink | ForEach-Object { $links.add($_) }
                }
    
                #filter for Enabled or Disabled
                if ($enabled) {
                    Write-Verbose "Filtering for Enabled policies"
                    $links = $links.where( { $_.enabled })
                }
                elseif ($Disabled) {
                    Write-Verbose "Filtering for Disabled policies"
                    $links = $links.where( { -Not $_.enabled })
                }
    
                if ($Name) {
                    Write-Verbose "Filtering for GPO name like $name"
                    #filter by GPO name using v4 filtering feature for performance
                    $results = $links.where({ $_.displayname -like "$name" })
                }
                else {
                    #write all the links
                    Write-Verbose "Displaying ALL GPO Links"
                    $results = $links
                }
                if ($results) {
                    #insert a custom type name so that formatting can be applied
                    $results.GetEnumerator().ForEach( { $_.psobject.TypeNames.insert(0, "myGPOLink") })
                    $results
                }
                else {
                    Write-Warning "Failed to find any GPO using a name like $Name"
                }
            } #if targets
        } #process
        End {
            Write-Verbose "Ending $($myinvocation.mycommand)"
        } #end
    