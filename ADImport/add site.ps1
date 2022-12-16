#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

# Pulls a list of OUs in Active Directory
$NeedsOUs = Read-Host -Prompt "Do you need a list of OUs? Y/N"
if($NeedsOUs.ToUpper() -eq "Y") { Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A }

#Loop Each Row in CSV
# $AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$OU = Read-Host -Prompt "Which OU should these users be input to?"

# List all users from OU path
$Users = Get-ADUser -Filter * -SearchBase $OU | Select-Object SamAccountName

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
        try {
            Set-ADUser -Identity $User.SamAccountName -Office "Fortune Test!"

            Write-Host "User $SAM updated sucessfully" -BackgroundColor Green -ForegroundColor Black
        }
        catch { 
            Write-Warning "User $SAM did not update correctly" -BackgroundColor Red
        }
}