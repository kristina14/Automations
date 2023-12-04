
#Export data from script to CSV and upload to Storage



#Connect to Azure
$cred = Get-AutomationPSCredential -Name 'Outlook365'
connect-azuread -credential $cred

#Select the Subscription and set the storage i need to export to///
Set-AzContext -Subscription $subscriptionID
Set-AzCurrentStorageAccount -ResourceGroupName $ResourceGroupName -Name $storageaccountname

#$users| export-csv -Path:"tempname.csv" -NoTypeInformation -Append


$output = "BLABLA"

$output| export-csv -Path:"tempname.csv" -NoTypeInformation -Append


Set-AzStorageBlobContent -Container $containername -File tempname.csv -Blob "outputname.csv" -Force


