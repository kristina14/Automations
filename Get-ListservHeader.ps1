param
(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)


#https://32b22300-3326-40e7-bba8-58305d396f09.webhook.we.azure-automation.net/webhooks?token=oZxVLr%2fIZUfOWvbTWUYmsbFkiWH2IvDk8HwsNlviZ8Q%3d
Write-Warning $WebhookData
#$WebhookDataArray = ConvertFrom-Json -InputObject $WebhookData

#Write-Error $WebhookDataArray
Write-Warning $WebhookData.RequestBody

$requestData = ConvertFrom-Json -InputObject ($WebhookData.RequestBody)

$listname = $requestData.listname; #"GRADUATE-STUDENTS-L";
$returnMail = $requestData.returnMail;
if($listname -like "*@*"){
    $listname = ($listname -split '\* ')[0];
}
$listname = $listname.ToLower();
$listHeaderFile = ("D:\Temp\{0}.list" -f ($listname))
$listHeaderFileCsv = ("D:\Temp\{0}.xlsx" -f ($listname))

$credentials = Get-AutomationPSCredential -Name 'staff_stossel';

New-PSDrive -Name P -PSProvider FileSystem -Root "\\share.technion.ac.il\mytech$\listserv" -Credential ($credentials) | Out-Null;
$header = Get-Content -Path ("P:\{0}.list" -f ($listname));
Remove-PSDrive -Name P

$headerObj = New-Object -TypeName psobject
$headerObj | Add-Member -MemberType NoteProperty -Name "ListName" -Value "$listname"

function Get-AzureADNormalCreds(){
    $credentials = Get-AutomationPSCredential -Name "Do Not Reply Email"
    return $credentials;
}

function addToObject($obj, $key, $value){
    $key = $key.trim();
    $value = $value.trim();
    if([bool]($obj.PSobject.Properties.name -match "$key")){
        $newValue = $obj.$key, $value;
        $obj.$key = [system.String]::Join(",", $newValue);
    }
    else{
        $obj | Add-Member -MemberType NoteProperty -Name $key -Value "$value"
    }

    return $obj;
}

function processEmail($key, $value){
    $servers = "st.technion.ac.il","staff.technion.ac.il","dp.technion.ac.il";

    $prefix = $value.Split("@")[0];
        foreach($server in $servers){
            $filetData = "$prefix@*";
            $user = (Get-ADUser -Filter {UserPrincipalName -like $filetData} -Server "$server" -Properties DisplayName, Department);
            if(($user.DisplayName).length){
                return New-Object -typename PSObject -Property @{ 
                    Permission = $key; 
                    "Full Name" = $user.DisplayName;
                    Department =  $user.Department;
                    Email = $value;
                    };
            }
        }
    
    return New-Object -typename PSObject -Property @{ 
                    Permission = $key; 
                    FullName = "";
                    Department =  "";
                    Email = $value;
                    };
}
#$headerLinesArray = $header.Split("`n`r");
$headerLinesArray = (($header -split 'PW=')[0] -split '\* ');
foreach($line in $headerLinesArray){
    if($line -like '*=*'){
        $variableType = $line.Split("=")[0];
        $variablesString = $line.Split("=")[1];
        $headerObj = (addToObject $headerObj $variableType $variablesString);
    }
}



$keys = $headerObj | Get-Member | Where-Object {$_.MemberType -eq "NoteProperty"} | Select-Object -ExpandProperty Name;
$tableData = New-Object System.Collections.ArrayList($null);
#$csvData = "Permission Type`tFull Name`t`Department`tEmail`r`n";
foreach($key in $keys){
    if($key -eq "Editor" -or $key -eq "Owner" -or $key-eq "Send" -or $key -eq "Errors-To"){
        $values = ($headerObj.$key).Split(",");
        foreach($value in $values){
            if($value -like '*@*'){
                $tableData.Add((processEmail $key $value)) | Out-Null
                #$csvData+=("{0}`t{1}`r`n" -f ($key, (processEmail $value)));
            }
        }
    }
}


#Remove-Item –path $listHeaderFile
#$csvData | Out-File $listHeaderFileCsv
$tableData | Select-Object Permission,"Full Name",Department,Email | Export-Excel $listHeaderFileCsv -BoldTopRow -AutoFilter -FreezeTopRow -AutoSize


Send-MailMessage -From "DoNotReply@technion.ac.il" -To $returnMail -BodyAsHtml "---מצורף---" -Subject ("מידע עבור רשימת תפוצה: {0}@listserv.technion.ac.il" -f ($listname))  -Credential (Get-AzureADNormalCreds)  -smtpserver smtp.office365.com -Port 587 -UseSsl -Encoding UTF8 -Attachments $listHeaderFileCsv

Remove-Item –path $listHeaderFileCsv
