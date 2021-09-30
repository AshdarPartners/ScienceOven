function Get-ComputerProcessor {
    <#
    .SYNOPSIS
    Returns Processor data for a specific computer

    .DESCRIPTION
    Returns Processor data for a specific computer

    .NOTES
    The attributes given here are influenced by the columns in the "Processor" tab of the "SQL Server Inventory - Windows" workbook.

    This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

    .PARAMETER Computer
    What is the Computer of interest?

    .PARAMETER ScanDateUTC
    You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time. Default is the
    current time, in UTC.

    .PARAMETER Credential
    What credential should be used? The default is to use the current user credential.

    .EXAMPLE
    Get-ComputerProcessor -Computer localhost

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

                <#
                On multiprocessor systems, all processors should be the same, at least for this "Processor" report. So, we just
                look at the first processor in the list of processors. For more detail, like Stepping data, we would want a
                per-processor report. That might be a Good Thing, but not here and not today.
                #>
                $CIMProcessor = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_Processor'

                $Item = $CIMProcessor[0]

                $Props = [PSCustomObject] @{
                    'Scan Date (UTC)'          = $ScanDateUTC

                    'Computer Name'            = $CIMOperatingSystem.CSName
                    'PSComputerName'           = $CIMComputerSystem.PSComputerName
                    # How many attributes with (nearly) the same meaning do we need?
                    # 'Machine Name'         = $CIMComputerSystem.Name

                    # 'Physical Processors' = ($CIMProcessor).Count
                    'Number Of Cores'          = $Item.NumberOfCores
                    'Logical Processors'       = $Item.NumberOfLogicalProcessors

                    'Data Width'               = $Item.DataWidth
                    'Description'              = $Item.Description
                    'External Clock Frequency' = $Item.ExtClock
                    'FamilyID'                 = $Item.Family
                    # FIXME: Lookup a string for .Family?
                    # 'FamilyDescription'        = $Item.Family
                    'Hyperthreading'           = (($CIMProcessor.Count) -eq ($CIMProcessor | ForEach-Object { $_.SocketDesignation } | Select-Object -Unique ).Count )
                    'L2 Cache Size'            = $Item.L2CacheSize
                    'L2 Cache Speed'           = $Item.L2CacheSpeed
                    'L3 Cache Size'            = $Item.L3CacheSize
                    'L3 Cache Speed'           = $Item.L3CacheSpeed
                    'Manufacturer'             = $Item.Manufacturer
                    'Max Clock Speed'          = $Item.MaxClockSpeed
                    'Processor Name'           = $Item.Name
                    'Revision'                 = $Item.Revision
                    'Stepping'                 = $Item.Stepping
                    'ProcessorId'              = $Item.ProcessorId

                }
                $Props
            }
        }

        catch {
            Throw
        }
    }

    end {

    }
}
