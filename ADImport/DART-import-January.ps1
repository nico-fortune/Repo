#Imports the Active Directory Module into PowerShell
Import-module ActiveDirectory
  
 #Imports the users from the CSV file into Active Directory.  Script to import users starts here.
      
try {
    $Users = Import-Csv -Path "C:\Temp\master-import.csv"
    Write-Host "CSV imported successfully" -BackgroundColor Green -ForegroundColor Black
} catch {
    Write-Host "Something went wrong importing CSV" -BackgroundColor Red
}

#Loop Each Row in CSV
# $AllOUs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
$Union = "OU=D'Artagnan - XXX - Union,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$Macon = "OU=D'Artagnan - XXX - Macon,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$NorthCarolina = "OU=D'Artangan - XXXX - North Carolina,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$Denver = "OU=D'Artagnan - XXXX - Colorado,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$DesPlaines = "OU=D'Artagnan - XXXX - Des Plaines,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$Houston = "OU=D'Artagnan - XXXX - Houston,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$Utility = "OU=D'Artagnan Utility Accounts,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$Shared = "OU=D'Artagnan Shared Accounts,OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"
$ParentOU = "OU=D'Artagnan,OU=Fortune Fish Users,DC=fortunefish,DC=com"

if (!(Test-Path "C:\Temp\dart-import-log.txt")) {
   New-Item -path "C:\Temp" -name "dart-import-log.txt" -type "file" -value "`r`r`n-------------------------`r`nLog from run on $(Get-Date)`r`n"
   Write-Host "Created new file and text content added."
} else {
  Add-Content -path "C:\Temp\dart-import-log.txt" -value "`r`r`n-------------------------`r`nLog from run on $(Get-Date)`r`n"
  Write-Host "File already exists and new text content added."
}

foreach ($User in $Users) {
    $SAM = $User.SamAccountName
    $OU = ""

    switch ($User.State) {
        "Illinois" { $OU = $DesPlaines }
        "Georgia" { $OU = $Macon }
        "North Carolina" { $OU = $NorthCarolina }
        "Colorado" { $OU = $Denver }
        "Texas" { $OU = $Houston }
        "New Jersey" { $OU = $Union }
        "Utility" { $OU = $Utility }
        "Shared" { $OU = $Shared }
        default { $OU = $ParentOU }
    }

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

    if (Get-ADUser -F {SamAccountName -eq $SAM}) {
        #If user does exist, give a warning
        Write-Host "User $SAM already exists in Active Directory" -BackgroundColor Red
        Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM already exists in Active Directory"
        $WantToOverwrite = Read-Host "`r`nUser $($User.GivenName) ($SAM) already exists in Active Directory. Type `"OVERWRITE`" if you would like to update their information with data from the import spreadsheet. This is pretty permanent, and may cause problems if this is a genuine SAM naming conflict. Type `"SKIP`" to do nothing and continue to the next user."
        if($WantToOverwrite -eq "OVERWRITE") {
            # This will overwrite EVERYTHING mentioned in the CSV BESIDES their password, account status, name, and UPN
            try {
                Write-Host "Overwriting user $SAM's data" -BackgroundColor Yellow -ForegroundColor Black
                Add-Content -path "C:\Temp\dart-import-log.txt" -value "Overwriting user $SAM's data"
                # User does not exist then proceed to create the new user account

                Set-ADUser -Identity $User.SamAccountName -Replace @{postalCode=$User.PostalCode;streetAddress=$User.StreetAddress;st=$User.State;title=$User.Title;mail=$User.UserPrincipalName;mobile=$User.MobilePhone;department=$User.Department;l=$User.City;telephoneNumber=$User.OfficePhone;}
                
                $ProxyAddresses = $User.ProxyAddresses
                foreach($ProxyAddress in $ProxyAddresses) {
                    Set-ADUser -Identity $User.SamAccountName -Add @{ProxyAddresses="$ProxyAddress"}
                }
                
                Write-Host "User $SAM overwritten sucessfully" -BackgroundColor Green -ForegroundColor Black
                Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM overwritten sucessfully"
            } catch { 
                Write-Warning "User $SAM did not overwrite correctly" -BackgroundColor Red
                Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM did not overwrite correctly"
            }
        } elseif ($WantToOverwrite -eq "SKIP") {
            # Do NOT overwrite, skip and continue to next user
            Write-Host "User $SAM's data will NOT be overwritten" -BackgroundColor Yellow -ForegroundColor Black
            Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM's data will NOT be overwritten"
            continue
        }
    } else {       
        try {
            # User does not exist then proceed to create the new user account
            # Account will be created in the OU provided by the $OU variable read from the CSV file
            New-ADUser -SamAccountName $User.SamAccountName -Name $User.Name -Initials $User.Initials -PostalCode $User.PostalCode -StreetAddress $User.StreetAddress -State $User.State -Title $User.Title -EmailAddress $User.UserPrincipalName -MobilePhone $User.MobilePhone -Department $User.Department -City $User.City -OfficePhone $User.OfficePhone -DisplayName $User.Name -UserPrincipalName $User.UserPrincipalName -GivenName $User.GivenName -Surname $User.Surname -AccountPassword (ConvertTo-SecureString $User.AccountPassword -AsPlainText -Force) -Enabled $false -Path "$OU" -ChangePasswordAtLogon $true -PasswordNeverExpires $false -server fortunefish.com
            
            $ProxyAddresses = $User.ProxyAddresses
            foreach($ProxyAddress in $ProxyAddresses) {
                Set-ADUser -Identity $User.SamAccountName -Add @{ProxyAddresses="$ProxyAddress"}
            }
            
            Write-Host "User $SAM imported sucessfully" -BackgroundColor Green -ForegroundColor Black
            Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM imported sucessfully"
        } catch { 
            Write-Warning "User $SAM did not import correctly" -BackgroundColor Red
            Add-Content -path "C:\Temp\dart-import-log.txt" -value "User $SAM did not import correctly"
        }
    }
}