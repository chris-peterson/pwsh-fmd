BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot '../src/Format-Markdown/Format-Markdown.psd1'
    Import-Module $ModulePath -Force
}

Describe 'Format-Markdown' {

    BeforeAll {
        $TestObjects = @(
            [PSCustomObject]@{ Name = 'a'; Value = 1 }
            [PSCustomObject]@{ Name = 'bb'; Value = 22 }
        )
    }

    Context 'Markdown table (default)' {

        BeforeAll {
            $Lines = ($TestObjects | Format-Markdown) -split "`n" | Where-Object { $_ -ne '' }
        }

        It 'wraps the header row in leading and trailing pipes, padded like the inner separators' {
            $Lines[0] | Should -Be '| Name | Value |'
        }

        It 'wraps the separator row in leading and trailing pipes, padded like the inner separators' {
            $Lines[1] | Should -Be '| ---- | ----- |'
        }

        It 'wraps each data row in leading and trailing pipes, padded like the inner separators' {
            $Lines[2] | Should -Be '| a    | 1     |'
            $Lines[3] | Should -Be '| bb   | 22    |'
        }

        It 'pads columns to the widest of the header and its values' {
            $Lines | ForEach-Object { $_.Length | Should -Be $Lines[0].Length }
        }
    }

    Context 'Markdown table with -NoOuterPipes' {

        BeforeAll {
            $Lines = ($TestObjects | Format-Markdown -NoOuterPipes) -split "`n" | Where-Object { $_ -ne '' }
        }

        It 'omits the leading and trailing pipe on the header row' {
            $Lines[0] | Should -Be 'Name | Value'
        }

        It 'omits the leading and trailing pipe on the separator row' {
            $Lines[1] | Should -Be '---- | -----'
        }

        It 'omits the leading and trailing pipe on each data row' {
            $Lines[2] | Should -Be 'a    | 1    '
            $Lines[3] | Should -Be 'bb   | 22   '
        }

        It 'still separates columns with an inner pipe' {
            $Lines[0] | Should -Match '\|'
        }
    }

    Context 'AsJsonTable' {

        BeforeAll {
            $Output = $TestObjects | Format-Markdown -AsJsonTable
            $FenceLines = $Output -split "`n" | Where-Object { $_ -ne '' }
        }

        It 'wraps the payload in a json:table fenced code block' {
            $FenceLines[0] | Should -Be '```json:table'
            $FenceLines[-1] | Should -Be '```'
        }

        It 'emits fields, items, and filter in the JSON payload' {
            $Json = $FenceLines[1] | ConvertFrom-Json
            $Json.fields.key | Should -Be @('Name', 'Value')
            $Json.items.Count | Should -Be 2
            $Json.items[0].Name | Should -Be 'a'
            $Json.items[1].Value | Should -Be 22
            $Json.filter | Should -Be 'true'
        }
    }

    Context 'Column discovery' {

        It 'unions columns across objects with differing properties, in first-seen order' {
            $Objects = @(
                [PSCustomObject]@{ First = 1 }
                [PSCustomObject]@{ First = 2; Second = 'x' }
            )
            $Lines = ($Objects | Format-Markdown) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[0] | Should -Be '| First | Second |'
        }

        It 'skips null property values when computing column width' {
            $Objects = @(
                [PSCustomObject]@{ Name = $null }
                [PSCustomObject]@{ Name = 'longvalue' }
            )
            $Lines = ($Objects | Format-Markdown) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[1] | Should -Be '| --------- |'
        }
    }

    Context 'PadSpaces' {

        It 'defaults to a single space around every pipe' {
            $Lines = ($TestObjects | Format-Markdown) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[0] | Should -Be '| Name | Value |'
        }

        It 'removes all padding around pipes when set to 0' {
            $Lines = ($TestObjects | Format-Markdown -PadSpaces 0) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[0] | Should -Be '|Name|Value|'
        }

        It 'widens the padding around pipes when set above 1' {
            $Lines = ($TestObjects | Format-Markdown -PadSpaces 2) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[0] | Should -Be '|  Name  |  Value  |'
        }

        It 'still applies to the inner separator when -NoOuterPipes is set' {
            $Lines = ($TestObjects | Format-Markdown -NoOuterPipes -PadSpaces 2) -split "`n" | Where-Object { $_ -ne '' }
            $Lines[0] | Should -Be 'Name  |  Value'
        }

        It 'rejects a negative value' {
            { $TestObjects | Format-Markdown -PadSpaces -1 } | Should -Throw
        }
    }

    Context 'fmd alias' {

        It 'is registered as an alias for Format-Markdown' {
            (Get-Alias fmd).Definition | Should -Be 'Format-Markdown'
        }
    }
}
