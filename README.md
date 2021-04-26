# ringcentral-powershell
PowerShell scripts to administer RingCentral using REST

RCGetToken.ps1 - change username and password to the appropriate values. Set authorization header to base64 encoded version of clientID:clientSecret from RC portal. 
OAuth authentication/token can be used if the function name is changed to match the one used in the scripts (Get-RCToken) and the existing password flow one is renamed to something else.
URIs all point to production and would need to be changed to point to the sandbox if necessary.