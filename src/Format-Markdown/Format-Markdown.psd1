@{
    ModuleVersion = '1.1.0'
    GUID = '4ccaec92-6067-444f-8987-0d6dbcc55d8b'
    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2021 - 2023'
    Description = 'Format PowerShell object to Markdown'
    PowerShellVersion = '5.0'
    NestedModules = @('Format-Markdown.psm1')
    FunctionsToExport = 'Format-Markdown'
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = 'fmd'
    PrivateData = @{
        PSData = @{
            LicenseUri   = 'https://github.com/chris-peterson/pwsh-fmd/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/chris-peterson/pwsh-fmd'
            ReleaseNotes = 'https://github.com/chris-peterson/pwsh-fmd/pull/3'
        }
    }
}
