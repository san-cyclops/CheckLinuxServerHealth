﻿Write-Host "Health Check Validation"


$MachineName1 = "VM-1" #$args[1]
$ApplicationName1 = "keycloak" #keycloak Env
$ApplicationURL1 = "https://reqbin.com/echo/get/json" #
$ReqType1 = "GET"

$MachineName2 = "VM-2"
$ApplicationName2 = "dashboard" #Reporting Env 
$ApplicationURL2 = "https://reqbin.com/echo/get/json" #
$ReqType2 = "POST"
$Body2 = @{ 
  Id= 78912
  Customer= "Jason Sweet"
  Quantity= 1
  Price= 18.00
}


 

Write-Host $ApplicationURL1

$data1 = Get-Data -url $ApplicationURL1
$dataToDict1 =  -join ($MachineName1," - ",$ApplicationName1," - ",$data1);
Write-Host $dataToDict1
Start-Sleep -s 2

$data2 = Get-Data -url $ApplicationURL2 -body $Body2
Write-Host $MachineName2 "-" $ApplicationName2 "-" $data2
Start-Sleep -s 2

$emailText = -join ($data1 , $data2)

Send-Email $emailText
#Invoke-WebRequest -Uri $ApplicationURL1 -Method Get
#Write-Host $dataToDict |  Format-Table -Property Title, pubDate

#Send-MailMessage -From 'User01 <sanjeewa.senevirathna@mcmedisoft.com>' -To 'User02 <sancyclops@gmail.com>' -Subject $ApplicationName1 + "is not accessbile on " + $MachineName1
#Send-Email -Body "test"


function Get-Data([string]$url) {
    try 
    {
        $responseData = Invoke-WebRequest -Uri $url 

        $result = ConvertFrom-Json -InputObject $responseData.Content


        return $result

    }
    catch 
    {
        throw $_
    }
   
}


function Post-Data([string]$url,[string]$body) {
    try 
    {
        Write-Host $url
      

        # Step 4. Make the POST request
        $responseData = Invoke-RestMethod -Method 'Post' -Uri $url -Body $body
        $result = ConvertFrom-Json -InputObject $responseData.Content
        return $result

    }
    catch 
    {
        throw $_
    }
   
}

function Send-Email([string]$Body) {
    $From = "sanjeewa.senevirathna@mcmedisoft.com"
    $To = "sancyclops@gmail.com”
    $Cc = "stephan.desilva@mcmedisoft.com"
    $Attachment = "C:\Users\SanjeewaSenevirathna\Pictures\800px_COLOURBOX11070263.jpg"
    $Subject = "Photos of Drogon"
    $Body = "<h2>Guys, look at these pics of Drogon!</h2><br><br>"
    $Body += “He is so cute!”
    $SMTPServer = "smtp.office365.com"
    $SMTPPort = "587"
    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment
}










