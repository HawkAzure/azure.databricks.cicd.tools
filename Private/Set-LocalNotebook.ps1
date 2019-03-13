function Set-LocalNotebook ($DatabricksFile, $Language, $LocalOutputPath){
    $uri = "$global:DatabricksURI/api/2.0/workspace/export?path=" + $DatabricksFile + "&format=SOURCE&direct_download=true"
    $FileExtentions = @{"PYTHON"=".py"; "SCALA"=".scala"; "SQL"=".sql"; "R"=".r" }
    
    $LocalExportPath = $DatabricksFile.Replace($ExportPath + "/","") + $FileExtentions[$Language]
    $LocalExportPath = Join-Path $LocalOutputPath $LocalExportPath
    $Headers = GetHeaders $null
    
    Try
    {
        # Databricks exports with a comment line in the header, remove this and ensure we have Windows line endings
        $Response = (Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers) -split '\n' | Select-Object -Skip 1
        $Response = ($Response.replace("[^`r]`n", "`r`n") -Join "`r`n")

        Write-Verbose "Creating file $LocalExportPath"
        New-Item -force -path $LocalExportPath -value $Response -type file | out-null
    }
    Catch
    {
        Write-Error $_.ErrorDetails.Message
    }
}