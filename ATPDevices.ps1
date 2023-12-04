
$domains = (Get-ADForest).domains + "sap.technion.ac.il"| sort
$date =(get-date).AddDays(-60)
foreach ($domain in $domains) { 
$comps = Get-ADComputer -Filter {LastLogonDate -gt $date} -Properties LastLogonDate,OperatingSystem -Server $domain
$info = foreach ($comp in $comps) { 
Get-MDATPDevice -DeviceName $comp.DNSHostName | sort lastseen | select -Last 1 |select computerDnsName,@{n="IP";e={if ($_.lastExternalIpAddress -notlike "*.*"){$_.lastIpAddress}else{$_.lastExternalIpAddress}}},onboardingStatus,lastSeen,osPlatform,@{n="tags";e={$_.machineTags}},@{n="Domain";e={$domain}}}

#Start-Sleep -Seconds 1

$count= $info.count

write-output "The count is : $count"

$info| sort tags,computerDnsName | export-csv C:\temp\Defender-Devices.csv -NoClobber -NoTypeInformation -Append

}

