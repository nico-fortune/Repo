#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory

$Users = Import-Csv -Path "C:\Temp\change-passwords.csv"          

#Loop Each Row in CSV
foreach ($User in $Users) {
    try {
        Set-ADAccountPassword -Identity $User.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $User.AccountPassword -Force)
        Write-Host "User $($User.SamAccountName) password updated sucessfully" -BackgroundColor Green -ForegroundColor Black
    } catch {
        Write-Host "Something went wrong for $($User.SamAccountName)" -BackgroundColor Red -ForegroundColor Black
    }
}