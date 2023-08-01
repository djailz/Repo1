$owner = 'Djailz'
$repo  = 'Repo1'
$sha   = $null

$base64token='Z2hwX25VVzQxVjdSQlVHUTduakM5cFRSU0NjMWk3Rmc1VTFsd0ppNg=='

# Source
$file = '.\API-Github-v7.ps1'

# Destination on Github
$path='API-Github-v7.ps1'
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