# <img src="favicon.svg" alt="pwsh-fmd" width="64" height="64" style="vertical-align: middle"> pwsh-fmd

Format PowerShell objects to Markdown tables.

## Installation

```powershell
Install-Module Format-Markdown
```

## Usage

### Short Example

```powershell
gci | select Name,FullName | fmd
```

```text
Name      | FullName
--------- | -------------------------------------------------------------
src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src
LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE
README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md
```

### Markdown Table

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown
```

```text
Name      | FullName
--------- | -------------------------------------------------------------
src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src
LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE
README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md
```

### JSON Table

```powershell
Get-ChildItem | Select-Object Name,FullName | Format-Markdown -AsJsonTable
```

```json
{"fields":[{"key":"Name","sortable":"true","label":"Name"},{"key":"FullName","sortable":"true","label":"FullName"}],"items":[{"Name":"README.md","FullName":"/Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md"}],"filter":"true"}
```
