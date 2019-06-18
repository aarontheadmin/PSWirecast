function Get-MacOsTcpConnection {
    <#
    .SYNOPSIS
        Gets established TCP network connections.

    .DESCRIPTION
        Gets established TCP network connections.

    .EXAMPLE
        PS />Get-MacOsTcpConnection


        SizeOffset: 0t0
        Device    : 0x95a801d5eeaa641
        PID       : 715
        FD        : 72u
        Type      : IPv4
        Node      : TCP
        Command   : firefox
        User      : MacUser
        Name      : 10.0.3.30: 65323->23.100.72.34: 443 (ESTABLISHED)

        The example above lists one of many (truncated output) established TCP connections.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCustomObject
    #>
    [CmdletBinding()]
    param ()

    if (-not ($IsMacOS)) {
        Write-Output -InputObject "Requires macOS"
        return
    }

    Write-Verbose -Message "Getting ESTABLISHED TCP connections"
    $establishedConnection = lsof '-i' '-P' | grep '-i' "ESTABLISHED"

    Write-Verbose "Looping through established TCP connections"
    foreach ($conn in $establishedConnection) {
        [array]$tcpConnData = $conn -split '\s+', 9

        [hashtable]$tcpConnection = @{
            Command    = $tcpConnData[0]
            PID        = $tcpConnData[1]
            User       = $tcpConnData[2]
            FD         = $tcpConnData[3]
            Type       = $tcpConnData[4]
            Device     = $tcpConnData[5]
            SizeOffset = $tcpConnData[6]
            Node       = $tcpConnData[7]
            Name       = $tcpConnData[8]
        } # hashtable

        New-Object -TypeName psobject -Property $tcpConnection
    } # foreach
    Write-Verbose "Finished looping through established TCP connections"
} # function