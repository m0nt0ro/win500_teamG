# win500_teamG
Powershell
** Item 9 and 10 are not included in this repo **

This assignment will require you to automate as much as possible and also make it as interactive as possible. The user should not have to type cmdlets into the computer. Your scripts will ask users for information and your scripts will, when necessary, use this information to perform actions within the network. The specifications listed here are minimum specifications, you can always go beyond and make the scripts/menu more interactive and complete.
1)	Create a menu system that will allow for the selection of each option. The last item in the menu will be an exit from the menu. The menu should come up automatically when PowerShell is started and return after each selection.
2)	Create a server inventory system that will get information about the servers in your domain, 
a)	Get the names of all domain computers and store them in an array. Test to see if they are up and responding. Write to a text file, each system name that did not response as being available. Save this file to C:\Temp.
b)	Write a script that will get information about hard drives (total size in megabytes, free space in megabytes) and amount of RAM (in gigabytes) and operating system. Save this file to the c:\temp folder. This file will be used to gather information about each remote system. 
c)	For each system that responded as “on”, execute the script created in step “b”. Write the hard drive, RAM and operating system data to a web page that will display the system name(s) and the data found in part “b”. If the output deals with multiple OS’s, then make sure the output is sorted by OS. Make sure the output is displayed so that there are no significant gaps between the columns. The browser should open automatically to display this page. In addition, display the “computer names” only, for those systems that did not respond, at the bottom of the web page.

Note: be prepared to test the above requirements with one of your servers “offline”

3)	Using a script, from your workstation, automatically restart all of your remote systems (except your workstation), starting with your AD server. Do not hard-code the server names (get them from AD), (remember to exclude your workstation). Wait for the AD server to restart then restart the next system, confirming that each one has started before restarting the next one. Confirm that each system is running by displaying the IP address and startup time. Your script should be able to work with one system or 1000’s of systems.

4)	Sessions
i)	Create a session asking the user for a session name and a computer to connect to. Automatically list all sessions after a new one is created. Exit from the menu. Sections ii-v are entered manually at the command line. Do not script these commands.
ii)	Enter the session and use some basic commands
iii)	Disconnect from the session and enter the session from another system. Disconnect when done.
iv)	Go back to the original system and kill the session.
v)	Re-enter the menu.
5)	Remote functions 
a)	Create a function that will test to see if a particular user has an active account in Active Directory.  Also, check to see if the user has ever logged on
b)	Ask the user to enter an account name and pass this value to the function

6)	Create/modify/delete users and computers from script. Create a script that will complete the following activities. Note, this script will only be used once. The group/users will be need to available for part 8 of this assignment.
a)	Ask for a user name and create a new user in active directory.
b)	Ask for a group name and create a new group. Add the user name (from “a”) to this group. Display the users within this group. Automatically add the Admin account to this group.
c)	Limit the use of PowerShell to users in this group. No users outside of this group should be able to start PowerShell.

7)	Create 4 cmdlets that will be included in a module called mycmdlets. Each cmdlet will have a help section and aliases. The cmdlets will perform the following tasks (be prepared to demonstrate them).
i)	Get the computer name, OS and up time of any computer active computer in the domain.
ii)	Add a new user by asking for first and last name, and the department they are assigned to. The department they are in will be written to their accounts.
iii)	Get the name, date and time all users last logged into the network. This list will be placed into html format and automatically displayed by the browser.
iv)	Set the hours that a specific user can login to the network. By default a user can login 24/7. Restrict login access to weekdays only. Ask for the user name, then change the access hours to between 9:00am and 6:00pm.
8)	Create a Constrained Endpoint that will only allow the 4 cmdlets, created in Section 7, to be available. The endpoint will be located on your third virtual system. You should be able to access these cmdlets from your workstation. Note, this Endpoint can be loaded into the system prior to the demonstration, to save time. The endpoint will only be accessible by users in the group created in part 6 of this assignment.
9)	Jpeg files are supposed to be stored in a single location on each of your systems. In order to find out if this happening you will search all of your domain systems for these files and copy any .jpg files to a “picture” folder on the C: drive of each remote system. Do not hard code the computer names (look in Active Directory). Your script will do the following:
i)	Check for the existence of a “Picture” folder in C:\temp, on each of your systems. If it does not exist automatically create it.
ii)	Search each computer (all folders and sub folders, excluding the Picture folders for .jpg files. When found, copy the file to the Picture folder on the current remote computer. Do not erase the original file. If there is a file(s) in the Picture folder that already matches the name of the file to be copied, do nor overwrite the file. Move on to the next file. Display the name(s) of the copied file(s) along with the computer name for each system.
10)	You need to find out the status of the firewalls on all of your systems.  Your script will do the following;
i)	Using Active Directory your script will get all of the computer names in the domain. You will then save these names to a text file called mysystems.txt (saved to a folder of your choice). 
ii)	Using the text file from “part (i)” you will read each computer name and determine whether the firewall on that system is turned on or off. If the firewall is “off”, then turn it on. Make sure you have actually turned it on by testing it a second time. If the firewall will not turn on, output the name of the computer and the firewall status.
iii)	As you test each computer, get the names of the software that has been authorized to pass through the firewall. Produce output that will list these names for each computers in the text file.
