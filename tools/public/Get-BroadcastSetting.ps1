function Get-BroadcastSetting {
    <#
    .SYNOPSIS
        Gets the Wirecast broadcast configuration.

    .DESCRIPTION
        Get-BroadcastSetting gets all metadata stored in the PSWirecast.json
        in the "Broadcast" object and returns them as PowerShell objects.

    .EXAMPLE
        PS />Get-BroadcastSetting

        The example above outputs the multitrack settings stored in the
        PSWirecast.json file.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCustomObject
    #>
    [CmdletBinding()]
    param ()

    (Get-PSWirecastConfiguration).Broadcast
} # function