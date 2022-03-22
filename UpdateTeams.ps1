
$message = $args[1]
$title = $args[0]

$JSONBody = [PSCustomObject][Ordered]@{
    "@type"      = "MessageCard"
    "@context"   = "<http://schema.org/extensions>"
    "summary"    = "$($title)"
    "themeColor" = '0078D7'
    "title"      = "$title" #Databasename - from - VM name
    "text"       = "<pre>$message)</pre>"
}
    
$TeamMessageBody = ConvertTo-Json $JSONBody
    
$parameters = @{
    "URI"         = "https://mcmedisoft.webhook.office.com/webhookb2/4c82e0c8-94e7-47c8-af39-66f6d43013f2@da61d295-318e-423e-9958-f2fbb0538f98/IncomingWebhook/338b4be93fa9458b8a5706b9a770bf9e/264680c0-a853-4195-871d-336e4c2a16d8"
    "Method"      = 'POST'
    "Body"        = $TeamMessageBody
    "ContentType" = 'application/json'
}
    
Invoke-RestMethod @parameters
