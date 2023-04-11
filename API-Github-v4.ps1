
$token = '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'
$token = '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'

$owner = 'Djailz'
$repo  = 'Repo1'
$sha   = $null
$base64token = [System.Convert]::ToBase64String([char[]]$token)

$file = '.\API-Github-v4.ps1'

$path='API-Github-v4.ps1'
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
