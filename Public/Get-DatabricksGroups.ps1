<#
.SYNOPSIS
Returns a list of all existing security groups.

.DESCRIPTION
Attempts install of library. Note you must check if the install completes successfully as the install
happens async. See Get-DatabricksLibraries.
Also note that libraries installed via the API do not show in UI. Again see Get-DatabricksLibraries. This
is a known Databricks issue which maybe addressed in the future.
Note the API does not support the auto install to all clusters option as yet.
Cluster must not be in a terminated state (PENDING is ok).

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Databricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.EXAMPLE
C:\PS> Get-DatabricksGroups -BearerToken $BearerToken -Region $Region

List all existing groups

.NOTES
Author: Simon D'Morias / Data Thirst Ltd

#>
Function Get-DatabricksGroups {  
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$BearerToken,    
        [parameter(Mandatory = $true)][string]$Region
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken = Format-BearerToken($BearerToken)
    $Region = $Region.Replace(" ","")

    $uri ="https://$Region.azuredatabricks.net/api/2.0/groups/list"

    Invoke-RestMethod -Uri $uri -Method 'GET' -Headers @{Authorization = $InternalBearerToken}
}
