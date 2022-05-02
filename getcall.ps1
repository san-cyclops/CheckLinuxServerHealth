Param([string]$url)
    
try {
    $responseData =Invoke-WebRequest -Uri $url -Method 'GET' -ContentType "application/json" -SkipCertificateCheck 
    Write-Host "Content" $responseData.StatusCode
    return [int]$responseData.StatusCode
}
catch {
    Write-Host "err" + $_.Exception
    return [int]$_.Exception.Response.StatusCode
}
