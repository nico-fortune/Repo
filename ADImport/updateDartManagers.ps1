#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

#Imports the users from the CSV file into Active Directory.  Script to import users starts here. CSV MUST be in C temp path with this filename
$Users = Import-Csv -Path "C:\Temp\titles.csv"          

foreach ($User in $Users) {

    # $CurrentADUser = Get-ADUser -Filter "samaccountname -eq ${$User.SAM}" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com" -Properties Department, Name, GivenName, Surname, PostalCode, City, State, StreetAddress, Title, Manager
    # TEST CASE
    $CurrentADUser = Get-ADUser -Filter "samaccountname -eq ${$User.SAM}" -SearchBase "OU=Test Users,OU=Fortune Fish Users,DC=fortunefish,DC=com" -Properties Department, Name, GivenName, Surname, PostalCode, City, State, StreetAddress, Title, Manager

    if(-NOT $CurrentADUser) { 
        Write-Host "${$User.Name} works in ${$User.Department} and was not found in AD"
        continue
    }
    try {
        # If imported user object contains null references, swap with empty string
        if($User.Department.Length -lt 1) { $User.Department = "" }
        if($User.Name.Length -lt 1) { $User.Name = "" }
        if($User.GivenName.Length -lt 1) { $User.GivenName = "" }
        if($User.Surname.Length -lt 1) { $User.Surname = "" }
        if($User.PostalCode.Length -lt 1) { $User.PostalCode = "" }
        if($User.City.Length -lt 1) { $User.City = "" }
        if($User.State.Length -lt 1) { $User.State = "" }
        if($User.StreetAddress.Length -lt 1) { $User.StreetAddress = "" }
        if($User.Title.Length -lt 1) { $User.Title = "" }
        if($User.ManagerSAM.Length -lt 1) { $User.ManagerSAM = "robz" }
        
        # Set them properties boi!
        Set-ADUser -Identity $User.SAM -Department $User.Department -Name $User.Name -GivenName $User.GivenName -Surname $User.Surname -PostalCode $User.PostalCode -City $User.City -State $User.State -StreetAddress $User.StreetAddress -Title $User.Title 

        # Search for manager and set them in
        # if($User.ManagerSAM.Length -gt 1) { Set-ADUser -Identity $User.SAM -Manager ((Get-ADUser -Filter "samaccountname -eq ${$User.ManagerSAM}" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com").DistinguishedName) }
        # TEST CASE
        if($User.ManagerSAM.Length -gt 1) { Set-ADUser -Identity $User.SAM -Manager ((Get-ADUser -Filter "samaccountname -eq ${$User.ManagerSAM}" -SearchBase "OU=Test Users,OU=Fortune Fish Users,DC=fortunefish,DC=com").DistinguishedName) }

        Write-Host "User ${$User.Name} updated sucessfully" -BackgroundColor Green -ForegroundColor Black
    } catch {
        Write-Warning "User ${$User.Name} did not import correctly" -BackgroundColor Red
    }
}