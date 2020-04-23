Import-Module -Name $HOME\Documents\WindowsPowerShell\Modules\win500 -DisableNameChecking -Force
Import-Module -Name $HOME\Documents\WindowsPowerShell\Modules\mycmdlets -DisableNameChecking -Force
do {

 Clear-Host

$menu_text = @"
======= WIN500 Assignment ======
1. Generate Server Report
2. Restart Remote Systems
3. Enter PowerShell Session
4. Test for Active Account
5. Create AD Objects 
6. Get System Info
7. Add User to Department
8. Get Login Info
9. Set Work Hours
10. Create Constrained Endpoint
11. Exit Program
================================
"@
 
 Write-Host $menu_text
 $UserSelection = Read-Host "Enter a menu selection"
 Write-Host ""
 
 switch($UserSelection) {
    '1'{Invoke-Expression Get-ServerReport;pause;break}
    '2'{Invoke-Expression Restart-RemoteADComputers;pause;break}
    '3'{Invoke-Expression Create-PSSession;pause;exit}
    '4'{Invoke-Expression Test-ADUser;pause;break}
    '5'{Invoke-Expression Create-ADObject;pause;break}
    '6'{Invoke-Expression Get-ComInfo;pause;break}
    '7'{Invoke-Expression Add-ADUser;pause;break}
    '8'{Invoke-Expression Get-LoginInfo;pause;break}
    '9'{Invoke-Expression Adj-WorkHours;pause;break}
    '10'{Invoke-Expression Create-Endpoint;pause;break}
    '11'{Clear-Host;exit}
  default{Write-Warning "Invalid selection";pause}
 }
 
} while ($UserSelection -ne 11)