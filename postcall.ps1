Param([string]$url,[string]$body)
    
try 
{
    $header = @{
        "Accept"="application/json"
        "Content-Type"="application/json"
    } 
    $responseData = Invoke-RestMethod -Uri $url -Method POST -Body $body -Headers $header
    return [int]$responseData.StatusCode
}
catch 
{
    return [int]$_.Exception.Response.StatusCode
}
   
