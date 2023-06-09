﻿
$owner = 'Djailz'
$repo  = 'Repo1'
$sha   = $null

$base64token='Z2hwX0xtaTZvY3dDSGR2SXFOM2pzWGNzS2x5VTBSTm9TQzAxamRRcA=='

$file = '.\API-Github-v5.ps1'

$path='API-Github-v5.ps1'
$message='Intune Hash'

$body = @{
        message = $message
        content = [convert]::ToBase64String((Get-Content $file -Encoding Byte))
        sha = $sha
    } | ConvertTo-Json

$headers = @{
        Authorization = 'Basic {0}' -f $base64token
    }
    
Invoke-RestMethod -Headers $headers -Uri https://api.github.com/repos/$owner/$repo/contents/$path -Body $body -Method Put
