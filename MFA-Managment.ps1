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

if ($email -like "*@*") {} else {$email = $email+"@technion.ac.il" }


$adminunitIDs = $null


if ($question1 -like "Check*") {
  $check = get-msoluser -UserPrincipalName $email | select StrongAuthenticationRequirements
  if ($check.StrongAuthenticationRequirements) { write-output "The MFA is Enabled for $email"} else {write-output "The MFA is Disabled for $email"} 
    }


  
   
      #Free for Campus
     if ($email -like "*@campus.technion.ac.il") {

      if ($question1 -like  "Enable*"){

        $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
        $st.RelyingParty = "*"
        $st.State = "Enforced"
        $sta = @($st)
        Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements $sta
        write-output "Enabled MFA for $email was completed"
        }
    
    if ($question1 -like "Reset*"){
        Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email
        write-output "Reset MFA for $email was completed"
        }
    
    
    if ($question1 -like "Disable*"){
       #Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements @()
       #Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email
    
       write-output "You are not Able to Disable MFA for $Email"
       }
    
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

                   if ($question1 -like "Reset*"){
         Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email
         write-output "Reset MFA for $email was completed"
                              }


            if ($question1 -like "Disable*"){
          #Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements @()
           #Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $email

                write-output "You are not Able to Disable MFA for $Email"
             }
            }

  else {write-output "The User $email is out of your scope or Incorrect Name"
                              
                      }
  }
else {write-output "The User $usermanagement do not have permission for this action"}
        

  }



  