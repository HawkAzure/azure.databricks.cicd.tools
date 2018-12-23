<#
.SYNOPSIS
Add a Databricks Security group to your workspace

.DESCRIPTION
Add a Databricks Security group to your workspace

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Databricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER GroupName
Name of the group to create
    
.EXAMPLE
C:\PS> Add-DatabricksGroup -BearerToken $BearerToken -Region $Region -GroupName "TestSecurityGroup"

.NOTES
Author: Simon D'Morias / Data Thirst Ltd

#>
Function Add-DatabricksGroup {  
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$BearerToken,    
        [parameter(Mandatory = $true)][string]$Region,
        [Parameter(Mandatory = $true)][string]$GroupName
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken = Format-BearerToken($BearerToken)
    $Region = $Region.Replace(" ","")

    $uri ="https://$Region.azuredatabricks.net/api/2.0/groups/create"

    $Body = @{"group_name"=$GroupName}

    $BodyText = $Body | ConvertTo-Json -Depth 10

    Write-Verbose "Request Body: $BodyText"
    try{
        Invoke-RestMethod -Uri $uri -Body $BodyText -Method 'POST' -Headers @{Authorization = $InternalBearerToken}
    }
    catch{
        if ($_.ErrorDetails.Message.Contains('already exists') -eq $true)
        {
            Write-Verbose "Folder already exists"
        }
        else
        {
            Write-Error $_.ErrorDetails.Message
            break
        }

    }
}
