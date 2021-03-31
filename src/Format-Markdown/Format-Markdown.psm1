function Format-Markdown{
    [CmdletBinding()]
    [Alias("fmd")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $false)]
        [string[]]
        $Property = @()
    )
    Begin {
        $items = @()
        $columns = @{}
    }

    Process {
        ForEach($item in $InputObject) {
            #Write-Debug "Processing item '$item'"
            $items += $item

            $item.PSObject.Properties | %{
                #Write-Debug "Processing property '$($_.Name)'"
                if ($Property -and $Property.Length -gt 0 -and -not $Property.Contains($_.Name)) {
                    #Write-Debug "suppressing $($_.Name)"
                }
                else {
                    if ($_.Value -ne $null){
                        if(-not $columns.ContainsKey($_.Name) -or $columns[$_.Name] -lt $_.Value.ToString().Length) {
                            $columns[$_.Name] = $_.Value.ToString().Length
                        }
                    }
                }
            }
        }
    }

    End {
        ForEach($key in $($columns.Keys)) {
            $columns[$key] = [Math]::Max($columns[$key], $key.Length)
        }

        $header = @()
        ForEach($key in $columns.Keys) {
            $header += ('{0,-' + $columns[$key] + '}') -f $key
        }
        Write-Output "$($header -join ' | ')`n"

        $separator = @()
        ForEach($key in $columns.Keys) {
            $separator += '-' * $columns[$key]
        }
        Write-Output "$($separator -join ' | ')`n"

        ForEach($item in $items) {
            $values = @()
            ForEach($key in $columns.Keys) {
                $values += ('{0,-' + $columns[$key] + '}') -f $item.($key)
            }
            Write-Output "$($values -join ' | ')`n"
        }
    }
}
