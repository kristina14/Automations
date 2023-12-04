
#fix proxyaddresses


#Credentials
$cred = Get-AutomationPSCredential -Name 'Outlook365 local AD'

########################
#Get all users in Staff - Proxyaddress properties

$users = get-aduser -filter * -SearchBase  "ou=staff,dc=staff,dc=technion,dc=ac,dc=il" -Properties proxyaddresses

#######################
#We need to check if there is more tha 8 X400 Entrys in Proxyaddress Attributte for each  user... 

foreach ($user in $users) {
$px1 = $user.proxyaddresses

 #Count Proxy X400 Address for the user
$pxcount = ($px1 | ? {$_ -like "x400:C=us;A= ;P=Technion;O=Exchange*"}).count

if ($pxcount -gt 8 ) {
    #When there is more than 8 Proxy X400 address i need to delete them.... one one
    $pxdelete = $px1 | ? {$_ -like "x400:C=us;A= ;P=Technion;O=Exchange*"}
    foreach ($proxy in $pxdelete) {
      Write-Output "$proxy was delete for $($user.UserPrincipalName)"
 
      Set-ADUser $user.SamAccountName -Server staff.technion.ac.il -Remove @{proxyaddresses = $proxy} -verbose -Credential $cred
    }
} else {}
}
