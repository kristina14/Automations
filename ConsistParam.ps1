$cred = Get-AutomationPSCredential -Name 'Outlook365'

Connect-azuread -Credential $cred
Connect-AzAccount -Credential $cred


Set-AzContext -Subscription '04294eda-21ff-4b5a-a2dd-673650a53827'

Set-AzCurrentStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv"

#$users= Get-AzureADUser -All $true | select-object userprincipalname, @{n="ID";e={($_.ExtensionProperty).extension_fbd570c48f8d4931af60ce23c654811f_employeeNumber}} | ? ID -ne $null | export-csv -Path:"UsersID.csv"  -NoTypeInformation -Append -Force 
$users= Get-AzureADUser -all $True | select-object userprincipalname, mail, @{n="ID";e={$_.extensionProperty.extension_fbd570c48f8d4931af60ce23c654811f_employeeNumber}} | ? ID -ne $null 
$count =$users.count
write-output "The count is : $count"

#$users| export-csv -Path:"tempname.csv" -NoTypeInformation  -Append
$users| Out-File -FilePath "c:\temp\tempname.txt"  

#Set-AzStorageBlobContent -Container consist -File tempname.csv -Blob "az-users-id.csv" -Force

Set-AzStorageBlobContent -Container consist -File "c:\temp\tempname.txt" -Blob "az-users-id.txt" -Force

#Set-AzureStorageBlobContent -Container consist -File c:\temp\atp\atp-general.csv -blob "Daily-$date.csv" 
