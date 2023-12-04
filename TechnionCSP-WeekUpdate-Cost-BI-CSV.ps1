
 
##################################################
###Connect to AzAccount and select the correct Subscriptio
$cred = Get-AutomationPSCredential -Name 'Outlook365'
Login-AzAccount -Credential $cred
Select-AzSubscription -SubscriptionName "Cis-Technion (EA)" 

##################################################
#Params
$Context = get-AzStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv" 

#Import the CSV Source
$filesource = Get-AzStorageBlob -Container "technion-csp-forbi" -Context $Context.Context

$fileimport = Get-AzStorageBlobContent -Container "technion-csp-forbi" -Blob $filesource.Name -Destination:"c:\temp\" -Context $Context.Context  -Force

#$filename = $fileimport.name

$delta = import-csv 'C:\temp\Technion-CSPWeek.csv'

$delta | export-csv C:\temp\CSPFullcostreport.csv -append -NoTypeInformation



####EXPORT (copy to the BLOB)

Set-AzStorageBlobContent -Container "technion-csp-bi" -File "C:\Temp\CSPFullcostreport.csv" -Blob "CSPFullcostreport.csv" -Context $Context.Context  -Force

###Delete File from Source

# Remove-AzStorageBlob -Blob $filesource.Name -Container "technion-department-daily-csv" -Context $context.Context



