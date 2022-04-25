Param([string]$url)
    
try {
    Write-Host "---------"
    Write-Host "url-" $url
    #$responseData = Invoke-WebRequest -Uri $url 
  
    $responseData =Invoke-WebRequest -Uri $url -Method 'GET' -ContentType "application/json" -SkipCertificateCheck 
    
    #Invoke-RestMethod -Uri $url -Method 'GET' -Headers $header
    Write-Host "Content" $responseData.StatusCode
    Write-Host "--------------xxxxx" 
    return [int]$responseData.StatusCode
}
catch {
    Write-Host "err" + $_.Exception
    return [int]$_.Exception.Response.StatusCode
}
