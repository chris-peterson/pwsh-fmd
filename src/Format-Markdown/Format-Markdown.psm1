function Format-Markdown{

    [CmdletBinding()]
    [Alias("fmd")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject,

        [switch]
        [Parameter()]
        $AsJsonTable,

        # GFM permits omitting the leading/trailing pipe on each table row, but
        # recommends keeping it "for clarity of reading, and if there's
        # otherwise parsing ambiguity" (https://github.github.com/gfm/#tables-extension-).
        # Default to that recommended, canonical form; this switch opts back
        # into the leaner style some renderers/tools produce.
        [switch]
        [Parameter()]
        $NoOuterPipes,

        # Spaces of padding on each side of every pipe - the inner column
        # separators, and (when present) the outer wrapping pipes. Defaults
        # to 1, matching the '| ' / ' |' convention used elsewhere.
        [ValidateRange(0, [int]::MaxValue)]
        [Parameter()]
        [int]
        $PadSpaces = 1
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
        $Output = ''
        if ($AsJsonTable) {
            $Output += "``````json:table`n"
            $Json = @{
                fields = $Columns.Keys | ForEach-Object { @{ key = $_; label = $_; sortable = 'true'}}
                items  = $Items | ForEach-Object {
                    $Row = @{}
                    foreach($key in $Columns.Keys) {
                        $Row.$($key) = $_.($key)
                    }
                    $Row
                }
                filter = 'true'
            }
            $Output += "$($Json | ConvertTo-Json -Depth 10 -Compress)`n"
            $Output += "```````n"
        } else {
            $Pad = ' ' * $PadSpaces
            $Separator = "$Pad|$Pad"
            $Left = if ($NoOuterPipes) { '' } else { "|$Pad" }
            $Right = if ($NoOuterPipes) { '' } else { "$Pad|" }

            foreach ($Key in $($Columns.Keys)) {
                $Columns[$Key] = [Math]::Max($Columns[$Key], $Key.Length)
            }

            $HeaderRow = @()
            foreach ($Key in $Columns.Keys) {
                $HeaderRow += ('{0,-' + $Columns[$Key] + '}') -f $Key
            }
            $Output += "$Left$($HeaderRow -join $Separator)$Right`n"

            $SeparatorRow = @()
            foreach ($Key in $Columns.Keys) {
                $SeparatorRow += '-' * $Columns[$Key]
            }
            $Output += "$Left$($SeparatorRow -join $Separator)$Right`n"

            foreach ($Item in $Items) {
                $DataRow = @()
                foreach($key in $Columns.Keys) {
                    $DataRow += ('{0,-' + $Columns[$key] + '}') -f $Item.($key)
                }
                $Output += "$Left$($DataRow -join $Separator)$Right`n"
            }
        }
        Write-Output $Output
    }
}
