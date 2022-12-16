Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -UserPrincipalName fortuneeast@dartagnan0.onmicrosoft.com

Set-UnifiedGroup -Identity "California" -PrimarySmtpAddress california@dartagnan.com