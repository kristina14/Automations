#param : recived the variable from the FORM 
#Add the Email user to the Security Group 'Azure VDI Students - GPU' ; 
#If the User is Alumni will not be add into the group - this service is only for Actives Users in Technion (Campus/staff)
#Logic Apps "AddStudToADVDIGroup"
Param
(
  [Parameter (Mandatory= $true)]
  [string] $Email 


)
 
$cred2 = Get-AutomationPSCredential -Name 'Outlook365 local AD' 


$user = ($Email).Split("@")[0]

if ($email -notlike "*@campus.technion.ac.il" ) {
                                             write-output " $Email was not added"}
else {
Add-ADGroupMember -server staff.technion.ac.il -Identity 'Azure VDI Students - GPU' -Members $user -Credential $cred2
write-output " $Email have been successfully added to the VDI Group"

     }
