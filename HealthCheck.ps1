Write-Host "Health Check Validation"
function getcall([string]$url) {
    try 
    {
        $responseData = Invoke-WebRequest -Uri $url 
        return [int]$responseData.StatusCode
    }
    catch 
    {
        return [int]$_.Exception.Response.StatusCode
    }
   
}

function callpost([string]$url,[string]$body) {
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
   
}




$configJson = Get-Content ".\config.json" | Out-String | ConvertFrom-Json

$emailContent = @()


ForEach ($values in $configJson.vmList){
    Write-Host $values.name
    $status = $false
    ForEach ($appList in $values.applicationList){
        
        if (($appList.requestType -eq "get") -and ($status -eq $false)) {
            $data1 = getcall $appList.applicationURL
            Write-Host $data1 
            if($data1 -eq 200){
                $status = $true
                $emailContent +=  -join ("VM - " , $values.name," - ",$appList.applicationName," - ",$data1);
            }     
        }
        if (($appList.requestType -eq "post") -and ($status -eq $false)) {
            $data2 = callpost $appList.applicationURL $appList.body
            Write-Host $data2 
            if($data2 -eq 200){
                $status = $true
                $emailContent +=  -join ("VM - " , $values.name," - ",$appList.machineName," - ",$appList.applicationName," - ",$data2);
            }  
        }
    }
}

$body = $emailContent -join "`n"
Write-Host $emailContent

ForEach ($values in $configJson.email){
    & .\SendEmail.ps1 $values.from $values.to $values.cc $values.attachment $values.subject $emailContent $values.config.smtpServer $values.config.smtpPort $values.config.password
}



 


 









