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

function Send-Email([string]$from,[string]$to,[string]$cc,[string]$attachment,
[string]$subject,[string]$bodyContent,[string]$smtpServer,[string]$smtpPort,[string]$password) {
    
    $attachmentPath = ".\"+ $attachment
    $body = "<h1>Server Status!</h1><br><br>"
    $body += "<p><strong>First Call:</strong> $bodyContent </p>”
    $secureString = ConvertTo-SecureString $password -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential ($from, $secureString)

    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $creds -Attachments $attachmentPath
}


$configJson = Get-Content ".\config.json" | Out-String | ConvertFrom-Json

$array = @()

ForEach ($values in $configJson.vmList){
    Write-Host xsss  $values.name
    ForEach ($appList in $values.applicationList){

        if ($appList.requestType -eq "get") {
            $data1 = getcall $appList.applicationURL
            $array +=  -join ("1st Endpoint - " , $appList.machineName," - ",$appList.applicationName," - ",$data1);
        }
        if (($appList.requestType -eq "post") -and ($data1 -ne 200 )) {
            $data2 = callpost $appList.applicationURL $appList.body
            $array +=  -join ("2st Endpoint - " ,  $appList.machineName," - ",$appList.applicationName," - ",$data2);
        }
    }
}

$body = $array -join "`n"
Write-Host $body
#Send-Email -bodyContent $body






 









