# Fetch a list of users from Active Directory
$Users = Get-ADUser -Filter *
foreach ($User in $Users) {

        # Modify the user's email address (EmailAddress attribute)
        $User | Set-ADUser -EmailAddress $User.UserPrincipalName

        Write-Host (Get-ADUser -Filter * | Sort-Object Name | Format-Table Name, UserPrincipalName)

}
