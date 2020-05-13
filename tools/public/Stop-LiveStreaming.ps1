function Stop-LiveStreaming {
    <#
    .SYNOPSIS
        Stops live streaming in Wirecast.

    .DESCRIPTION
        Stops live streaming in Wirecast before the streaming is actually stopped.

    .PARAMETER DocumentName
        The document name in the Wirecast window title bar.

    .EXAMPLE
        PS />Stop-LiveStreaming -DocumentName 'MultiLang'

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $DocumentName
    )

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Stop-LiveStreaming.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Stop streaming in Wirecast
    Write-Verbose -Message "Stop streaming for $DocumentName"

    try {
        osascript $scptPath $DocumentName
        Write-Output -InputObject "Stopped streaming in $DocumentName"
    }#try
    catch {
        Write-Error -Message "Could not stop streaming in $DocumentName"
    }#catch
} # function