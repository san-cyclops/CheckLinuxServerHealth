Write-Host "Health Check Validation"
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
function getcall([string]$url) {
    try 
    {
        $responseData = Invoke-WebRequest -Uri $url 
        $statusCode = [int]$responseData.StatusCode
        return $statusCode
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
        Write-Host $url
        Write-Host "aa" 
        $responseData = Invoke-RestMethod -Uri $url -Method POST -Body $body -Headers $header
 
        Write-Host "aa"   $responseData
        $statusCode = [int]$responseData.StatusCode
        return $statusCode

    }
    catch 
    {
        return [int]$_.Exception.Response.StatusCode
    }
   
}

function Send-Email([string]$bodyContent) {
    $from = "sanjeewa.senevirathna@mcmedisoft.com"
    $to = "sanjeewa.senevirathna@mcmedisoft.com”
    $cc = "stephan.desilva@mcmedisoft.com"
    $attachment = $scriptPath+"\azureVM.jpg"
    $subject = "Health Check"
    $body = "<h1>Server Status!</h1><br><br>"
    $body += "<p><strong>First Call:</strong> $bodyContent </p>”
    #$body += " <p><strong>Second Call:</strong> $bodyContent2 </p>”
    $smtpServer = "smtp.office365.com"
    $smtpPort = "587"
    $password = ConvertTo-SecureString "Dn5vlPP6" -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential ($from, $password)

    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $creds -Attachments $Attachment
}


$json = Get-Content $scriptPath"\request.json" | Out-String | ConvertFrom-Json

$array = @()

ForEach ($object in $json){
    $responseResult
    
    ForEach ($values in $object.vms){
        Write-Host  $values.machineName
        if ($values.requestType -eq "get") {
            $data1 = getcall -url $values.applicationURL
            $array +=  -join ("1st Endpoint - " , $values.machineName," - ",$values.applicationName," - ",$data1);
            Write-Host $data1
        }
        if (($values.requestType -eq "post") -and ($data1 -ne 200 )) {
            $data2 = callpost -url $values.applicationURL -body $values.body
            $array +=  -join ("2st Endpoint - " ,  $values.machineName," - ",$values.applicationName," - ",$data2);
            Write-Host $data2
        }
        Write-Host "*****************************"
    }
}

$body = $array -join "`n"
Send-Email -bodyContent $body



 









