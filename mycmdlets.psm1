# Menu Item 6: Get computername, osname and uptime of any Computer in your domain.
function Get-ComInfo() {

    <#
    .Synopsis
        Get computername, osname and uptime of any Computer in your domain.
    .Description
    	Gets computer information using CIM
    .Parameter ComputerName
        Target computername.
    .Example
  	    PS> get-cominfo -computer adcomputername
    .Link
     	about_functions
    	about_functions_advanced   	
    .Notes
        NAME:      Get-cominfo
        AUTHOR:    Team G
	    DATELASTMODIFIED:  April 5 2020
    #>

    $computer = Read-Host "Enter the name of a computer to gather information about"

    $sys = Get-ciminstance win32_operatingsystem -ComputerName $computer
    $cname = $sys | foreach { $_.csname}
    $osname = $sys | foreach { $_.caption}
    $uptime = ((((get-date).ToUniversalTime()) - ($sys.lastbootuptime)).ToString('hh\hmm\mss\s'))

    Write-host -ForegroundColor Red "The computer $cname is running $osname as its operating system and has an active uptime of $uptime"

}

# Menu Item 7: Creates AD user by asking for First Name, Last Name and Department.
function Add-ADUser() {

    <#
    .Synopsis
        Creates AD user by asking for First Name, Last Name and Department.
    .Description
		 Requests user input to create a new user based on first name, last name and department.
    .Notes
        NAME:      add-aduser
        AUTHOR:    Team G
        DATELASTMODIFIED:  April 5 2020
    #>

    $firstname = Read-Host "Enter the new user's first name"
    $lastname = Read-Host "Enter the new user's last name"
    $department = Read-Host "Enter the new user's department"
    $username = ($firstname[0]+$lastname).toLower()
    $name = ($firstname +" "+ $lastname)
    New-ADUser -GivenName $firstname -Surname $lastname -Department $department -SamAccountName $username -Name $name

    Write-host "The account for $firstname $lastname has been created with the username $username."

}

# Menu Item 8: List name, date and time of last login for all users, exported to html and displayed in browser instantlyf
function Get-LoginInfo() {

    <#
    .Synopsis
        List name, date and time of last login for all users, exported to html and displayed in browser instantly
    .Description
  		List name, date and time of last login for all users, exported to html and displayed in browser instantly
    .Notes
        NAME:      get-logininfo
        AUTHOR:    Team G
		DATELASTMODIFIED:  April 5 2020
    #>

    Get-ADUser -Filter * -ResultPageSize 0 -Prop name,samaccountname,lastLogon | Select name,samaccountname,@{Name="lastlogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}} | convertto-html Name, samaccountname, lastlogon -Title "Domain Last Login" | Out-File dateoflogin.html

    start .\dateoflogin.html

}

# Menu Item 9: Change workhours for specified user to 9am-6pm
function Adj-WorkHours() {

    <#
    .Synopsis
        Change workhours for specified user to 9am-6pm
    .Description
  		Adjusts user login hours to 9am-6pm weekdays only from the default of unrestricted hours.
    .Notes
        NAME:      adj-workhours
        AUTHOR:    Team G
		DATELASTMODIFIED:  April 5 2020
    #>

    [byte[]]$hours = @(0,0,0,0,192,127,0,192,127,0,192,127,0,192,127,0,192,127,0,0,0)
    $user = read-host "Specify which username hours you'd like to adjust"
    get-aduser -Identity $user | set-aduser -replace @{logonhours=$hours}
    write-host "User $user login hours have been adjusted accordingly"

} 

New-Alias -name cinfo -value Get-ComInfo
New-Alias -name newu -value Add-ADUser
New-Alias -name gloginfo -value Get-LoginInfo
New-Alias -name ahours -value Adj-WorkHours
Export-ModuleMember -Alias * -function *