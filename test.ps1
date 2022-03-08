$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Host "path -"$scriptPath


$json = Get-Content $scriptPath"\request.json" | Out-String | ConvertFrom-Json

ForEach ($User in $json){
    #"User: {0}" -f $User.vms

    ForEach ($Role in $User.vms){
        Write-Host  $Role.machineName
    }
}


#foreach ($i in $json.PSObject.Properties){
#      write-host $i.name #"-" $i.value 
#}



#foreach ($obj in $json.PSObject.Properties) {
#    $obj.Name
#    $obj.Value
#}