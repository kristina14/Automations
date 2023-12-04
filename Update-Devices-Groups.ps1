#Connection to AzureAD
$cred = Get-AutomationPSCredential -Name 'Outlook365'
connect-azuread -credential $cred

$adminsunits = Get-AzureADMSAdministrativeUnit -All $true| ? {$_.displayname -like "*Users"} | Sort DisplayName #Get the list of all Administration Unit users
$counterADMS= $null #count total added devices to ADMS Unit
$counterAD= $null #count total added devices to AD Group
$counterRemoveADMS=$null


foreach ($adminunit in $adminsunits) { #1- Admin Unit
  $id = $adminunit.id
  #$id="e3159333-f551-402a-97f9-23cd2b4f735f"

  #$id="a02a40da-604c-4426-8cbb-0226e8a6180c"

  $displayname = $adminunit.displayname
  #$displayname = "Agricultural Engineering Users"
  #$displayname = "Architecture Users"
  #Replace Admin Unit name'User'to 'Devices' in adminsunits List(Arr)
  $adminunitdevices = Get-AzureADMSAdministrativeUnit | ? {$_.displayname -like ($displayname -replace ("Users","Devices"))}
  $devicemembersADMS = $null
  
  #AD Group
  $ADgroupname = $null
  $name= $adminunitdevices.DisplayName
  $ADgroupname= Get-AzureADGroup -all $true | ? {$_.displayname -like $name}  #Get AD group by name
  #$ADgroupid= $ADgroupname.objectid #Get AD group id

  $devicemembersADMS = Get-AzureADMSAdministrativeUnitMember -Id $adminunitdevices.id -all $true | Select Id   #current arr
  $devicemembersADMS = $devicemembersADMS | select @{N="ObjectId";E={$_.Id}}


  $devicemembersAD = Get-AzureADGroupMember -ObjectId $ADgroupname.ObjectId -all $true | Select ObjectId   #current arr
  #$devicemembersAD = $devicemembersAD | select @{N="ObjectId";E={$_.Id}}

  $membersunit = Get-AzureADMSAdministrativeUnitMember -ID $id -all $true | select ID  # Members in ADMS
 

  #$devicemembersNew = New-Object -TypeName System.Collections.Arraylist
  #$devicemembersNew += 'Pink'

  $devicemembersNew= $null #Updated list of Devices for member 
  
  
    foreach ($member in $membersunit){ ##2- Member from Admin Unit
                          $devices=$null
                          $devices = Get-AzureADUserRegisteredDevice -ObjectId $member.id  | Select ObjectId # devices per user
                          if ($devices){ ######Check if member have devices #####
                            
                          foreach ($device in $devices){ ###3- List of Devices of one member

                                                        #Add Device to Administrative Group 
                                                    
                                                        #Add-AzureADMSAdministrativeUnitMember -id $adminunitdevices.id -RefObjectId $device.objectid
                                                        
                                                        #write-output "The device "$($device.displayname)" was added to "$($adminunitdevices.displayname)""
                                                        [PSObject[]] $devicemembersNew += ($device)
                                                         # $devicemembersNew += @($device | Select ObjectTd)     
                                                                                                                 
                                        }
                      }
    }
                      # Check if Device included in Admin Unit Device
                      if($devicemembersNew){
                        ##########################################################
                        ############ ADMS ########################
                      
                        $devstoaddADMS= $null 
                      $devstoaddADMS= $devicemembersNew | Where-Object -FilterScript { $_ -notin $devicemembersADMS } 
                      $devstoaddADMS= (Compare-Object $devicemembersNew.ObjectId $devicemembersADMS.ObjectId | ?{$_.SideIndicator -eq '<='})

                      $devstoremoveADMS= (Compare-Object $devicemembersNew.ObjectId $devicemembersADMS.ObjectId | ?{$_.SideIndicator -eq '=>'})

                      ###Add Devices to ADMS
                       if($devstoaddADMS){
                         foreach($devtoadd in $devstoaddADMS){
                          Add-AzureADMSAdministrativeUnitMember -Id $adminunitdevices.id -RefObjectId $devtoadd.InputObject
                           #$devid= $devtoadd.ObjectId
                            write-output  " $($devtoadd.InputObject) was added to ADMS $($adminunitdevices.DisplayName) "
                            $counterADMS++
                        
                      } 
                      write-output  "Total : $($counterADMS) devices was added to ADMS  "
                      }
                      
                      ###Remove Devices from ADMS
                      if($devstoremoveADMS){
                        foreach($devtoremADMS in $devstoremoveADMS){                
                         Remove-AzureADMSAdministrativeUnitMember -Id $adminunitdevices.id -MemberId $devtoremADMS.InputObject
                          #$devid= $devtoremADMS.ObjectId
                           write-output  " $($devtoremADMS.InputObject) was Removed from ADMS  $($adminunitdevices.DisplayName) "
                           $counterRemoveADMS++
                       
                     }
                     write-output  "Total : $($counterRemoveADMS) devices was Removes from ADMS  $($adminunitdevices.DisplayName) "
                     }

                
                      ################################################################
                    ###################  AD ######################
                      #Check if Devices included in AD Group
                      
                      $devstoaddAD= $null 
                      $devstoaddAD= $devicemembersNew | Where-Object -FilterScript { $_ -notin $devicemembersAD } 
                      $devstoaddAD= (Compare-Object $devicemembersNew.ObjectId  $devicemembersAD.ObjectId | ?{$_.SideIndicator -eq '<='})

                      $devstoRemoveAD=$null
                      $devstoRemoveAD= (Compare-Object $devicemembersNew.ObjectId  $devicemembersAD.ObjectId | ?{$_.SideIndicator -eq '=>'})

                          ###Add Devices to AD
                            if($devstoaddAD){
                              foreach($devtoaddAD in $devstoaddAD){
                                $devtoaddADId= $devtoaddAD.InputObject
                                Add-AzureADGroupMember -ObjectId $ADgroupname.ObjectId -RefObjectId $devtoaddADId #add device to ADgroup
                                write-output "The device $($devtoaddAD.InputObject) was added to AD $($adminunitdevices.DisplayName) "
                                $counterAD++
                          }
                          write-output " Total : $($counterAD) devices was added to AD Group $($adminunitdevices.DisplayName) "
                          }
                          
                            
                          ####Devices to remove from AD Group
                          if($devstoRemoveAD){
                            foreach($devtoremAD in $devstoRemoveAD){
                              $idDevToRemove= $devtoremAD.InputObject
                              write-output " Id removed : $idDevToRemove "
                              Remove-AzureADGroupMember -ObjectId $ADgroupname.ObjectId -MemberId $idDevToRemove #Remove device from ADgroup
                             # $devid= $devtoremAD.ObjectId
                              write-output "The device $($devtoremAD.InputObject) was Removed from AD Group $($adminunitdevices.DisplayName) "
                              $counterRemoveAD++
                        }
                        write-output " Total : $($counterRemoveAD) devices was removed from AD Group $($adminunitdevices.DisplayName) "
                        }

                  }
                  }

                