Function Get-DatabricksClusters 
{ 
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$BearerToken, 
        [parameter(Mandatory = $true)][string]$Region
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken =  Format-BearerToken($BearerToken) 
    $Region = $Region.Replace(" ","")
    
    Try {
        $Clusters = Invoke-RestMethod -Method Get -Uri "https://$Region.azuredatabricks.net/api/2.0/clusters/list" -Headers @{Authorization = $InternalBearerToken}
    }
    Catch {
        Write-Output "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Output "StatusDescription:" $_.Exception.Response.StatusDescription
        Write-Error $_.ErrorDetails.Message
    }

    Return $Clusters.clusters
}
    