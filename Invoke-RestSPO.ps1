function Get-SPOObject
{
param (
        [Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
        [Parameter(Mandatory=$true,Position=2)]
		[SecureString] $password = (Read-Host -AsSecureString),
        [Parameter(Mandatory=$true,Position=3)]
		[string] $url,
        [Parameter(Mandatory=$false,Position=4)]
        [string] $object=""
		)


 
  $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $password)
  $RestUrl=$url+"/_api/"
  if($object -ne "")
  {
    $RestUrl+=$object
  }


  
        $request = [System.Net.WebRequest]::Create($RESTUrl) 
        $request.Credentials = $Credentials 
        $request.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f") 
        $request.Accept = "application/json;odata=verbose" 
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
        $request.Method=$Method 
        $response = $request.GetResponse() 
        $requestStream = $response.GetResponseStream() 
        $read = New-Object System.IO.StreamReader $requestStream 
        $data=$read.ReadToEnd() 
 # Because the string contains duplicate 'ID' keys.
        $results = $data.ToString().Replace("ID", "_ID") | ConvertFrom-Json 
        $objekty=$results.d.results 



        if($objekty -ne $null)
        {
            Write-Output $objekty
            }
        else
        {
            Write-Output $results.d

        }
        
        

        
  }

Add-Type -Path ".\Microsoft.SharePoint.Client.dll"  
Add-Type -Path ".\Microsoft.SharePoint.Client.Runtime.dll"               

#Enter the data
#$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString

$username="xyz@OL54O365.onmicrosoft.com"
$Password ="12345"
$Url = "https://ol54o365.sharepoint.com/sites/PPortalDev"
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
Get-SPOObject -Username $username  -password $pwd -Url $Url -Object "web/lists/getbytitle('MyTest')/items?&select=ID,Title" | select Title, ID