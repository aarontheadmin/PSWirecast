function Open-Wcst {
    <#
    .SYNOPSIS
        Opens a Wirecast document.

    .DESCRIPTION
        Opens a Wirecast document based on the Path specified.

    .PARAMETER Path
        The path to the Wirecast document to open.

    .EXAMPLE
        PS />Open-Wcst -Path /Users/Me/Documents/MainBroadcast.wcst

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ -match '\.wcst$' })]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf } )]
        [System.IO.FileInfo]
        $Path
    )

    try {
        open $Path
    } # try
    catch {
        Write-Error -Message "Could not open $Path"
        break
    } # catch
} # function