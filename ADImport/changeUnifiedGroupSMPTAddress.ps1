Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -UserPrincipalName fortuneeast@dartagnan0.onmicrosoft.com

$Groups = Import-Csv -Path "C:\Temp\fix-groups.csv"

foreach ($Group in $Groups) {
    $Name = $Group.Name
    $Address = $Group.address + "@dartagnan.com"
    Write-Host $Name
    Set-UnifiedGroup -Identity $Name -PrimarySmtpAddress $Address
}
