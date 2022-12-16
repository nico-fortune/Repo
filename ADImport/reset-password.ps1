#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

# Pulls a list of OUs in Active Directory
$NeedsOUs = Read-Host -Prompt "Do you need a list of OUs? Y/N"
if($NeedsOUs.ToUpper() -eq "Y") { Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A }
  
 #Imports the users from the CSV file into Active Directory.  Script to import users starts here.
# $Users = Import-Csv -Path "C:\Temp\all-dartagnan-oct19.csv"          
$Users = Import-Csv -Path "C:\Temp\test-password-change.csv"          


#Loop Each Row in CSV
# $AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$OU = Read-Host -Prompt "Which OU should these users be edited in?"

foreach ($User in $Users) {
    $SAM = $User.SAM
    $Password = "ComeJoinTheParty583@!"
    # try {
        # if(Get-ADUser -Identity $SAM -ChangePasswordAtLogon) {
        #     Write-Host "Password changed condition satisfied"
        Set-ADAccountPassword -Identity $User.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "ComeJoinTheParty583@!" -Force) -ChangePasswordAtLogon $true
        # }
        # else {
            # Write-Host "Skipped $SAM, password was already changed"
        # }
        Write-Host "User $SAM password updated sucessfully" -BackgroundColor Green -ForegroundColor Black
    # } catch {
    #     Write-Warning "User $SAM did not update" -BackgroundColor Red
    # }
}