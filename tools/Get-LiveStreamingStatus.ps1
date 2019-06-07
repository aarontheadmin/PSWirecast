function Get-LiveStreamingStatus {
    <#
    .SYNOPSIS
        Gets established TCP connections used by Wirecast.

    .DESCRIPTION
        Get-LiveStreamingStatus reports if Wirecast is still
        streaming by matching Established TCP connections to
        Local and Remote URL specified in the PSWirecast.json
        file.

    .EXAMPLE
        PS />Get-LiveStreamingStatus

        The example above returns all TCP connections used by
        Wirecast.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCustomObject
    #>
    [CmdletBinding()]
    param ()

    [string]$upStreamURL = (Get-BroadcastSetting).UpstreamURL

    [string]$localURL = $upStreamURL |
        Select-Object -Property Name, URL |
        Where-Object -Property Name -eq Local |
        Select-Object -ExpandProperty URL

    Write-Verbose -Message "Local stream URL is $localURL"

    [string]$remoteURL = $upStreamURL |
        Select-Object -Property Name, URL |
        Where-Object -Property Name -eq Remote |
        Select-Object -ExpandProperty URL

    Write-Verbose -Message "Remote stream URL is $remoteURL"

    [System.Collections.ArrayList] $urlList = @()
    $urlList.Add($localURL) | Out-Null
    $urlList.Add($remoteURL) | Out-Null


    [pscustomobject]$liveStreams = foreach ($address in $urlList.GetEnumerator()) {

        [string]$hostName = [System.Uri]$address | Select-Object -Expand DnsSafeHost

        Write-Verbose -Message "Retrieving established TCP connections ..."

        try {
            Get-MacOsTcpConnection |
            Where-Object -FilterScript {
                $_.Command -eq 'Wirecast' -and
                $_.Name -match "$hostName" -and
                $_.Name -match ':1935'
            } # Where-Object

            Write-Verbose -Message "Finished retrieving established TCP connections"
        } # try
        catch {
            Write-Error -Message "Could not get established connections"
        } # catch
    } # foreach

    Write-Output -InputObject $liveStreams
} # function