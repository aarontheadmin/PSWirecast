function Get-VirtualOperatorPath {
    <#
    .SYNOPSIS
        Gets the VirtualOperator path from the PSWirecast.json file.

    .DESCRIPTION
        Gets the VirtualOperator path from the PSWirecast.json file by
        calling Get-PSWirecastConfiguration.

        VirtualOperator is a path that points to script files that do
        the actual work, such as invoking AppleScript to complete an action in
        Wirecast, like start streaming.

    .EXAMPLE
        PS />Get-VirtualOperatorPath
        /Users/Me/Documents/Wirecast/VirtualOperator

    .INPUTS
        None

    .OUTPUTS
        System.String
    #>
    [CmdletBinding()]
    param ()

    (Get-PSWirecastConfiguration).Path.VirtualOperatorPath

} # function