function Stop-LiveStreaming {
    <#
    .SYNOPSIS
        Stops live streaming in Wirecast.

    .DESCRIPTION
        Stops live streaming in Wirecast and can have a delay (in seconds) before the
        streaming is actually stopped.

    .PARAMETER DocumentName
        The document name in the Wirecast window title bar.

    .PARAMETER DelayInSeconds
        The delay in seconds before the broadcast is triggered to
        stop. The valid range is between 0 and 3600 seconds, inclusive.

        0 seconds (default) stops the broadcast immediately.

    .EXAMPLE
        PS />Stop-LiveStreaming -DocumentName 'MultiLang'

        The example above will stop live streaming "MultiLang" in 0 seconds.

    .EXAMPLE
        PS />Stop-LiveStreaming -DocumentName 'English Streaming' -DelayInSeconds 900

        The example above will stop live streaming "English Streaming" in
        15 minutes.

    .EXAMPLE
        PS />Stop-LiveStreaming -DocumentName 'English Streaming' -DelayInSeconds 60

        The example above will stop live streaming "English Streaming" in
        60 seconds.

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

    Write-Verbose -Message "Begin countdown for $DelayInSeconds seconds"

    Invoke-Countdown -Seconds $DelayInSeconds

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Stop-LiveStreaming.scpt')
    Write-Verbose -Message "Script path is $scptPath"

    # Stop streaming in Wirecast
    Write-Verbose -Message "Stop streaming for $DocumentName"

    if ($PSCmdlet.ShouldProcess("Stop live streaming")) {
        try {
            osascript $scptPath $DocumentName
            Write-Output -InputObject "Stopped streaming in $DocumentName"
        } # try
        catch {
            Write-Error -Message "Could not stop streaming in $DocumentName"
        } # catch
    }
} # function