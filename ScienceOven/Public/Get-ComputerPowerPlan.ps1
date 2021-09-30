<#

FIXME: (#5) PowerPlan script fails due to various odd errors.
https://github.com/ashdar/ScienceOven/issues/5

#>
function Get-ComputerPowerPlan {
    <#
    .SYNOPSIS
    Returns PowerPlan data for a specific computer

    .DESCRIPTION
    Returns PowerPlan data for a specific computer

    .NOTES
    This cmdlet requires 'Run As Adminstrator" if you run it against the local system, either by providing the name of the
    computer you are 'running on' or 'localhost'. If you provide the name of a remote computer, your local session does not
    require elevation. Of course, your must be running with credentials that have adminstrative permissions on the remote
    computer or you must provide a $Credential parameter with such permissions.

    The attributes given here are influenced by the columns in the "PowerPlan" tab of the "SQL Server Inventory - Windows" workbook.

    This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

    .PARAMETER Computer
    What is the Computer of interest?

    .PARAMETER ScanDateUTC
    You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time. Default is the
    current time, in UTC.

    .PARAMETER Credential
    What credential should be used? The default is to use the current user credential.

    .EXAMPLE
    Get-ComputerPowerPlan -Computer localhost

    Runs the command
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [string[]] $Computer,
        [datetime] $ScanDateUTC = (Get-Date).ToUniversalTime(),
        [System.Management.Automation.PSCredential] $Credential

        # FIXME: I might really want to pass a CIMSession parameter here. Do I?
        # FIXME: If I have a $Credential, do I need a CIMSession? Or vice versa?

    )

    begin {
        $NameSpace = 'root\CIMV2'
    }

    process {
        try {

            foreach ($c in $Computer) {

                if ($Credential) {
                    $CIMSession = New-CimSession -ComputerName $c -Credential $Credential
                } else {
                    $CIMSession = New-CimSession -ComputerName $c
                }

                $CIMComputerSystem = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_ComputerSystem'
                $CIMOperatingSystem = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_OperatingSystem'

                $CIMPowerPlan = Get-CimInstance -CimSession $CIMSession -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan'
                # $CIMPowerPlan = Get-CimInstance  -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan'

                foreach ($Item in $CIMPowerPlan) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)' = $ScanDateUTC

                        'Computer Name'   = $CIMOperatingSystem.CSName
                        'PSComputerName'  = $CIMComputerSystem.PSComputerName
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'ElementName'     = $Item.'ElementName'
                        'Description'     = $Item.'Description'
                        'IsActive'        = $Item.'IsActive'
                    }
                    $Props
                }
            }
        }

        catch {
            Throw
        }
    }

    end {

    }
}

