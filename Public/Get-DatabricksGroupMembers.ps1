<#
.SYNOPSIS
Returns a list of users in a group.

.DESCRIPTION
Returns a list of users in a group.

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Databricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER GroupName
Name of teh group to return the members from.

.EXAMPLE
C:\PS> Get-DatabricksGroupMembers -BearerToken $BearerToken -Region $Region -GroupName "Test"

.NOTES
Author: Simon D'Morias / Data Thirst Ltd

#>
Function Get-DatabricksGroupMembers {  
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$BearerToken,    
        [parameter(Mandatory = $true)][string]$Region,
        [parameter(Mandatory = $true)][string]$GroupName
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken = Format-BearerToken($BearerToken)
    $Region = $Region.Replace(" ","")

    $Body = @{"group_name"=$GroupName}

    $BodyText = $Body | ConvertTo-Json -Depth 10

    Write-Verbose "Request Body: $BodyText"

    $uri ="https://$Region.azuredatabricks.net/api/2.0/groups/list-members"

    Invoke-RestMethod -Uri $uri -Body $BodyText -Method 'GET' -Headers @{Authorization = $InternalBearerToken}
}
