

$message1 = $args[0]
$message2 = $args[1]

Write-Host  $name

$JSONBody = [PSCustomObject][Ordered]@{
    "@type"      = "MessageCard"
    "@context"   = "<http://schema.org/extensions>"
    "summary"    = "Locked: $($LockedUser.SamAccountName)"
    "themeColor" = '0078D7'
    "title"      = "User locked"
    "text"       = "`n 
    SamAccountName: $message1,
    Content: $message2
    "
}
    
$TeamMessageBody = ConvertTo-Json $JSONBody
    
$parameters = @{
    "URI"         = "https://mcmedisoft.webhook.office.com/webhookb2/06fb8099-0ba8-4489-bdaf-3019f866b30e@da61d295-318e-423e-9958-f2fbb0538f98/IncomingWebhook/4998923144834a9e83efac05c4e433b9/e8f8db86-c7b9-4ed8-b4b4-1aa39bf7e198"
    "Method"      = 'POST'
    "Body"        = $TeamMessageBody
    "ContentType" = 'application/json'
}
    
Invoke-RestMethod @parameters

