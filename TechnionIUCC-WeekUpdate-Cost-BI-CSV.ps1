##################################################
###Connect to AzAccount and select the correct Subscriptio
$cred = Get-AutomationPSCredential -Name 'Outlook365'
Login-AzAccount -Credential $cred
Select-AzSubscription -SubscriptionName "Cis-Technion (EA)" 

##################################################
#Params
$Context = get-AzStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv" 

#Import the CSV Source
$filesource = Get-AzStorageBlob -Container "technion-csv-forbi" -Context $Context.Context

$fileimport = Get-AzStorageBlobContent -Container "technion-csv-forbi" -Blob $filesource.Name -Destination:"c:\temp\" -Context $Context.Context  -Force

#$filename = $fileimport.name

$delta = import-csv 'C:\temp\Technion-IUCCWeek.csv'

$delta | export-csv C:\temp\IUCCFullcostreport.csv -append -NoTypeInformation



####EXPORT (copy to the BLOB)

Set-AzStorageBlobContent -Container "technion-iucc-bi" -File "C:\Temp\IUCCFullcostreport.csv" -Blob "IUCCFullcostreport.csv" -Context $Context.Context  -Force

###Delete File from Source

# Remove-AzStorageBlob -Blob $filesource.Name -Container "technion-department-daily-csv" -Context $context.Context



