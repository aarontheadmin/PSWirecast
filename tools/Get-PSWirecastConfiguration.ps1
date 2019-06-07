function Get-PSWirecastConfiguration {
    <#
    .SYNOPSIS
        Gets the live streaming operations configuration for Wirecast.

    .DESCRIPTION
        Gets the live streaming configuration for Wirecast by loading the entire
        PSWirecast.json file into PowerShell objects.

    .EXAMPLE
        PS />Get-PSWirecastConfiguration

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCustomObject
    #>
    [CmdletBinding()]
    param ()

    Write-Verbose -Message "Begin search for configurations in PSWirecast.json"

    [string]$pswConfigPath = Join-Path -Path $MyInvocation.MyCommand.Module.ModuleBase -ChildPath PSWirecast.config
    Write-Verbose -Message "- Path to config file pointing to JSON path is $pswConfigPath"

    [System.IO.StreamReader]$streamReader = New-Object -TypeName System.IO.StreamReader($pswConfigPath) -ErrorAction Stop
    Write-Verbose -Message "- Created System.IO.StreamReader object to read JSON path in $pswConfigPath"

    [string] $pswJsonFilePath = $streamReader.ReadLine() -replace '.*='
    Write-Verbose -Message "- JSON config file path is $pswJsonFilePath"


    $streamReader.Dispose()
    Remove-Variable streamReader

    Write-Verbose -Message "- Removed System.IO.StreamReader object"

    [hashtable]$params = @{
        Raw         = $true
        Path        = $pswJsonFilePath
        ErrorAction = 'Stop'
    }#hashtable

    Write-Verbose -Message "- Retrieving JSON content from $pswJsonFilePath"

    Get-Content @params | ConvertFrom-Json

    Write-Verbose -Message "Finished search for configurations in PSWirecast.json"
} # function