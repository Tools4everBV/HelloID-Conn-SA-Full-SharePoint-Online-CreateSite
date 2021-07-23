$connected = $false
try {
	Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
	$pwd = ConvertTo-SecureString -string $SharePointAdminPWD -AsPlainText -Force
	$cred = New-Object System.Management.Automation.PSCredential $SharePointAdminUser, $pwd
	$null = Connect-SPOService -Url $SharePointBaseUrl -Credential $cred
    HID-Write-Status -Message "Connected to Microsoft SharePoint" -Event Information
    HID-Write-Summary -Message "Connected to Microsoft SharePoint" -Event Information
	$connected = $true
}
catch
{	
    HID-Write-Status -Message "Could not connect to Microsoft SharePoint. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to connect to Microsoft SharePoint" -Event Failed
}

if ($connected)
{
	try {
		New-SPOSite -Url "$($SharePointRootUrl)/sites/$($spSiteUrlNode)" -Owner "$spSiteOwner" -StorageQuota 1000 -Template "$spSiteTemplate" -Title "$spSiteTitle"
		HID-Write-Status -Message "Created Site [$spSiteTitle] with url [$($SharePointRootUrl)/sites/$($spSiteUrlNode)]" -Event Success
		HID-Write-Summary -Message "Successfully created Site [$spSiteTitle] with url [$($SharePointRootUrl)/sites/$($spSiteUrlNode)]" -Event Success
	}
	catch
	{
		HID-Write-Status -Message "Could not create Site [$spSiteTitle]. Error: $($_.Exception.Message)" -Event Error
		HID-Write-Summary -Message "Failed to create Site [$spSiteTitle]" -Event Failed
	}
    finally
    {        
        Disconnect-SPOService
        Remove-Module -Name Microsoft.Online.SharePoint.PowerShell
    }
}
