#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory
  
 #Imports the users from the CSV file into Active Directory.  Script to import users starts here.
      
try {
    $Users = Import-Csv -Path "C:\Temp\neesvigs-import.csv"
    Write-Host "CSV imported successfully" -BackgroundColor Green -ForegroundColor Black
} catch {
    Write-Host "Something went wrong importing CSV" -BackgroundColor Red
}

foreach ($User in $Users) {

    $SAM = $User.SamAccountName

    # If imported user object contains null references, swap with empty string
    if (Get-ADUser -F {SamAccountName -eq $SAM}) {
        #If user does exist, update their fields
        try {
            Write-Host "Updating user $($User.SamAccountName)'s data" -BackgroundColor Yellow -ForegroundColor Black
            # User does not exist then proceed to update the new user account
            
            
            $User.ProxyAddresses = $User.ProxyAddresses.Split(",")
            $ProxyAddresses = $User.ProxyAddresses
            Set-ADUser -Identity $User.SamAccountName -Clear ProxyAddresses
            foreach($ProxyAddress in $ProxyAddresses) {
                Set-ADUser -Identity $User.SamAccountName -Add @{ProxyAddresses="$ProxyAddress"}
            }
            
            Write-Host "User $($User.SamAccountName) updated sucessfully" -BackgroundColor Green -ForegroundColor Black
        } catch { 
            Write-Warning "User $($User.SamAccountName) did not overwrite correctly" -BackgroundColor Red
        }
    } 
}