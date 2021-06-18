function Get-OverviewComputer {
    <#
    .SYNOPSIS
    Returns overview data for a specific computer

    .DESCRIPTION
    Returns overview data for a specific computer

    .NOTES
    The attributes given here are influenced by the columns in the "Overview" tab of the "SQL Server Inventory - Windows" workbook.

    This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

    .PARAMETER Computer
    What is the Computer of interest?

    .PARAMETER ScanDateUTC
    You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time. Default is the
    current time, in UTC.

    .PARAMETER Credential
    What credential should be used? The default is to use the current user credential.

    .EXAMPLE
    Get-OverviewComputer -Computer zeus

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

                $CIMSession = New-CimSession -ComputerName $c

                $CIMComputerSystem = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_ComputerSystem'
                $CIMOperatingSystem = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_OperatingSystem'
                $CIMVolumes = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_Volume'
                $CIMComputerSystemProduct = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_ComputerSystemProduct'
                <#
                On multiprocessor systems, all processors should be the same, at least for this "overview" report. So, we just
                look at the first processor in the list of processors. For more detail, like Stepping data, we would want a
                per-processor report. That might be a Good Thing, but not here and not today.
                #>
                $CIMProcessor = Get-CimInstance -CimSession $CIMSession -Namespace $NameSpace -ClassName 'Win32_Processor'

                <#
                This string mimics what SqlPowerDoc provided. I'm not sure of it's utility, but this is just "overview" data.
                A more rational, detailed format can be in a different report.
                #>
                [string] $LogicalDrive = ''
                foreach ($Volume in $CIMVolumes | Where-Object { $_.DriveType -eq 3 -and $_.DriveLetter } ) {
                    $LogicalDrive += '{0} ({1:0.00} GB); ' -f $Volume.DriveLetter, ($Volume.Capacity / 1GB)
                }
                $LogicalDrive = $LogicalDrive.TrimEnd('; ')

                $Props = @{
                    'Scan Date (UTC)'     = $ScanDateUTC

                    'Computer Name'       = $CIMOperatingSystem.CSName
                    'PSComputerName'      = $CIMComputerSystem.PSComputerName
                    # How many attributes with (nearly) the same meaning do we need?
                    # 'Machine Name'         = $CIMComputerSystem.Name

                    'Manufacturer'        = $CIMComputerSystemProduct.Vendor
                    'Product Name'        = $CIMComputerSystemProduct.Name
                    'Product ID'          = $CIMComputerSystemProduct.IdentifyingNumber
                    'Product Version'     = $CIMComputerSystemProduct.Version

                    'Operating System'    = $CIMOperatingSystem.Caption
                    'Version'             = $CIMOperatingSystem.Version
                    'Service Pack'        = $CIMOperatingSystem.ServicePackMajorVersion # fixme: Should I concat ServicePackMinorVersion here?

                    'Install Date (UTC)'  = $CIMOperatingSystem.InstallDate

                    'Description'         = $CIMOperatingSystem.Description

                    'Domain'              = $CIMComputerSystem.Domain
                    # FIXME: DomainRole is an integer, probably want to translate this
                    'DomainRole'          = $CIMComputerSystem.DomainRole

                    'Physical Processors' = ($CIMProcessor).Count
                    'Processor Cores'     = $CIMProcessor[0].NumberOfCores
                    'Logical Processors'  = $CIMProcessor[0].NumberOfLogicalProcessors

                    'Physical Memory'     = $CIMComputerSystem.TotalPhysicalMemory
                    'Logical Drives'      = $LogicalDrive

                }
                New-Object -TypeName PSObject -Property $Props
            }
        }

        catch {
            Throw
        }
    }

    end {

    }
}
