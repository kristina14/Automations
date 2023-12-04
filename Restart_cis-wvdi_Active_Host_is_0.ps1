$Cred = Get-AutomationPSCredential -Name 'Outlook365'
Connect-AzAccount -Credential $Cred 
Select-AzSubscription technion-csp

$resourcename = "cis-wvdi"
$hostpoolname = "Wvdi_ForStudents"
$vmgeneralname = "Cis-VDIStud"

#Get all the sessions in the pool 
$sessions = Get-AzWvdUserSession -HostPoolName $hostpoolname -ResourceGroupName $resourcename -SessionHostName 'cis-vdistud-1.staff.technion.ac.il'
$sessions.count


if($sessions -eq $null)
{
Restart-AzVM -Name "cis-vdistud-1" -ResourceGroupName $resourcename
Write-output "Session in cis-vdistud-1.staff.technion.ac.il was restart"
}
