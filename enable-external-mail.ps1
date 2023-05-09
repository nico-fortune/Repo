# Connect to Exchange Online
# Connect-ExchangeOnline -UserPrincipalName "fortuneeast@dartagnan0.onmicrosoft.com"
Connect-ExchangeOnline

# Set an array of group names that you want to enable external communication for
$GroupIDs = Import-Csv -Path "C:\Temp\test-groups.csv"

foreach ($Group in $GroupIDs) {
    # Set the external communication options for the group
    Set-UnifiedGroup -Identity $Group.mail -RequireSenderAuthenticationEnabled $true
    Write-Host "External communication has been enabled for the group $($Group.displayName)"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline