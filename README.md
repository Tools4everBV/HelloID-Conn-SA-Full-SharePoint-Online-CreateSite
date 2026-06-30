# HelloID-Conn-SA-Full-SharePoint-Online-CreateSite

| :information_source: Information                                                                                                                                                                                                                                                                                                                                                          |
| :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| This repository contains the connector and configuration code only. The implementer is responsible for acquiring the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements. |

## Description

_HelloID-Conn-SA-Full-SharePoint-Online-CreateSite_ is a template designed for use with HelloID Service Automation (SA) Delegated Forms. It can be imported into HelloID and customized according to your requirements.

This HelloID Service Automation Delegated Form provides SharePoint Online functionality. The following options are available:

1.  Enter a title for the new site
2.  Set the owner of the site
3.  Confirm the changes

#### App Registration & Certificate Setup

Before implementing this connector, make sure to configure a Microsoft Entra ID App Registration. During the setup process, you'll create a new App Registration in the Entra portal, assign the necessary API permissions (such as user and group read/write), and generate and assign a certificate.

Follow the official Microsoft documentation for creating an App Registration and setting up certificate-based authentication:

- [App-only authentication with certificate](https://learn.microsoft.com/en-us/powershell/exchange/app-only-auth-powershell-v2?view=exchange-ps#set-up-app-only-authentication)

#### HelloID-specific configuration

Once you have completed the Microsoft setup and followed their best practices, configure the following HelloID-specific requirements.

- **API Permissions (Application permissions)**:
  - `Directory.ReadWrite.All` - To read group information
  - `Group.ReadWrite.All` - To manage group memberships
  - `User.Read.All` - To read user information

- **Certificate Base64 encoded string**:
  - Base64 encoded string of the certificate assigned to the app registration. For instructions on creating the certificate and obtaining the base64 string, refer to our forum post: [Setting up a certificate for Microsoft Graph API in HelloID connectors](https://forum.helloid.com/forum/helloid-provisioning/5338-instruction-setting-up-a-certificate-for-microsoft-graph-api-in-helloid-connectors#post5338)

### Connection settings

The following global variables must be configured in HelloID when importing and configuring the delegated form.

| Setting                        | Description                                                              | Mandatory |
| ------------------------------ | ------------------------------------------------------------------------ | --------- |
| EntraIdTenantId                | The unique identifier (ID) of the tenant in Microsoft Entra ID           | Yes       |
| EntraIdAppId                   | The unique identifier (ID) of the App Registration in Microsoft Entra ID | Yes       |
| EntraIdCertificateBase64String | The Base64-encoded string representation of the app certificate          | Yes       |
| EntraIdCertificatePassword     | The password associated with the app certificate                         | Yes       |

## Remarks

- **JWT Token Generation**: The connector uses certificate-based authentication to generate JSON Web Tokens (JWT) for secure communication with Microsoft Graph API. The certificate is converted from a base64 string and used to sign the JWT assertion for OAuth2 authentication.

## Development resources

### API endpoints

The following Microsoft Graph API endpoints are used by the connector:

| Endpoint     | Description |
| ------------ | ----------- |
| /v1.0/users  | List users  |
| /v1.0/groups | List groups |

### API documentation

- [List users](https://learn.microsoft.com/en-us/graph/api/user-list)
- [List groups](https://learn.microsoft.com/en-us/graph/api/group-list)

## Getting help

| :bulb: Tip                                                                                                                                               |
| :------------------------------------------------------------------------------------------------------------------------------------------------------- |
| For more information on Delegated Forms, please refer to our [documentation](https://docs.helloid.com/en/service-automation/delegated-forms.html) pages. |

## HelloID docs

The official HelloID documentation can be found at: https://docs.helloid.com/
