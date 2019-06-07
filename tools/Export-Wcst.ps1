function Export-Wcst {
    <#
    .SYNOPSIS
        Exports a Wirecast template as a working file.

    .DESCRIPTION
        Exports a Wirecast template as a working file to be used for a live
        stream event.

        Export-Wcst copies the XML template file to a working folder where
        the file is used for production within Wirecast. Both files must
        be .wcst files.

    .PARAMETER TemplatePath
        The path to the Wirecast template file.

    .PARAMETER Destination
        The path to where the working Wirecast file will be saved to.

    .EXAMPLE
        PS />Export-Wcst -TemplatePath ~/Desktop/MyTemplate.wcst `
        >> -Destination ~/Desktop/MyMainProduction.wcst

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            HelpMessage = 'The source path of the template',
            Mandatory   = $true,
            Position    = 1
        )]
        [ValidateScript( { $_ -match '\.wcst$' } )]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf } )]
        [System.IO.FileInfo]
        $TemplatePath,

        [Parameter(
            HelpMessage = 'The destination path of the working file',
            Mandatory   = $true,
            Position    = 2
        )]
        [ValidateScript( { $_ -match '\.wcst$' } )]
        [ValidateScript( {
                Test-Path -Path (Split-Path -Path $_ -Parent) -PathType Container } )]
        [System.IO.FileInfo]
        $Destination
    )

    Write-Verbose -Message "Begin .wcst export ..."
    Write-Verbose -Message "- Wirecast template is $TemplatePath"
    Write-Verbose -Message "- Production file destination is $Destination"

    try {
        Write-Verbose -Message "- Copying $TemplatePath to $Destination"

        Copy-Item -Path $TemplatePath -Destination $Destination -Force -ErrorAction Stop
    } # try
    catch {
        Write-Error -Message "Could not export template $TemplatePath to destination $Destination"
    } # catch

    Write-Verbose -Message "Finished .wcst export"
} # function