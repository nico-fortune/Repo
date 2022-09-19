#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

# Pulls a list of OUs in Active Directory
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A

#Imports the users from the CSV file into Active Directory.  Script to import users starts here.
$Users = Import-Csv -Path "C:\Temp\import.csv"            

#Loop Each Row in CSV
$AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$OU = Read-Host -Prompt "Which OU should these users be input to?"


foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    if (Get-ADUser -F {SamAccountName -eq $SAM}) {
        #If user does exist, give a warning
        Write-Warning "A user account with username $SAM already exist in Active Directory."
    }
    else {
        # $User.ProxyAddresses = $User.ProxyAddresses.Split(",")
        #User does not exist then proceed to create the new user account
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser -SamAccountName $User.SamAccountName -Name $User.Name -Initials $User.Initials -PostalCode $User.PostalCode -StreetAddress $User.StreetAddress -State $User.State -Title $User.Title -EmailAddress $User.UserPrincipalName -MobilePhone $User.MobilePhone -Department $User.Department -City $User.City -OfficePhone $User.OfficePhone -DisplayName $User.Name -UserPrincipalName $User.UserPrincipalName -GivenName $User.GivenName -Surname $User.Surname -AccountPassword (ConvertTo-SecureString $User.AccountPassword -AsPlainText -Force) -Enabled $true -Path "$OU" -ChangePasswordAtLogon $true -PasswordNeverExpires $false -server fortunefish.com

        # Set-ADUser -Identity $User.SamAccountName -Add @{proxyaddresses="$User.ProxyAddresses"}
    }
}


#Get a list of Users from an OU and export it to a CSV
# Get-ADUser -Filter * -SearchBase "OU=Fortune Madison WI,OU=Fortune Fish Users,DC=fortunefish,DC=com" | Export-CSV c:\Dell\Users.CSV