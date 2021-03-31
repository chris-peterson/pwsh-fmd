function Format-Markdown{

    [CmdletBinding()]
    [Alias("fmd")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )

    Begin {
        $Items = @()
        $Columns =[ordered]@{}
    }

    Process {
        foreach ($Item in $InputObject) {
            $Items += $Item

            $Item.PSObject.Properties | ForEach-Object {
                if ($_.Value -ne $null){
                    if(-not $Columns.Contains($_.Name) -or $Columns[$_.Name] -lt $_.Value.ToString().Length) {
                        $Columns[$_.Name] = $_.Value.ToString().Length
                    }
                }
            }
        }
    }

    End {
        foreach ($Key in $($Columns.Keys)) {
            $Columns[$Key] = [Math]::Max($Columns[$Key], $Key.Length)
        }

        $HeaderRow = @()
        foreach ($Key in $Columns.Keys) {
            $HeaderRow += ('{0,-' + $Columns[$Key] + '}') -f $Key
        }
        Write-Output "$($HeaderRow -join ' | ')`n"

        $SeparatorRow = @()
        foreach ($Key in $Columns.Keys) {
            $SeparatorRow += '-' * $Columns[$Key]
        }
        Write-Output "$($SeparatorRow -join ' | ')`n"

        foreach ($Item in $Items) {
            $DataRow = @()
            foreach($key in $Columns.Keys) {
                $DataRow += ('{0,-' + $Columns[$key] + '}') -f $Item.($key)
            }
            Write-Output "$($DataRow -join ' | ')`n"
        }
    }
}
