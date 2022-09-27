#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

# Pulls a list of OUs in Active Directory
$NeedsOUs = Read-Host -Prompt "Do you need a list of OUs? Y/N"
if($NeedsOUs.ToUpper() -eq "Y") { Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A }
  
 #Imports the users from the CSV file into Active Directory.  Script to import users starts here.
$Users = Import-Csv -Path "C:\Temp\x5.csv"          

#Loop Each Row in CSV
# $AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$OU = Read-Host -Prompt "Which OU are these users in?"

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    try {
        # If imported user object contains null references, swap with empty string
        if($User.ProxyAddresses.Length -lt 1) { continue } else {$User.ProxyAddresses = $User.ProxyAddresses.Split(",")}
        
        try {
            #User does not exist then proceed to create the new user account
            #Account will be created in the OU provided by the $OU variable read from the CSV file
            $ProxyAddresses = $User.ProxyAddresses
            foreach($ProxyAddress in $ProxyAddresses) {
                Set-ADUser -Identity $User.SamAccountName -Add @{ProxyAddresses="$ProxyAddress"}
            }
            
            Write-Host "Addresses for $SAM added sucessfully" -BackgroundColor Green -ForegroundColor Black
        }
        catch { 
            Write-Warning "User $SAM did not update correctly" -BackgroundColor Red
        }
    } catch {}
}

#Get a list of Users from an OU and export it to a CSV
# Get-ADUser -Filter * -Search