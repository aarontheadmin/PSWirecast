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

    .EXAMPLE
        PS />Start-LiveStreaming -DocumentName 'MultiLang' -DelayInSeconds 30

        The example above starts live streaming for the "MultiLang" document
        after 30 seconds have expired.

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $DocumentName,

        [Parameter()]
        [ValidateRange(0, 3600)]
        [uint16]
        $DelayInSeconds = 0
    )

    Write-Verbose -Message "Begin sleep for $DelayInSeconds seconds"

    Start-Sleep -Seconds $DelayInSeconds -ErrorAction Stop

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Start-LiveStreaming.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Start streaming in Wirecast
    Write-Verbose -Message "Start streaming for $DocumentName"

    if ($PSCmdlet.ShouldProcess("Start live streaming")) {
        try {
            osascript $scptPath $DocumentName
        } # try
        catch {
            Write-Error -Message "Could not start streaming for $DocumentName"
        } # catch
    }
} # function