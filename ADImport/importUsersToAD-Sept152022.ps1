#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

# Pulls a list of OUs in Active Directory
$NeedsOUs = Read-Host -Prompt "Do you need a list of OUs? Y/N"
if($NeedsOUs.ToUpper() -eq "Y") { Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A }
  
 #Imports the users from the CSV file into Active Directory.  Script to import users starts here.
$Users = Import-Csv -Path "C:\Temp\import.csv"          

#Loop Each Row in CSV
# $AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$OU = Read-Host -Prompt "Which OU should these users be input to?"

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    try {
        if (Get-ADUser -F {SamAccountName -eq $SAM}) {
            #If user does exist, give a warning
            Write-Host "User $SAM already exists in Active Directory" -BackgroundColor Red
            continue
        }
        else {
            # If imported user object contains null references, swap with empty string
            if($User.Department.Length -lt 1) { $User.Department = "" }
            if($User.Name.Length -lt 1) { $User.Name = "" }
            if($User.GivenName.Length -lt 1) { $User.GivenName = "" }
            if($User.Initials.Length -lt 1) { $User.Initials = "" }
            if($User.Surname.Length -lt 1) { $User.Surname = "" }
            if($User.MobilePhone.Length -lt 1) { $User.MobilePhone = "" }
            if($User.OfficePhone.Length -lt 1) { $User.OfficePhone = "" }
            if($User.PostalCode.Length -lt 1) { $User.PostalCode = "" }
            if($User.ProxyAddresses.Length -lt 1) { $User.ProxyAddresses = "SMTP:$($UserPrincipalName);" } else {$User.ProxyAddresses = $User.ProxyAddresses.Split(",")}
            if($User.City.Length -lt 1) { $User.City = "" }
            if($User.State.Length -lt 1) { $User.State = "" }
            if($User.StreetAddress.Length -lt 1) { $User.StreetAddress = "" }
            if($User.Title.Length -lt 1) { $User.Title = "" }
            if($User.SamAccountName.Length -lt 1) { $User.SamAccountName = "" }
            if($User.UserPrincipalName.Length -lt 1) { $User.UserPrincipalName = "" }
            
            try {
                #User does not exist then proceed to create the new user account
                #Account will be created in the OU provided by the $OU variable read from the CSV file
                New-ADUser -SamAccountName $User.SamAccountName -Name $User.Name -Initials $User.Initials -PostalCode $User.PostalCode -StreetAddress $User.StreetAddress -State $User.State -Title $User.Title -EmailAddress $User.UserPrincipalName -MobilePhone $User.MobilePhone -Department $User.Department -City $User.City -OfficePhone $User.OfficePhone -DisplayName $User.Name -UserPrincipalName $User.UserPrincipalName -GivenName $User.GivenName -Surname $User.Surname -AccountPassword (ConvertTo-SecureString $User.AccountPassword -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $true -PasswordNeverExpires $false -server fortunefish.com
                
                $ProxyAddresses = $User.ProxyAddresses
                foreach($ProxyAddress in $ProxyAddresses) {
                    Set-ADUser -Identity $User.SamAccountName -Add @{ProxyAddresses="$ProxyAddress"}
                }
                
                Write-Host "User $SAM imported sucessfully" -BackgroundColor Green -ForegroundColor Black
            }
            catch { 
                Write-Warning "User $SAM did not import correctly" -BackgroundColor Red
            }
        }
    } catch {}
}

#Get a list of Users from an OU and export it to a CSV
# Get-ADUser -Filter * -Search