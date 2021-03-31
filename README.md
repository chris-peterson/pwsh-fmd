# Overview

There were quite a few solutions out there for converting PSObject to markdown table.

None of them did quite what I was looking for, so I borrowed the best parts from each.

Most of the credit goes to:

* https://github.com/microsoft/FormatPowerShellToMarkdownTable
* https://www.powershellgallery.com/packages/PSMarkdown/1.1/Content/ConvertTo-Markdown.ps1

## Example
`gci | fmd Name,FullName`
```text
Name      | FullName
--------- | -------------------------------------------------------------
src       | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/src
LICENSE   | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/LICENSE
README.md | /Users/cpeterson/src/github/chris-peterson/pwsh-fmd/README.md
```