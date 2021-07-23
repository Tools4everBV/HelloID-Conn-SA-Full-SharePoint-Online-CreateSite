$connected = $false
try 
    {
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        $pwd = ConvertTo-SecureString -string $SharePointAdminPWD -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential $SharePointAdminUser, $pwd
        $null = Connect-SPOService -Url $SharePointBaseUrl -Credential $cred
        Write-Information "Connected to Microsoft SharePoint"
        $connected = $true
    }
    catch
    {	
        Write-Error "Could not connect to Microsoft SharePoint. Error: $($_.Exception.Message)"
        Write-Warning "Failed to connect to Microsoft SharePoint"
    }

if ($connected)
{
    try 
    {
        $iterationMax = 10
        $iterationStart = 1;
        $sitename = $datasource.inputtitle
        $sitedisplayName = $datasource.inputtitle

    

        function Remove-StringLatinCharacters
        {
            PARAM ([string]$String)
            [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
        }
        
        
        for($i = $iterationStart; $i -lt $iterationMax; $i++) {
            
            $spSiteDisplayName = $sitedisplayName
            $spSiteName = $sitename
            
            if($i -eq $iterationStart) {
                $spSiteName = $spSiteName
            } else {
                $spSiteName = $spSiteName + "$i"
                $spSiteDisplayName = $spSiteDisplayName + " $i"
            }

            $spSiteName = $spSiteName.ToLower()
            $spSiteName = Remove-StringLatinCharacters $spSiteName
            $spSiteName = $spSiteName.trim() -replace '\s+', ''
            
            $spSiteDisplayName = $spSiteDisplayName.trim() -replace '\s+', ' '
            
            Write-information "Searching for Site with title=$spSiteName"           
            $found = Get-SPOSite -Filter "url -like '$($spSiteName)'" -Limit ALL
        
            if(@($found).count -eq 0) {
                $returnObject = @{SiteName=$spSiteName; SiteDisplayName=$spSiteDisplayName}
                Write-information "Site with title $spSiteName not found"
                break;
            } else {
                Write-information "Site with title=$spSiteName found"
            }
        }
        if(-not [string]::IsNullOrEmpty($returnObject)) {
            Write-output $returnObject
        }
    } catch {
        Write-error "Error generating names. Error: $($_.Exception.Message)"
    }
    finally
    {        
        Disconnect-SPOService
        Remove-Module -Name Microsoft.Online.SharePoint.PowerShell
    }
}
else
{
	return
}
