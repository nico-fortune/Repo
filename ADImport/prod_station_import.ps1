#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

#Imports the users from the CSV file into Active Directory.  Script to import users starts here.
$Users = Import-Csv -Path "C:\Temp\prod_import.csv"          

$OU = "OU=Seasoft Production Users,DC=fortunefish,DC=com"

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    try {
        if (Get-ADUser -F {SamAccountName -eq $SAM}) {
            #If user does exist, give a warning
            Write-Host "User $SAM already exists in Active Directory" -BackgroundColor Red
            continue
        }
        else {
            $UsersAdded = ""
            # If imported user object contains null references, swap with empty string
            if($User.Name.Length -lt 1) { $User.Name = "" }
            if($User.GivenName.Length -lt 1) { $User.GivenName = "" }
            if($User.SamAccountName.Length -lt 1) { $User.SamAccountName = "" }
            if($User.UserPrincipalName.Length -lt 1) { $User.UserPrincipalName = "" }
            
            try {
                #User does not exist then proceed to create the new user account
                #Account will be created in the OU provided by the $OU variable read from the CSV file
                New-ADUser -SamAccountName $User.SamAccountName -Name $User.Name -DisplayName $User.Name -UserPrincipalName $User.UserPrincipalName -GivenName $User.GivenName -AccountPassword (ConvertTo-SecureString $User.AccountPassword -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false -PasswordNeverExpires $true -server fortunefish.com
                
                Write-Host "User $SAM imported sucessfully" -BackgroundColor Green -ForegroundColor Black
                if($UsersAdded.length -lt 1) { $UsersAdded += "$SAM" }
                if($UsersAdded.length -gt 1 -OR $UsersAdded -eq 1) { $UsersAdded += ",$SAM" }
            }
            catch { 
                Write-Warning "User $SAM did not import correctly" -BackgroundColor Red
            }
            $GroupName = "Seasoft Production Stations"
            Add-ADGroupMember -Identity $GroupName -Members $UsersAdded
        }
    } catch {}
}