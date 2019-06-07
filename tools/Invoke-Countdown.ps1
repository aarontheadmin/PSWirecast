function Invoke-Countdown {
    <#
    .SYNOPSIS
        Counts down in seconds.

    .DESCRIPTION
        Counts down in seconds with a progress bar.

    .PARAMETER Seconds
        The time in seconds to countdown from.

    .EXAMPLE
        PS />Invoke-Countdown -Seconds 900

    .INPUTS
        None

    .OUTPUTS
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 65535)]
        [uint16]
        $Seconds
    )

    for ([uint16]$i = $Seconds; $i -gt 1; $i--) {

        [hashtable]$params = @{
            Activity         = "[$(Get-Date)]`tTimer ends in:"
            SecondsRemaining = $i
            PercentComplete  = (($i / $Seconds) * 100)
        } # hashtable

        Write-Progress @params

        Start-Sleep 1
    } # for
} # function