try {
    Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse |
    ForEach-Object -Process { . ($_.FullName) }
}
catch {
    Write-Error -Message $_
}