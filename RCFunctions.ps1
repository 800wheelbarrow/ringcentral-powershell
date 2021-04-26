
function Get-RCAccountInfo {
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

	Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri "https://platform.ringcentral.com/restapi/v1.0/account/~"

}

function Get-RCContacts {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
    throw "This won't work because the app doesn't have the proper permissions."
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

	$Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/address-book/contact?page=1&perPage=100"
	Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri

}

function Get-RCExtension {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result
	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri

	$Response
}

function Get-RCExtensionPhoneNumber {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/phone-number?usageType=DirectNumber"
	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri

	$Response.records
}

function Get-RCExtensionForwarding {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
    $Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/forwarding-number"
	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri

	$Response.records

}

function Set-RCExtensionForwarding {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension,
	
	[Parameter(ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$ForwardTo
)

if ($Extension) {
    $Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	$forwardingNumber = (Get-RCExtensionPhoneNumber -Extension $ForwardTo).phoneNumber
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))
	$Headers.Add('Accept','application/json')

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/forwarding-number"
	
	$Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Body.Add('phoneNumber',$forwardingNumber)
	$Body.Add('label','Forwarding')
	$JsonBody = ConvertTo-Json $Body

	$Response = Invoke-RestMethod -Method POST -Headers $Headers -ContentType "application/json" -Uri $Uri -Body $JsonBody

	$Response

}

function Unset-RCExtensionForwarding {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
    $Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	$forwardingId = (Get-RCExtensionForwarding -Extension $Extension | where label -eq "Forwarding").id
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/forwarding-number/" + $forwardingId

	$Response = Invoke-RestMethod -Method DELETE -Headers $Headers -ContentType "application/json" -Uri $Uri

	$Response

}

function Get-RCExtensionList {
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri "https://platform.ringcentral.com/restapi/v1.0/account/~/extension"

	$Response.records
}

function Get-RCPhoneNumbers {
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri "https://platform.ringcentral.com/restapi/v1.0/account/~/phone-number"

	$Response.records
}

function Get-RCDevices {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension
)

if ($Extension) {
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/device"
	(Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri).records

}

function Get-RCCallLog {
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension,
	
	[Parameter(ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$PhoneNumber
)

if ($Extension) {
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))
	$Headers.Add('Accept','application/json')

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Result + "/call-log?showBlocked=true&view=Simple&withRecording=false&page=1&perPage=100&showDeleted=false"
	#?view=Simple&phoneNumber=" + $phoneNumber + "&recordingtype=all"
	$Response = Invoke-RestMethod -Method GET -Headers $Headers -ContentType "application/json" -Uri $Uri

	$Response
}

function Get-RCCallRecording {
	# needs work!
param (

	[Parameter(ValueFromPipelineByPropertyname)]
	#[ValidateNotNullOrEmpty()]
	$Extension,
	
	[Parameter(ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$PhoneNumber
)

if ($Extension) {
	$Result = Search-RCExtension -Search $Extension
}
else {
	$Result = "~"
}
	Get-RCToken
	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

    $Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/recording/7436637005/content"
	Invoke-RestMethod -Method GET -Headers $Headers -ContentType "audio/x-wav" -Uri $Uri -OutFile recording.wav

}

function Disable-RCExtension {

param (

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$Extension
)

Get-RCToken
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))
$Headers.Add('Accept','application/json')

$Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Extension

$Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Body.Add('status','Disabled')
$JsonBody = ConvertTo-Json $Body

Invoke-RestMethod -Method PUT -Headers $Headers -ContentType "application/json" -Uri $Uri -Body $JsonBody
}

function Enable-RCExtension {

param (

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$Extension
)

Get-RCToken
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))
$Headers.Add('Accept','application/json')

$Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Extension

$Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Body.Add('status','Enabled')
$JsonBody = ConvertTo-Json $Body

Invoke-RestMethod -Method PUT -Headers $Headers -ContentType "application/json" -Uri $Uri -Body $JsonBody
}

function Edit-RCExtension {
#### Not working. FirstName parameter is invalid???
param (

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$Extension,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$firstName,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$lastName
)

Get-RCToken
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))
$Headers.Add('Accept','application/json')

$Uri = "https://platform.ringcentral.com/restapi/v1.0/account/~/extension/" + $Extension

# $Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
# $Body.Add('firstName','Edited')
# $Body.Add('lastName','By API')
# $JsonBody = ConvertTo-Json $Body

$JsonBody = ConvertTo-Json -Depth 2 @{"contact" = @{"firstName" = $firstName; "lastName" = $lastName}}

Invoke-RestMethod -Method PUT -Headers $Headers -ContentType "application/json" -Uri $Uri -Body $JsonBody
}

function Search-RCExtension {

param (

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$Search
)
Get-RCToken
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))

$Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Body.Add('searchString', $Search)
$JsonBody = ConvertTo-Json $Body

$search = Invoke-RestMethod -Method POST -Headers $Headers -ContentType "application/json" -Body $JsonBody -Uri "https://platform.ringcentral.com/restapi/v1.0/account/~/directory/entries/search"

return $search[0].records.id
}

function Create-RCExtension {

param (

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$firstName,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$lastName,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	$email
)
Get-RCToken
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',($RCAccessToken.token_type + " " + $RCAccessToken.access_token))


$JsonBody = ConvertTo-Json -Depth 2 @{"contact" = @{"firstName" = $firstName; "lastName" = $lastName; "email" = $email}; "type" = "User"}

#$result = 
Invoke-RestMethod -Method POST -Headers $Headers -ContentType "application/json" -Body $JsonBody -Uri "https://platform.ringcentral.com/restapi/v1.0/account/~/extension"

# return $result
}