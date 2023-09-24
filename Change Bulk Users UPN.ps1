$LocalUsers = Get-ADUser -Filter {UserPrincipalName -like '*NextronixCorp.onmicrosoft.com'} -Properties UserPrincipalName -ResultSetSize $null
$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("NextronixCorp.onmicrosoft.com","nextronixcorp.co.uk"); $_ | Set-ADUser -UserPrincipalName $newUpn}
Get-ADUser -Filter * | Sort-Object Name | Format-Table Name, UserPrincipalName