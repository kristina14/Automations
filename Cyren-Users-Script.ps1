#Credentials
$cred =  Get-AutomationPSCredential -Name 'Outlook365 local AD'

#List of Members of the Group "Cyren USers" in AD 
$current = (Get-ADGroup "Cyren Users" -server staff.technion.ac.il -Properties members).members

#Remove all Members of the Group 
Remove-ADGroupMember -server staff.technion.ac.il -Identity "Cyren Users" -Members $current -confirm:$false -credential $cred

#Get all memebers users (Segel) 
$faculty = Get-ADUser -credential $cred -server staff.technion.ac.il -Properties employeetype,eduPersonPrimaryAffiliation -Filter {eduPersonPrimaryAffiliation -eq "faculty" -and employeetype -like "Technion Academic staff*"} 

#Get all employees members from Staff (Workers and Mosad)
$staff = Get-ADUser -credential $cred -server staff.technion.ac.il -Properties employeetype,eduPersonPrimaryAffiliation -Filter {eduPersonPrimaryAffiliation -eq "staff" -and (employeetype -eq "Technion Non Academic Staff" -or employeetype -eq "mosad")}
$cyrenusers = $faculty +$staff


#Add all memebers to the group
Add-ADGroupMember -server staff.technion.ac.il -Identity "Cyren Users" -Members $cyrenusers -credential $cred
