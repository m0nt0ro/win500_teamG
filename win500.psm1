# Menu Item 1: Gathers information about systems in domain and creates an HTML report
function Get-ServerReport() {

    <#
 	.Synopsis
        Generates a report about remote systems in domain and displays it in a web browser
 	.Description
        Generates a report that includes OS information, Physical Memory, and Hard Disk, then creates an HTML page
	.Example  
 	    PS> Get-ServerReport
	.Notes
	    NAME:      Get-ServerReport
 	    AUTHOR:    Team G
 	    DATELASTMODIFIED:  March 26, 2020
    #>

    # get a list of computer names from Active Directory
    $Computers = Get-ADComputer -Filter * | ForEach-Object {$_.Name}
    $online_hosts = @()
    $offline_hosts = @()
    
    foreach ($x in $Computers) {
        Write-Host "Testing connection to $x..." -ForegroundColor Red
        if (Test-Connection $x -Quiet) 
         {$online_hosts += $x} 
        else 
         {$offline_hosts += $x}
    }
    
    # check to see if the HTML file report already exists and deletes if so 
    if (Test-Path $HOME\Desktop\report.html) {
        Remove-Item -Path $HOME\Desktop\report.html
    }
    
    # create header for the HTML report
    $Header = @’

<style>

body { background-color:#FFFFFF;

       font-family:Tahoma;

       font-size:12pt; }

td, th { border:1px solid black;

         border-collapse:collapse; }

th { color:white;

     background-color:black; }

table, tr, td, th { padding: 2px; margin: 0px }

table { margin-left:50px; }

</style>

‘@
    
    # create HTML fragments (OS, memory, disk) for each online host and assemble into webpage
    foreach ($x in $online_hosts) {
    
        $diskinfo = Invoke-Command -ComputerName $x -ScriptBlock {Get-WmiObject Win32_LogicalDisk}
        $physicalmemory = Invoke-Command -ComputerName $x -ScriptBlock {Get-CimInstance Win32_PhysicalMemory}
        $OSinfo = Invoke-Command -ComputerName $x -ScriptBlock {Get-CimInstance Win32_OperatingSystem}
    
        $frag1 = $OSinfo | Select-Object `
            @{Label="Version";Expression={$_.Caption}},
            @{Label="Build Number";Expression={$_.BuildNumber}},
            @{Label="Architecture";Expression={$_.OSArchitecture}},
            @{Label="Installed On";Expression={$_.InstallDate}} `
        | ConvertTo-Html -Fragment -PreContent ‘<h3>Operating System</h3>’ | Out-String
    
        $frag2 = $physicalmemory | Select-Object `
            @{Label="Manufacturer";Expression={$_.Manufacturer}},
            @{Label="DIMM Slot";Expression={$_.BankLabel}},
            @{Label="Part Number";Expression={$_.PartNumber}},
            @{n="Size (GB)";e={[math]::Round($_.Capacity/1GB,2)}} `
        | ConvertTo-Html -Fragment -PreContent ‘<h3>Physical Memory</h3>’ | Out-String
    
        $frag3 = $diskinfo | Select-Object `
            @{Label="Drive Letter";Expression={$_.Caption}},
            @{Label="Description";Expression={$_.Description}},
            @{Label="File System";Expression={$_.FileSystem}},
            @{Label="Total Size (GB)";Expression={[math]::Round($_.Size/1GB,2)}},
            @{Label="Free Space (GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}} `
        | ConvertTo-Html -Fragment -PreContent ‘<h3>Hard Disks</h3>’ -PostContent "<br><br>"| Out-String
    
        ConvertTo-HTML -head $Header -PostContent $frag1,$frag2,$frag3 -PreContent “<h1>System Information for $x</h1>” | Out-File -Append -FilePath $HOME\Desktop\report.html
    
    }
    
    # append names of offline hosts to webpage
    Write-Output "<h3>Offline Systems: $offline_hosts</h3>" | Out-File -Append -FilePath $HOME\Desktop\report.html
    
    # open completed webpage
    Invoke-Item $HOME\Desktop\report.html

}

# Menu Item 2: Restarts remote machines in domain, excluding the current computer
function Restart-RemoteADComputers() {

    # get list of all computer names in AD and checks if online
    [System.Collections.ArrayList]$Computers = Get-ADComputer -Filter * | ForEach-Object {$_.Name}
    $Computers.Remove($env:COMPUTERNAME)
    $remote_computers = @()

    foreach ($x in $Computers) {
        if (Test-Connection -ComputerName $x -Quiet) {$remote_computers += $x}
    }

    # restart remote computers 
    foreach ($x in $remote_computers) {
        
        Write-Host -Foreground Red "Restarting remote computer $x..."

        Invoke-Command -ComputerName $x -ScriptBlock {Restart-Computer -Force}
        do {
           Start-Sleep -Seconds 5
        } until (Test-Connection -ComputerName $x -Quiet)

        Remove-Variable startuptime 2> $null

        do {
            $startuptime = (Invoke-Command -ComputerName $x -ScriptBlock {Get-CimInstance -ClassName win32_operatingsystem} 2> $null) 
            Start-Sleep -Seconds 1
        } until ($startuptime)

        $startuptime | Select-Object @{Label="System Name";Expression={$_.CSName}}, @{Label="Bootup Time";Expression={$_.LastBootUpTime}} | Format-Table 
    }
}

# Menu Item 3: Create a PS session to the given computername
function Create-PSSession() {
 
    $sessionname = read-host "Enter your desired session name"
    $computer = read-host "Enter the name of the computer you want to connect to"

    $session = New-PSSession -name $sessionname -ComputerName $computer
    Get-PSSession -name *
    Write-Host ""
    Enter-PSSession -Name $sessionname

}

# Menu Item 4: User input a username and test whether that username is active in AD and logon or not
function Test-ADUser() {

<#
 	.Synopsis
  	    Test to see if a particular user has an active account in Active Directory.  
        Also, check to see if the user has ever logged on
 	.Description
 	    Test to see if a particular user has an active account in Active Directory.  
        Also, check to see if the user has ever logged on
	.Example
        PS> Test-ADUser -username $username
 	.Link
        about_functions
        about_functions_advanced
        about_functions_advanced_methods
        about_functions_advanced_parameters
	.Notes
	    NAME:      Test-ADUser
 	    AUTHOR:    Team G
 	    DATELASTMODIFIED:  March 26, 2020
#>

    $username = Read-Host "Enter a username to check if it exists in Active Directory"

    Try
    {
        $ADUser = Get-ADUser -Identity $username -Properties *|Select-Object Enabled,Logoncount
        if ($ADUser.Enabled -eq "True")
        {
            Write-Host -ForegroundColor Red "The account $username is active"
        }else {
            Write-Host -ForegroundColor Red "The account $username is not active"
        }
        
        if ($ADUser.Logoncount -gt 0)
        {
            Write-Host -ForegroundColor Red "The account $username has logged on"
        }
        else{
            Write-Host -ForegroundColor Red "The account $username has not logged on"
        }
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        # The user was not found!
        Write-Warning "$($username) was not found in this domain!"
    }
      
}

# Menu Item 5: Create a new AD user, a new AD group, add users to new group, limit Powershell
function Create-ADObject() {

<#
 	.Synopsis
  	     Get user's name and group input and create a new user, a new group, and 
         add this user and Administrator to the new group
 	.Description
 	     Get user's name and group input and create a new user, a new group, and 
         add this user and Administrator to the new group
	.Example
 	    PS> Create-ADObject
 	.Link
         about_functions
         about_functions_advanced
         about_functions_advanced_methods
         about_functions_advanced_parameters
	.Notes
	     NAME:      Create ADObject
 	     AUTHOR:    Team G
 	     DATELASTMODIFIED:  March 26, 2020
#>

    [CmdletBinding()]
    Param(
        
    )
    
    $name = Read-Host "Input your name (FirstName LastName)"
    $password = Read-Host "Input your password" -AsSecureString
    $groupname = Read-Host "Input your new group"
    
    # Create a new AD user
    $firstname = $name.split(' ')[0]
    $lastname = $name.split(' ')[1]
    $username = $firstName.Substring(0) + $lastName.Substring(0,1)
    $pathName = (Get-ADDomain).UsersContainer
    New-ADUser -Name $name   -GivenName $firstName -Surname $lastName -SamAccountName $username -AccountPassword(convertto-securestring $password -AsPlainText -Force) `
                -Enabled $true -Path $pathName

    # Create a new group AD 
    New-ADGroup -Name $groupname -GroupCategory Security -GroupScope Global -DisplayName $groupname -Path $pathName

    # Add the new user and Administrator to the new group
    Add-ADGroupMember -Identity $groupname -Members $username,"Administrator"

    # Limit only users in the new group to access PowerShell
    Set-PSSessionConfiguration -Name Microsoft.PowerShell -ShowSecurityDescriptorUI -Force

}

# Menu Item 10: Create constrained endpoint 
function Create-Endpoint(){
 
 <#
    .Synopsis
        Create a constraint endpoint that will alow 4 cmdlet created in modules mycmdlets.
    .Description
    	Create a constraint endpoint that will alow 4 cmdlet created in modules mycmdlets
    .Parameter ComputerName
        Target computername.
    .Example
  	    PS> Create-Endpoint -computer adcomputername
    .Link
     	about_functions
    	about_functions_advanced   	
    .Notes
        NAME:      Create-Endpoint
        AUTHOR:    Team G
	    DATELASTMODIFIED:  April 14 2020
    #>

Register-PSSessionConfiguration –Name win500assignment -runascredential Administrator -StartupScript "$HOME\Desktop\PS_Assignment_8_endpoint.ps1" -ShowSecurityDescriptorUI

Enter-PSSession -ComputerName 'SRV1-AD' -ConfigurationName win500assignment

}