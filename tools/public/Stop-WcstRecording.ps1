function Stop-WcstRecording {
    <#
    .SYNOPSIS
        Stops recording in Wirecast.

    .DESCRIPTION
        Stops recording based on the Wirecast document
        name specified.

    .PARAMETER DocumentName
        The document name in the Wirecast window title bar.

    .EXAMPLE
        PS />Stop-WcstRecording -DocumentName 'MultiLang'

        The example above immediately stops recording for the
        "MultiLang" document and on the HyperDeck.

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $DocumentName
    )

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Stop-WcstRecording.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Stop recording in Wirecast
    Write-Verbose -Message "Stop recording for $DocumentName"

    if ($PSCmdlet.ShouldProcess("Stop Wirecast recording")) {
        try {
            osascript $scptPath $DocumentName
        } # try
        catch {
            Write-Error -Message "Could not stop recording for $DocumentName"
        } # catch
    }
} # function