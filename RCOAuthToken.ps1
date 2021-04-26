Function Show-OAuthWindow
{
    param(
        [System.Uri]$Url
    )


    Add-Type -AssemblyName System.Windows.Forms
 
    $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=440;Height=640}
    $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=420;Height=600;Url=($url ) }
    $DocComp  = {
        $global:uri = $web.Url.AbsoluteUri
        if ($Uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocComp)
    $form.Controls.Add($web)
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null

    $uri
}

Function Get-RCOAuth {
	if (-not $RCAuthToken) {
		if ((Get-Date) -gt $RCAuthToken.expire_time) {
		Add-Type -AssemblyName System.Web
		$client_id = "<your client ID>"
		$redirectUrl = "https://app.getpostman.com/oauth2/callback"

		$loginUrl = "https://platform.devtest.ringcentral.com/restapi/oauth/authorize?response_type=token&redirect_uri=" + 
					[System.Web.HttpUtility]::UrlEncode($redirectUrl) + 
					"&client_id=$client_id"
		$Response = Show-OAuthWindow -Url $loginUrl
		$ModUrl = ($Response).Replace("#","&") # hacky workaround to get the method below to properly parse the first key (access_token).
		# Otherwise, the first key/value pair's key name is https://<url>#access_token, which is obviously wrong
		$queryOutput = [System.Web.HttpUtility]::ParseQueryString($ModUrl)
		
		$global:RCAuthToken = @{}
		$RCAuthToken['token_type'] = $queryOutput['token_type']
		$RCAuthToken['access_token'] = $queryOutput['access_token']
		# $RCAuthToken['expires_in'] = $queryOutput['expires_in']
		$expireTime = (Get-Date).AddSeconds($RCAuthToken.expires_in)
		$RCAuthToken.Add('expire_time',$expireTime)
		}
	}
}