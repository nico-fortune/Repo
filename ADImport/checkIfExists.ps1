#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory
  
 #Checks if SAM exists in AD
      
try {
    $Users = Import-Csv -Path "C:\Temp\sam-names.csv"
    Write-Host "CSV imported successfully" -BackgroundColor Green -ForegroundColor Black
} catch {
    Write-Host "Something went wrong importing CSV" -BackgroundColor Red
}

if (!(Test-Path "C:\Temp\sam-log.txt")) {
   New-Item -path "C:\Temp" -name "sam-log.txt" -type "file" -value "`r`r`n-------------------------`r`nLog from run on $(Get-Date)`r`n"
   Write-Host "Created new file and text content added."
} else {
  Add-Content -path "C:\Temp\sam-log.txt" -value "`r`r`n-------------------------`r`nLog from run on $(Get-Date)`r`n"
  Write-Host "File already exists and new text content added."
}

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    
    if (Get-ADUser -F {SamAccountName -eq $SAM}) {
        #If user does exist, give a warning
        Write-Host "User $SAM already exists in Active Directory" -BackgroundColor Red
        Add-Content -path "C:\Temp\sam-log.txt" -value "User $SAM already exists in Active Directory"
    }
}