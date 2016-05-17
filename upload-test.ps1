$token = $env:gh_token
$uploadFilePath = "$env:appveyor_build_folder\test.zip"
$releaseName = "v$env:appveyor_build_version"

$headers = @{
  "Authorization" = "token $token"
  "Content-type" = "application/json"
}

$body = @{
  tag_name = $releaseName
  target_commitish = "master"
  name = $releaseName
  body = "Description of the release"
  draft = $false
  prerelease = $false
}

Write-Host "Creating release..." -NoNewline
$json = (ConvertTo-Json $body)
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/FeodorFitsner/aaa1/releases' -Headers $headers -Method POST -Body $json
$uploadUrl = $release.upload_url.Replace("{?name,label}", "") + "?name=" + [IO.Path]::GetFileName($uploadFilePath)
Write-Host "OK" -ForegroundColor Green

$uploadUrl

Write-Host "Uploading asset..." -NoNewline
$data = [System.IO.File]::ReadAllBytes($uploadFilePath)
$wc = New-Object Net.WebClient
$wc.Headers['Content-type'] = 'application/octet-stream'
$wc.Headers['Authorization'] = "token $token"
$response = $wc.UploadData($uploadUrl, "POST", $data)
#Write-Host "OK" -ForegroundColor Green
