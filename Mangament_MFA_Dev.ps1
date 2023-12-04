Param
(
  [Parameter (Mandatory= $true)]
  [string] $Email,

  [Parameter (Mandatory= $true)]
  [string] $Question1,
   
  [Parameter (Mandatory= $true)]
  [string] $UserManagement
  

)


$Cred = Get-AutomationPSCredential -Name "Outlook365";
Connect-MSOLService -Credential:$Cred;

$credAD = Get-AutomationPSCredential -Name 'Outlook365 for AD'

if ($email -like "*@*") {} else {$email = $email+"@technion.ac.il" }


$adminunitIDs = $null


Function RandomPassword() {
    $pw = ""
    $pw += ([char[]]"ABCDEFGHIJKLMNOPQRSTUVWXYZ" | Get-Random)
    $pw += $(1..4 | % { [char[]]"abcdefghijklmnopqrstuvwxyz" | Get-Random }) -join ""
    $pw += $(1..8 | % { [char[]]"0123456789" | Get-Random }) -join ""
    Return $pw
}

if ($question1 -like "Check*") {
  $check = get-msoluser -UserPrincipalName $email | select StrongAuthenticationRequirements
  if ($check.StrongAuthenticationRequirements) { write-output "The MFA is Enabled for $email"} else {write-output "The MFA is Disabled for $email"} 
     Exit
    } 
    
   
      #Free for Campus + Alumni _ Retired
     if (($email -like "*@campus.technion.ac.il") -or ($email -like "*@alumni.technion.ac.il") -or ($email -like "*@g.technion.ac.il")) {
        $checkupn = get-msoluser -UserPrincipalName $email
        if ($checkupn) {
      if ($question1 -like  "Enable*"){

        $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
        $st.RelyingParty = "*"
        $st.State = "Enforced"
        $sta = @($st)
        Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements $sta
        write-output "Enabled MFA for $email was completed"
        }
    
    if ($question1 -like "MFA*"){
        Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email
        write-output "MFA Settings reset for $email was completed"
        }
    
    
    if ($question1 -like "Reset*"){
        $pwt = RandomPassword
        $account = $Email.Substring(0, $email.lastIndexOf('@'))
        Set-ADAccountPassword $account -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$pwt" -Force -Verbose) -PassThru  -Credential $credAD | out-null
        set-aduser -Identity $account -ChangePasswordAtLogon $true -Credential $credAD 

        $phone = (get-aduser -Identity $account -Properties cellphone -Credential $credAD | select cellphone).cellphone 
       
        if ($phone){
        Send-MailMessage -From cis-account@technion.ac.il -to "$phone@sms.inforu.co.il" -Subject "Hello, your new password is  '$($pwt)' , please wait 30 minutes to login, You will need to change your password at the next login" -SmtpServer tx.technion.ac.il 
        write-output "The new Password for $Email : $pwt , SMS was send to  $phone"

        } else  {  write-output "The new Password for $Email : $pwt , No Phone number found ,please wait 30 minutes for login."}


       }
     } else { write-output "The User $Email not Exist or UPN is incorrect"}

      } else {


##Check Admin Unit Permission
            $useradmin = get-msoluser -UserPrincipalName $UserManagement | select objectid,displayname
            $permission = "no"
            $adminunits = Get-MsolAdministrativeUnit | select ObjectId,displayname

    foreach ($adminunit in $adminunits) {

    $unit =  Get-MsolScopedRoleMember -RoleObjectId "fe930be7-5e62-47db-91af-98c3a49a38b1" -AdministrativeUnitObjectId $adminunit.ObjectId | select userprincipalname,objectid

   if ($unit -match $useradmin.ObjectId.Guid ) {
     Write-Host "The User $usermanagement is part of the " $adminunit.DisplayName
     $permission = "yes"
     [array]$adminunitIDs = [array]$adminunitIDs + $adminunit.ObjectId

                                              }
    }

      if ($permission -eq "yes") {
      foreach ($adminunitid in $adminunitIDs){
     [array]$adminlist = [array]$adminlist + (Get-MsolAdministrativeUnitMember -AdministrativeUnitObjectId $adminunitID.guid -All | select emailaddress)
         }
        
     if ($adminlist -match $email) {

         if ($question1 -like  "Enable*"){

            $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
            $st.RelyingParty = "*"
            $st.State = "Enforced"
            $sta = @($st)
            Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements $sta
            write-output "Enabled MFA for $email was completed"
                                         }

          if ($question1 -like "MFA*"){
            Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email
              write-output "MFA Settings reset for $email was completed"
                              }


            if ($question1 -like "Reset*"){
                $pwt = RandomPassword
                $account = $Email.Substring(0, $email.lastIndexOf('@'))
                set-aduser -Identity $account -ChangePasswordAtLogon $true -Credential $credAD
                Set-ADAccountPassword $account -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$pwt" -Force -Verbose) -PassThru  -Credential $credAD | out-null
        
                $phone = (get-aduser -Identity $account -Properties cellphone -Credential $credAD | select cellphone).cellphone
               
                if ($phone){
                Send-MailMessage -From cis-account@technion.ac.il -to "$phone@sms.inforu.co.il" -Subject "Hello, your new password is  '$($pwt)' , please wait 30 minutes to login, You will need to change your password at the next login" -SmtpServer tx.technion.ac.il
                write-output "The new Password for $Email : $pwt , SMS was send to $phone"
        
                } else  {  write-output "The new Password for $Email : $pwt , No Phone number found ,please wait 30 minutes for login."}
        
                                      
             }
            }

  else {write-output "The User $email is out of your scope or Incorrect Name"
                              
                      }
  }
else {write-output "The User $usermanagement do not have permission for this action"}
        
      
  }
    

    
