# Connect to Exchange Online
Install-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline 

# Import the CSV file
$AllGroups = Import-Csv -Path "C:\temp\test-group-alias.csv"

# Loop through each list and update the domain
foreach ($Group in $AllGroups) {

    if($Group.groupType -eq "Distribution") {
        # Update the list's email address
        Set-DistributionGroup -Identity $Group.mail -EmailAddresses @{Add="smtp:$($Group.alias)"}
        Write-Host "$($Group.groupType) $($Group.displayName) has had aliases updated."
    } else if($Group.groupType -eq "Microsoft 365") {
        # Update the group's email address
        Set-UnifiedGroup -Identity $Group.mail -EmailAddresses @{Add="smtp:$($Group.alias)"}
    } else (
        # Update the mailbox's email address
        Set-Mailbox -Identity $Group.mail -EmailAddresses @{Add="smtp:$($Group.alias)"}
    )
    Write-Host "$($Group.alias) added for $($Group.groupType) $($Group.displayName)."
}


# Disconnect from Exchange Online
Disconnect-ExchangeOnline