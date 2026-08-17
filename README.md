# Overview

There were quite a few solutions out there for converting PSObject to markdown table.

None of them did quite what I was looking for, so I borrowed the best parts from each.

Most of the credit goes to:

* https://github.com/microsoft/FormatPowerShellToMarkdownTable
* https://www.powershellgallery.com/packages/PSMarkdown/1.1/Content/ConvertTo-Markdown.ps1

## Usage

`Install-Module Format-Markdown`
### Short Example

`gci | select Name,FullName | fmd`
```text
| Name      | FullName                                                      |
| --------- | ------------------------------------------------------------- |
| src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src       |
| LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE   |
| README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md |
```

### Longhand Examples

#### Markdown Table

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown
```
```text
| Name      | FullName                                                      |
| --------- | ------------------------------------------------------------- |
| src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src       |
| LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE   |
| README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md |
```

By default, each row is wrapped in a leading and trailing pipe, per the
[GFM table spec's recommended style](https://github.github.com/gfm/#tables-extension-),
padded with a space on each side of every pipe - inner separators and outer
wrapping alike. Two switches control that:

* `-NoOuterPipes` - drop the leading/trailing pipe for the leaner style some renderers produce.
* `-PadSpaces <n>` - change the padding width (default `1`); `0` packs every pipe tight against its neighboring cell.

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown -NoOuterPipes
```
```text
Name      | FullName                                                     
--------- | -------------------------------------------------------------
src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src      
LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE  
README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md
```

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown -PadSpaces 0
```
```text
|Name     |FullName                                                     |
|---------|-------------------------------------------------------------|
|src      |/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src      |
|LICENSE  |/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE  |
|README.md|/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md|
```

#### JSON Table

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown -AsJsonTable
```
```json
{"fields":[{"key":"Name","sortable":"true","label":"Name"},{"key":"FullName","sortable":"true","label":"FullName"}],"items":[{"Name":"README.md","FullName":"/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md"},{"Name":"README.md","FullName":"/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md"},{"Name":"README.md","FullName":"/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md"}],"filter":"true"}
```
