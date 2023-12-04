Select-AzSubscription -SubscriptionId 'e72ba568-8ff8-438f-88e6-12324e4cddc8'

Set-AzCurrentStorageAccount -StorageAccountName:"studvdistorage"  -ResourceGroupName:"cis-storages"


$Studprofiles = Get-AzStorageFile -ShareName studvdiprofile
$date = (get-date).AddMonths(-6)

foreach ($studprofile in $studprofiles) {
   $filename = ($studprofile.name).Split("_")[0]
    $file = Get-AzStorageFile -ShareName "studvdiprofile" -Path "$($studprofile.name)/Profile_$filename.VHDX"
    if ($date -lt $file.LastModified.Date)
    {Write-Output "will no delete" } else {Write-Output "will delete"
                                           #$file | Remove-AzStorageFile}
}
}