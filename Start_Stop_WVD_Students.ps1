

$Cred = Get-AutomationPSCredential -Name 'Outlook365'
Connect-AzAccount -Credential $Cred 
Select-AzSubscription "CIS-Technion (EA)"

$resourcename = "WVD-Students"
$hostpoolname = "WVDI_Host_Pool_EA"
$vmgeneralname = "CIS-Stud"

#Get all the sessions in the pool
$sessions = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename 


#session = computer (the pool have 4 computers , so in total are 4 sessions)
#the first computer "vdistud-0" is always online 
foreach ($session in $sessions) {
   
   $status = $session.status
   $vmname = (($session.Name).Split("/")[1]) -replace (".staff.technion.ac.il","")
   #count - the same name computer with diferent number
   $id = $id + 1 

   ########################################
   #for the first session (computer) check only if is disconnected sessionuser 
   if ($VMname -eq "CIS-Stud-0") { 
       
         $session0 = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename -Name "CIS-Stud-0.staff.technion.ac.il" 
         $usersessions0 = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "CIS-Stud-0.staff.technion.ac.il"
         foreach ($usersession0 in $usersessions0) {
         $idsession0 = $usersession0.name -replace ("$hostpoolname/CIS-Stud-0.staff.technion.ac.il/","")
         $sessionstatus0 = (Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "CIS-Stud-0.staff.technion.ac.il" -Id $idsession0).SessionState
         if ($sessionstatus0 -eq "Active") {
            
                } elseif ($sessionstatus0 -eq "Disconnected") {
				#remove the sessionuser disconnected 
                  Remove-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "CIS-Stud-0.staff.technion.ac.il" -Id $idsession0
                  write-output  "Session $idsession0 in CIS-Stud-0.staff.technion.ac.il was logoff"

                }; 
                  $id = 0}
            }
    #################################
     #from the second computer will check if there is Active Sessions in each computer VDI 
	 #in addtion i check what is the pre-vdisession : for example
	  #
     else { 
        #check the number of sessionuser active in the VM
        $session = Get-AzWvdSessionHost -HostPoolName $hostpoolname -ResourceGroupName $resourcename -Name "$vmname.staff.technion.ac.il" 
        $usersessions = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmname.staff.technion.ac.il"
        $count = 0
             foreach ($usersession in $usersessions) {
               $idsession = $usersession.name -replace ("$hostpoolname/$vmname.staff.technion.ac.il/","")
               $sessionstatus = (Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmname.staff.technion.ac.il" -Id $idsession).SessionState
                if ($sessionstatus -eq "Active") {
                 $count =  1
                    } elseif ($sessionstatus -eq "Disconnected") {
                      Remove-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmname.staff.technion.ac.il" -Id $idsession
                      write-output "Session in $vmname.staff.technion.ac.il was logoff"

                    } 
                    else {}
             }

		################################
		#pred is for check what is the situacion in the VDI i 	 
        $preid = $id -1 
        $previusVMsessions = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmgeneralname-$Preid.staff.technion.ac.il"

             $countforstart = 0
             foreach ($previusVMsession in $previusVMsessions) {
               $idsession = $previusVMsession.name -replace ("$hostpoolname/$vmgeneralname-$Preid.staff.technion.ac.il/","")
               $presessionstatus = (Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName "$vmgeneralname-$Preid.staff.technion.ac.il" -Id $idsession).SessionState

                if ($presessionstatus -eq "Active") {
                 $countforstart = $countforstart + 1
                    } 
                    
                    else {}
              }
        if (($countforstart -gt 0) -and ($status -eq "Unavailable")) {
              Start-AzVM -ResourceGroupName $resourcename  -Name $vmname 
              write-output "VM $vmname was Started"
                   } 
        if (($countforstart -eq "0")-and ($status -eq "Available") -and ($count -eq "0")) { 
              Stop-AzVM -ResourceGroupName $resourcename -Name $vmname -force
                            write-output "VM $vmname was Stopped"

                   }
        


     }
}    
