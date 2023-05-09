#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

#Imports the users from the CSV file into Active Directory.  Script to import users starts here. CSV MUST be in C temp path with this filename
$Users = Import-Csv -Path "C:\Temp\sig-data.csv"          

foreach ($User in $Users) {
    try {
        $CurrentADUser = Get-ADUser -Filter "SAMAccountName -like $($User.SAM)" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
        if(-NOT $CurrentADUser) { 
            Write-Host "$($User.SAM) was not found in AD" -BackgroundColor Red -ForegroundColor Black
            continue
        }
    } catch { }
    
    # try {

        if($User.Department.Length -lt 1) { $User.Department = "" }
        if($User.Title.Length -lt 1) { $User.Title = "" }
        if($User.MobilePhone.Length -lt 1) { $User.MobilePhone = "" }
        
        # Search for manager and set them in
        if($User.ManagerSAM.Length -gt 1) { Set-ADUser -Identity $User.SAM -Manager ((Get-ADUser -Filter "SAMAccountName -like '$($User.ManagerSAM)'" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com").DistinguishedName) }

        Set-ADUser -Identity $User.SAM -Replace @{title=$User.Title;mobile=$User.MobilePhone;department=$User.Department;}
       
        Write-Host "User $($User.SAM) updated sucessfully" -BackgroundColor Green -ForegroundColor Black
        
    # } catch { 
        # Swallow any errors, silently continue to next user
    #  }
}