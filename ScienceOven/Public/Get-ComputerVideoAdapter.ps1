function Get-ComputerVideoAdapter {
    <#
    .SYNOPSIS
    Returns VideoAdapter data for a specific computer

    .DESCRIPTION
    Returns VideoAdapter data for a specific computer

    .NOTES
    The attributes given here are influenced by the columns in the "VideoAdapter" tab of the "SQL Server Inventory - Windows" workbook.

    This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

    .PARAMETER Computer
    What is the Computer of interest?

    .PARAMETER ScanDateUTC
    You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time. Default is the
    current time, in UTC.

    .PARAMETER Credential
    What credential should be used? The default is to use the current user credential.

    .EXAMPLE
    Get-ComputerVideoAdapter -Computer localhost

    Runs the command
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [string[]] $Computer,
        [datetime] $ScanDateUTC = (Get-Date -AsUTC),
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
                $CIMVideoAdapter = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_VideoController'

                foreach ($Item in $CIMVideoAdapter) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)' = $ScanDateUTC

                        'Computer Name'   = $CIMOperatingSystem.CSName
                        'PSComputerName'  = $CIMComputerSystem.PSComputerName
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'Compatibility'   = $Item.'AdapterCompatibility'
                        'Name'            = $Item.'Name'
                        'RAM Bytes'       = $Item.'AdapterRAM'
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
