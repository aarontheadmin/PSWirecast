function Set-WcstShot {
    <#
    .SYNOPSIS
        Sets the active shot in Wirecast.

    .DESCRIPTION
        Sets the active shot in Wirecast based on the document name, shot name and layer specified.

    .PARAMETER DocumentName
        The name of the document to set the shot in.

    .PARAMETER LayerName
        The name of the layer where the shot is (in Wirecast).

    .PARAMETER Name
        The name of the shot.

    .EXAMPLE
        PS />Set-WcstShot -Name PROGRAM -LayerName 'Master Layer 1' -DocumentName 'MultiLang'

        The example above sets the active shot to the 'PROGRAM' shot in 'Master Layer 1'
        of the 'MultiLang' document.

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

        [Parameter(Mandatory = $true)]
        [string]
        $LayerName,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    Write-Verbose -Message "Begin setting shot in Wirecast"

    [string]$scptPath = [System.IO.Path]::Combine((Get-VirtualOperatorPath), 'scpt', 'Set-WcstShot.scpt')
    Write-Verbose -Message "- Script path is $scptPath"
    Write-Verbose -Message "- Wirecast document name is $DocumentName"
    Write-Verbose -Message "- Layer is $LayerName"
    Write-Verbose -Message "- Shot is $Name"

    if ($PSCmdlet.ShouldProcess("Set Wirecast shot")) {
        try {
            Write-Verbose -Message "- Setting shot to $Name in $DocumentName"
            osascript $scptPath $DocumentName $LayerName $Name
        } # try
        catch {
            Write-Error -Message "Could not set shot for $Document"
        } # catch
        Write-Verbose -Message "Finished setting shot in Wirecast"
    }
} # function