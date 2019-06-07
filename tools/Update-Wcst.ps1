function Update-Wcst {
    <#
    .SYNOPSIS
        Updates a Wirecast working file.

    .DESCRIPTION
        Updates a Wirecast working file to include a "Record To Disk" path,
        "Record To Disk XML" element index, and the upstream server URL.

        The "Record To Disk XML" element index is the location in the XML file
        where the "Record To Disk" path is stored. By specifying the correct XML
        element index, the filename of the master file will be correctly stored
        and used for recording in Wirecast.

        For example, the XML file would have the following snippet inside the <output> element at index 6:

        <document ...>
            ...
            <advanced_output>
                <output_list ...>
                    <output ...>     index 0
                    <output ...>     index 1
                    <output ...>     index 2
                    <output ...>     index 3
                    <output ...>     index 4
                    <output ...>     index 5
                    <output ...     index 6 (attributes below)
                        output_branding="Record To Disk MP4 Brand" output_display_group_name="Record To Disk - MP4" ...>
                </output_list>
            </advanced_output>
            ...
        </document>

        In this case, the -RecordToDiskXMLElementIndex would be 6. This would update the element's output_url attribute with the
        RecordToDiskPath. At the same time, all (rtmp) output_url attributes for live streams are updated to the UpstreamType
        specified.

        All settings are saved back to the working copy XML file.

    .PARAMETER Path
        The path to the .wcst file to update.

    .PARAMETER RecordToDiskPath
        The path to where the output master file will get saved to
        disk.

    .PARAMETER RecordToDiskXMLElementIndex
        The index number for the output_branding = "Record To Disk MP4 Brand"
        XML element in the .wcst XML file. Specifying this index allows the
        output_url to be updated with the correct Record To Disk path each
        time a new event is created.

    .PARAMETER UpstreamType
        The upstream type is Local or Remote. Local points to the
        local IP or DNS address, and Remote points to the public IP or
        DNS address specified in the PSWirecast.json file.

    .EXAMPLE
        PS />Update-Wcst -Path ~/Desktop/Main.wcst -RecordToDiskPath ~/Desktop/MasterMP4.mp4 `
        >> -RecordToDiskXMLElementIndex 6 -UpstreamType Local

        The example above updates Main.wcst on the desktop with the
        RecordToDiskPath set as /Users/User5/Desktop/MasterMP4.mp4,
        the RecordToDisk's element index is 6 (where the RecordToDiskPath
        is stored in the XML), and the upstream type to Local which will
        point to an IP such as 192.168.50.10.

    .EXAMPLE
        PS />Update-Wcst -Path ~/Desktop/Main.wcst -RecordToDiskPath ~/Desktop/MasterMP4.mp4 `
        >> -RecordToDiskXMLElementIndex 6 -UpstreamType Remote

        The example above updates Main.wcst on the desktop with the
        RecordToDiskPath set as /Users/User5/Desktop/MasterMP4.mp4,
        the RecordToDisk's element index is 6 (where the RecordToDiskPath
        is stored in the XML),and the upstream type to Remote which will
        point to a public domain such as broadcast.mysite.com.

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateScript( { $_ -match '\.wcst$' })]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf })]
        [System.IO.FileInfo]
        $Path,

        [Parameter(
            Mandatory = $true,
            Position = 2)]
        [ValidateScript( { $_ -match '\.mp4$' })]
        [ValidateScript( {
                Test-Path -Path (Split-Path -Path $_ -Parent) -PathType Container })]
        [System.IO.FileInfo]
        $RecordToDiskPath,

        [Parameter(Mandatory = $true)]
        [byte]
        $RecordToDiskXMLElementIndex,

        [Parameter()]
        [ValidateSet('Local', 'Remote')]
        $UpstreamType = 'Local'
    )

    Write-Verbose -Message "Begin provisioning of .wcst production file ..."
    Write-Verbose -Message "- Path is $Path"
    Write-Verbose -Message "- Record-to-disk path is $RecordToDiskPath"
    Write-Verbose -Message "- Record-to-disk XML element index is $RecordToDiskXMLElementIndex"
    Write-Verbose -Message "- Upstream/uplink type is $UpstreamType"

    try {
        [xml]$wcstXML = Get-Content -Path $Path -ErrorAction Stop

        # Change the output[] index to match the position in the .wcst XML for "Record To Disk" path
        $wcstXML.document.advanced_output.output_list.output[$RecordToDiskXMLElementIndex].output_url = $RecordToDiskPath
        Write-Verbose -Message "- Setting output for XML element index to $RecordToDiskPath"

        # Update upstream URL in output_url of XML document
        Write-Verbose -Message "- Getting UpstreamURL from JSON"
        [pscustomobject]$upstreamURLObj = (Get-BroadcastSetting).UpstreamURL

        [string]$wcstBroadcastURL = $upstreamURLObj |
        Select-Object -Property Name, URL |
        Where-Object -Property Name -eq $UpstreamType |
        Select-Object -ExpandProperty URL

        Write-Verbose -Message "- $UpstreamType upstream/uplink URL is $wcstBroadcastURL"
        Write-Verbose -Message "- Updating all stream URLs to $wcstBroadcastURL"

        $oldUpstream = $wcstXML.document.advanced_output.output_list.output
        $oldUpstream |
        Where-Object -FilterScript { $_.output_url -match '^rtmp://' } |
        ForEach-Object {
            $_.output_url = $wcstBroadcastURL
        } # Where-Object

        if ($PSCmdlet.ShouldProcess("Update Wirecast document")) {
            $wcstXML.Save($Path)
            Write-Verbose -Message "- Saving changes for $Path"
        }
    } # try
    catch {
        Write-Error -Message $_
    } # catch
    finally {
        Write-Verbose -Message "Finished provisioning of .wcst production file"
    }
} # function