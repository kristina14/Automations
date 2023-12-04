
#Credentials

$psCred = Get-AutomationPSCredential -Name 'Outlook365'
$adpr = Get-AutomationPSCredential -Name 'Outlook365 local AD'
Connect-ExchangeOnline -Credential $psCred 

#############################################
#Map the Drive from Sapftp

New-PSDrive -Name "P" -Root "\\sapftp.sap.technion.ac.il\hr$\TDP\PHONEBOOK\Pictures"  -PSProvider  "FileSystem" -Credential $adpr -Persist
$path = 'p:\'
$csvpath = "$PATH" + "Pictures.csv"

############################################
#Import the CSV

$csv = import-csv $csvpath

############################################
#Edit the Picture File , split after .jpg to read only the ID 

$picsnames=(Get-ChildItem -Path $path | ? name -like "*.jpg" -ErrorAction SilentlyContinue|sort).name | % {($_).split(".")[0]}

#############################################
#For each line of the CSV ; we check if the request has been made in the last 3 days and update or remove by request

foreach ($line in $csv){ 
    if ($line.pic_change_date -like "*0000*"){ 
       #Remove photo
        $id = $line.id
        $id = $id.PadLeft(9,'0')
        $user = Get-ADUser -Server staff.technion.ac.il -Properties employeenumber,mail,primaryaccount -Filter {employeenumber -eq $id -and primaryaccount -eq "TRUE"} -Credential $adpr
        remove-UserPhoto -Identity $user.UserPrincipalName -Confirm:$false  
         write-output "Remove Photo for user: $($user.userprincipalname) id: $id"  
    
  } 
    else { 
    $dateline = (($line.pic_change_date).replace('.','-'))
    $dateupdate = [datetime]::parseExact($dateline, 'dd-MM-yyyy', $null)
    
    #If the User allow to Publish Photo and the request was in the last 5 days
    if (($line.notAllowedToPublish -ne "1") -and ($dateupdate -gt (get-date).AddDays(-5))){
        
          #Found the user in AD
          $id = $line.id
          $id = $id.PadLeft(9,'0')
          $user = Get-ADUser -Server staff.technion.ac.il -Properties employeenumber,mail,primaryaccount -Filter {employeenumber -eq $id -and primaryaccount -eq "TRUE"} -Credential $adpr
          if ($user -and ($id -in $picsnames)){
          
          #Found the File Picture Relevant for the user (by ID)
          $pic = Get-ChildItem -Path $path | ? name -eq "$($id).jpg" -ErrorAction SilentlyContinue
          $picture = $pic.Name
          $data = [System.IO.File]::ReadAllBytes("\\sapftp.sap.technion.ac.il\hr$\TDP\PHONEBOOK\Pictures\$picture")

          #Upload the Photo
          Set-UserPhoto -Identity $user.UserPrincipalName -PictureData $data -Confirm:$false
          write-output "Upload Photo for user: $($user.userprincipalname) id: $id"
          }
        }
     ################################################
     #if the user not allow to publish the Photo - remove
    
    }
    }   


