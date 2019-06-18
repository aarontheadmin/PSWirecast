function Start-WcstRecording {
    <#
    .SYNOPSIS
        Starts recording in Wirecast.

    .DESCRIPTION
        Starts recording in Wirecast (based on the document name specified).

    .PARAMETER DocumentName
        The document name in the Wirecast window title bar.

    .EXAMPLE
        PS />Start-WcstRecording -DocumentName 'MultiLang'

        The example above immediately starts recording in Wirecast for
        the "MultiLang" document.

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

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Start-WcstRecording.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Start recording in Wirecast
    Write-Verbose -Message "Start recording for $DocumentName"

    if ($PSCmdlet.ShouldProcess("Start Wirecast recording")) {
        try {
            osascript $scptPath $DocumentName
        } # try
        catch {
            Write-Error -Message "Could not start recording for $DocumentName"
        } # catch
    }
} # function