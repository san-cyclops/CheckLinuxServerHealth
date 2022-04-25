Write-Host "Health Check Validation"

$configJson = Get-Content ".\config.json" | Out-String | ConvertFrom-Json

$emailContent = @()


ForEach ($values in $configJson.vmList){
    Write-Host $values.name
    $status = $false
    ForEach ($appList in $values.applicationList){
        
        if (($appList.requestType -eq "get") -and ($status -eq $false)) {
            $data1 = & .\getcall.ps1 $appList.applicationURL
            Write-Host $data1 
            if($data1 -eq 200){
                $status = $true
                $emailContent +=  -join ("VM - " , $values.name," - ",$appList.applicationName," - ",$data1);
            }     
        }
        if (($appList.requestType -eq "post") -and ($status -eq $false)) {
            $data2 = & .\postcall.ps1 $appList.applicationURL $appList.body
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
    & .\UpdateTeams.ps1 $values.subject $emailContent
}
 


 


 









