Param([string]$url)
    
try 
{
    $responseData = Invoke-WebRequest -Uri $url 
    return [int]$responseData.StatusCode
}
catch 
{
    return [int]$_.Exception.Response.StatusCode
}
