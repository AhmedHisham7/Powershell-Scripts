# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv C:\Users\Administrator\Documents\NextronixCorp-Users.csv -Delimiter ","

# Define UPN
$UPN = "NextronixCorp.onmicrosoft.com"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $description= $User.EMPLOYEE_ID
    $firstname = $User.Given_Name
    $lastname = $User.Last_Name
    $displayname= $firstname+" "+$lastname
    $username = $User.EMAIL
    $password = "Adminadmin123"
    $email = $User.EMAIL
    $city = $User.LOCATION
    $telephone = $User.PHONE_NUMBER
    $jobtitle = $User.JOB_TITLE
    $company = $User.ORGANIZATION
    $department = $User.DEPARTMENT_NAME
    $OU ="OU=$department,OU=employees_OU,DC=NextronixCorp,DC=onmicrosoft,DC=com"
    
    #write-host($firstname)
    #This field refers to the OU the user account is to be created in
    #$initials = $User.initials
    #$streetaddress = $User.streetaddress 
    #$zipcode = $User.zipcode
    #$state = $User.state
    #$country = $User.country
    

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username with ID: $description already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
         New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name $displayname `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName $displayname `
            -Path $OU `
            -Office $city `
            -Company $company `
            -OfficePhone $telephone `
            -EmailAddress "$username@$UPN" `
            -Title $jobtitle `
            -Department $department `
            -Description $description `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True
            #-State $state `
            #-StreetAddress $streetaddress `
            #-PostalCode $zipcode `
            #-Country $country `
            #-Initials $initials `

        # If user is created, show message.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Press Enter to exit"