Set-Location $PSScriptRoot
Import-Module "..\azure.databricks.cicd.Tools.psd1" -Force
$BearerToken = Get-Content "MyBearerToken.txt"  # Create this file in the Tests folder with just your bearer token in
$Region = "westeurope"

Describe "Get-DatabricksGroups" {
    It "Simple Fetch" {
        Get-DatabricksGroups -BearerToken $BearerToken -Region $Region
        
    }

}

