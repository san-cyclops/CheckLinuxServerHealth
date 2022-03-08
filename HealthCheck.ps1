Write-Host "Health Check Validation"





$machineName1 = "VM-1" #$args[1]
$applicationName1 = "keycloak" #keycloak Env
$applicationURL1 = "https://reqbin.com/echo/get/json" #

$endpointType 

$machineName2 = "VM-2"
$applicationName2 = "dashboard" #Reporting Env 
$applicationURL2 = "https://reqbin.com/echo/post/json" #
$body2 = @{ 
  Id= 78912
  Customer= "Jason Sweet"
  Quantity= 1
  Price= 18.00
}

function getcall([string]$url) {
    try 
    {
        $responseData = Invoke-WebRequest -Uri $url 
        Write-Host "responseData" $responseData
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
        Write-Host "-----"
        Write-Host "2nd endpoint-"  $url
      
        $responseData = Invoke-RestMethod -Method 'Post' -Uri $url -Body $body
        $statusCode = [int]$responseData.StatusCode
        $result = $responseData | ConvertFrom-Json
        Write-Host "text" + $result
        return $statusCode

    }
    catch 
    {
        return [int]$_.Exception.Response.StatusCode
    }
   
}

function Send-Email([string]$bodyContent1,[string]$bodyContent2) {
    $From = "sanjeewa.senevirathna@mcmedisoft.com"
    $To = "sanjeewa.senevirathna@mcmedisoft.com”
    $Cc = "stephan.desilva@mcmedisoft.com"
    $Attachment = "C:\Users\SanjeewaSenevirathna\Pictures\800px_COLOURBOX11070263.jpg"
    $Subject = "Health Check"
    $Body = "<h1>Server Status!</h1><br><br>"
    $Body += "<p><strong>First Call:</strong> $bodyContent1 </p>”
    $Body += " <p><strong>Second Call:</strong> $bodyContent2 </p>”
    $SMTPServer = "smtp.office365.com"
    $SMTPPort = "587"
    $mypasswd = ConvertTo-SecureString "Dn5vlPP6" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("sanjeewa.senevirathna@mcmedisoft.com", $mypasswd)

    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject 
                    -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort 
                    -UseSsl -Credential $mycreds -Attachments $Attachment
}
 
$json = Get-Content $scriptPath"\request.json" | Out-String | ConvertFrom-Json

ForEach ($User in $json){
    #"User: {0}" -f $User.vms

    ForEach ($Role in $User.vms){
        Write-Host  $Role.machineName
    }
}




$data1 = getcall -url $ApplicationURL1

Write-Host ConvertFrom-JsonNewtonsoft $data1

$responseResult1 =  -join ("1st Endpoint - " , $MachineName1," - ",$ApplicationName1," - ",$data1);
Write-Host $responseResult1
Start-Sleep -s 2

#if validate status = false {

$data2 = callpost -url $ApplicationURL2 -body $Body2
$responseResult2 =  -join ("2st Endpoint - " , $MachineName2," - ",$ApplicationName2," - ",$data2);
Write-Host $responseResult2
Start-Sleep -s 2

#}

responseResult = 

Send-Email -bodyContent1 $responseResult1 -bodyContent2 $responseResult2
 

 









