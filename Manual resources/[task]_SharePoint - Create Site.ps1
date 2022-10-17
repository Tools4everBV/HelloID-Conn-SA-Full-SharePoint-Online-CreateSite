# Set TLS to accept TLS, TLS 1.1 and TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$baseGraphUri = "https://graph.microsoft.com/"

$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

# variables configured in form
$displayName = $form.generatedNames.displayName
$description = $form.generatedNames.description
$mailnickname = $form.generatedNames.mailNickName
$visibility = $form.visibility
$owner = $form.owner.id

# Create authorization token and add to headers
try{
    Write-Information "Generating Microsoft Graph API Access Token"

    $baseUri = "https://login.microsoftonline.com/"
    $authUri = $baseUri + "$AADTenantID/oauth2/token"

    $body = @{
        grant_type    = "client_credentials"
        client_id     = "$AADAppId"
        client_secret = "$AADAppSecret"
        resource      = "https://graph.microsoft.com"
    }

    $Response = Invoke-RestMethod -Method POST -Uri $authUri -Body $body -ContentType 'application/x-www-form-urlencoded'
    $accessToken = $Response.access_token;

    #Add the authorization header to the request
    $authorization = @{
        Authorization  = "Bearer $accesstoken";
        'Content-Type' = "application/json";
        Accept         = "application/json";
    }
}
catch{
    throw "Could not generate Microsoft Graph API Access Token. Error: $($_.Exception.Message)"    
}

try {
    Write-Information "Creating Group [$displayName] with description [$description]."

    $createGroupUri = $baseGraphUri + "v1.0/groups"
    
    $groupbody = @"
    {
        "DisplayName":"$displayName",
        "MailNickName" : "$mailnickname",        
        "Description":"$description",
        "visibility":"$visibility",        
        "groupTypes":  [ 
            "Unified" 
        ],
        "mailEnabled":  "true",
        "securityEnabled":  "false",
        "owners@odata.bind": [
            "https://graph.microsoft.com/v1.0/users/$owner"
        ]
    }
"@
    

    $newgroup = Invoke-RestMethod -Uri $createGroupUri -Method POST -Headers $authorization -Body $groupbody
    
    Write-Information "Successfully created group [$displayName] with description [$description]."
    $Log = @{
        Action            = "CreateResource" # optional. ENUM (undefined = default) 
        System            = "AzureActiveDirectory" # optional (free format text) 
        Message           = "Successfully created group [$displayName] with description [$description]." # required (free format text) 
        IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
        TargetDisplayName = $displayName # optional (free format text)
        TargetIdentifier  = $($newGroup.id) # optional (free format text)
    }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log
}
catch {
    Write-Information "Failed to create group [$displayName] with description [$description]. Error: $($_.Exception.Message)"
    $Log = @{
        Action            = "CreateResource" # optional. ENUM (undefined = default) 
        System            = "AzureActiveDirectory" # optional (free format text) 
        Message           = "Failed to create group [$displayName] with description [$description]." # required (free format text) 
        IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
        TargetDisplayName = $displayName # optional (free format text)
        TargetIdentifier  = $($newGroup.id) # optional (free format text)
    }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log
}

