$accountName = "ciscostcsv"
$accountKey = "Fg5CTX9L1C9jB3GyEejFn4xyUsCnfo8So8hxyRxnTe/Tgk8gnDmiGO+nxmRMKPAbyRWF/4gmQu3s4A0bPN9BZw=="
$containerName = "technion-spanning"
$blobName = "spanning-assignedUsers.csv"

# Get storage context
$context = New-AzStorageContext -StorageAccountName $accountName -StorageAccountKey $accountKey

Set-AzCurrentStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv"

# Get Shared Access Signature (SAS) Token expiration time. e.g. set to expire after 1 hour:
#$sasExpiry = (Get-Date).AddHours(1).ToUniversalTime()

# Get a SAS Token with "write" permission that will expire after one hour.
#$sasToken =  New-AzStorageBlobSASToken -Context $context -Container $containerName -Blob $blobName -Permission "w" -ExpiryTime $sasExpiry

# Create a SAS URL
#$sasUrl = "https://$accountName.blob.core.windows.net/$containerName/$blobName$sasToken"

# Set request content (body)
Import-Module C:\SpanningO365
Get-SpanningAuthentication -ApiToken "517beb34-846a-48c4-88e1-15d6a7833f6d" -Region EU -AdminEmail shayol@technion.ac.il
$users= get-spanningassignedusers
#$users | convertto-csv
$users | export-csv C:\temp\Spanning\AssignedUsers.csv -NoTypeInformation 

#Invoke "Put Blob" REST API

#Invoke-RestMethod -Method "PUT" -Uri $sasUrl -Body $users -Headers $headers -ContentType "text/csv"

#Remove-AzStorageBlob -Blob 'AssignedUsers.csv' -container $containerName -Context $context.Context


<#
#Export file to blob
Set-AzStorageBlobContent -Container $containerName -File 'C:\temp\Spanning\AssignedUsers.csv' -Blob "AssignedUsers.csv" -Force
#>

<#
Set-AzStorageBlobContent -File "C:\temp\Spanning\AssignedUsers.csv" -Container $containerName -Blob "AssignedUsers.csv" `
  -Context $context `
  -StandardBlobTier Hot -Force

#>

Set-AzStorageBlobContent -Container $containerName -File "C:\temp\Spanning\AssignedUsers.csv" -Blob "AssignedUsers.csv" -Force

