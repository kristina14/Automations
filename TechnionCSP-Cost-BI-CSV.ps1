
##################################################
###Connect to AzAccount and select the correct Subscriptio
$cred = Get-AutomationPSCredential -Name 'Outlook365'
Login-AzAccount -Credential $cred
Select-AzSubscription -SubscriptionName "Cis-Technion (EA)" 

##################################################
#Params
$Context = get-AzStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv" 

#Import the CSV Source
$filesource = Get-AzStorageBlob -Container "technion-csp-report-csv" -Context $Context.Context

$fileimport = Get-AzStorageBlobContent -Container "technion-csp-report-csv" -Blob $filesource.Name -Destination:"c:\temp\" -Context $Context.Context  -Force


$filename = $fileimport.name

####EXPORT (copy to the BLOB)

Set-AzStorageBlobContent -Container "technion-csp-forbi" -File "C:\Temp\$filename" -Blob "Technion-CSPWeek.csv" -Context $Context.Context  -Force

###Delete File from Source

Remove-AzStorageBlob -Blob $filesource.Name -Container "technion-csp-report-csv" -Context $context.Context



