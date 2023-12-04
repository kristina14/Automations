$Cred = Get-AutomationPSCredential -Name 'Outlook365'
Connect-AzAccount -Credential $Cred
Select-AzSubscription -SubscriptionId '04294eda-21ff-4b5a-a2dd-673650a53827'

$resourcename = "WVD-Students"
$hostpoolname = "AZ_WVDI_Enviroments"
$vmgeneralname = "AZ-VDI"

#Get all the sessions in the pool
$sessions = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename 
write-output "sessions = $sessions"

#session = computer (the pool have 12 computers , so in total are 12 sessions)
#the first computer "AZ-VDI-0" is always online 
foreach ($session in $sessions) {

   $countusers = 0
   $status = $session.status
   $vmname = (($session.Name).Split("/")[1]) -replace (".az.technion.ac.il","")
   #count - the same name computer with diferent number
   $id = $id + 1 
   write-output "vmname = $vmname"
  
   write-output "vmnumber = $vmnumber" 
   $session0 = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename -Name "AZ-VDI-$vmnumber.az.technion.ac.il" 
   $usersessions0 = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "AZ-VDI-$vmnumber.az.technion.ac.il"
   write-output "session0 = $session0"
   write-output "usersessions0 = $usersessions0"
   $session = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename -Name "$vmname.az.technion.ac.il" 
   $usersessions = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmname.az.technion.ac.il"
   foreach ($usersession in $usersessions) {
	           
               $idsession = $usersession.name -replace ("$hostpoolname/$vmname.az.technion.ac.il/","")
               $sessionstatus = (Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmname.az.technion.ac.il" -Id $idsession).SessionState
			   write-output "sessionstatus = $sessionstatus"
                if ($sessionstatus -eq "Active") {
				  $countusers = $count + 1
				 write-output "countplus = $countusers"			 
                } 
				
            }
   
	   $vmnumber = [int]$vmnumber	
	   $vmnumber = $vmnumber + 1
	if ($vmnumber -eq 12) {exit}


    if ($countusers -gt 0) {
	   Start-AzVM -ResourceGroupName $resourcename -Name "AZ-VDI-$vmnumber"
	   write-output "Machine $vmnumber was started"
    }
	if (($countusers -eq 0) -and ($vmnumber -gt 0)) {	
	   Stop-AzVM -ResourceGroupName $resourcename -Name "AZ-VDI-$vmnumber" -force 
	   write-output "Machine $vmnumber was stopped"
    }
}