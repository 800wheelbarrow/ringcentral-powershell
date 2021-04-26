function Get-RCToken {

	 # if we have a token already, refresh it
	 if ($RCAccessToken) { 
		$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$Headers.Add('Authorization','Basic <Base64 of clientid:client secret>')

		$Body = "refresh_token=" + $Global:RCAccessToken.refresh_token + "&grant_type=refresh_token"

		$Global:RCAccessToken = Invoke-RestMethod -Method POST -Headers $Headers -ContentType "application/x-www-form-urlencoded" -Body $Body -Uri "https://platform.ringcentral.com/restapi/oauth/token"
	 }
	 # if not, get a new one. Should this be a separate function?
	 else {

	$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

	# format for authorization information: https://community.ringcentral.com/questions/9482/password-authentication-error-oau-149.html
	$Headers.Add('Authorization','Basic <Base64 of clientid:client secret>')

	$Body = "grant_type=password&username=%2B15555555555&password=yourPWhere&extension=101"

	$Global:RCAccessToken = Invoke-RestMethod -Method POST -Headers $Headers -ContentType "application/x-www-form-urlencoded" -Body $Body -Uri "https://platform.ringcentral.com/restapi/oauth/token"
	}

}