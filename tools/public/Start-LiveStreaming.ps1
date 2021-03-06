function Start-LiveStreaming {
    <#
    .SYNOPSIS
        Starts live streaming in Wirecast.

    .DESCRIPTION
        Starts live streaming based on the Wirecast document name specified.

    .PARAMETER DocumentName
        The document name in the Wirecast window title bar.

    .EXAMPLE
        PS />Start-LiveStreaming -DocumentName 'MultiLang'

        The example above immediately starts live streaming for the
        "MultiLang" document.

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

    Write-Verbose -Message "Begin sleep for $DelayInSeconds seconds"

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Start-LiveStreaming.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Start streaming in Wirecast
    Write-Verbose -Message "Start streaming for $DocumentName"

    try {
        osascript $scptPath $DocumentName
    }#try
    catch {
        Write-Error -Message "Could not start streaming for $DocumentName"
    }#catch
}#function