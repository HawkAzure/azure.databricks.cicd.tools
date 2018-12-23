Set-Location $PSScriptRoot
Import-Module "..\azure.databricks.cicd.Tools.psd1" -Force
$BearerToken = Get-Content "MyBearerToken.txt"  # Create this file in the Tests folder with just your bearer token in
$Region = "westeurope"

Describe "Get-DatabricksGroupMembers" {
    BeforeAll{
        Add-DatabricksGroup -BearerToken $BearerToken -Region $Region -GroupName "1234567890"
    }
    It "Simple Fetch" {
        Get-DatabricksGroupMembers -BearerToken $BearerToken -Region $Region -GroupName "1234567890"
    }
}

