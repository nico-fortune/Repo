#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

#Imports the users from the CSV file into Active Directory.  Script to import users starts here. CSV MUST be in C temp path with this filename
$Users = Import-Csv -Path "C:\Temp\titles.csv"          

foreach ($User in $Users) {
    $SAM = $User.SAM
    try {
        $CurrentADUser = Get-ADUser -Filter "SAMAccountName -like $($User.SAM)" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com" -Properties Department, Name, GivenName, Surname, PostalCode, City, State, StreetAddress, Title, Manager
        if(-NOT $CurrentADUser) { 
            Write-Host "$SAM was not found in AD" -BackgroundColor Red -ForegroundColor Black
            continue
        }
    } catch { }
    
    try {
        $Default = $false;
        # If imported user object contains null reference, swap with empty string
        if($User.ManagerSAM.Length -lt 1) {
            $Default = $true;
            $User.ManagerSAM = "rzivkovic"
        }
        
        $ManagerSAM = $User.ManagerSAM
        # Search for manager and set them in
        if($User.ManagerSAM.Length -gt 1) { Set-ADUser -Identity $User.SAM -Manager ((Get-ADUser -Filter "SAMAccountName -like '$ManagerSAM'" -SearchBase "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com").DistinguishedName) }
       
        if($Default) {
            Write-Host "Default manager set for $SAM" -BackgroundColor Yellow -ForegroundColor Black
        } else {
            Write-Host "User $SAM updated sucessfully" -BackgroundColor Green -ForegroundColor Black
        }
        
    } catch { }
}