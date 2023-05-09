Connect-AzureAD

$Users = Import-Csv -Path "C:\Temp\final-batch.csv"

foreach($User in $Users) {
    Get-AzureADUser -SearchString $User.UserPrincipalName | Revoke-AzureAdUserAllRefreshToken
    Set-AzureADUser -ObjectID $User.UserPrincipalName -AccountEnabled $false
    Get-AzureADUser -ObjectId  $User.UserPrincipalName |  Select DisplayName, UserPrincipalName, AccountEnabled
}
