function Get-SqlServerDatabaseFileGroup {
    <#
    .SYNOPSIS
    Returns SqlServerDatabaseFileGroup data for a specific Sql Instance

    .DESCRIPTION
    Returns VideoAdapter data for a specific computer

    .NOTES
    The attributes given here are influenced by the columns in the relevant worksheet of the "SQL Server Inventory - Database Engine Config" workbook.

    This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

    .PARAMETER SqlInstance
    What is the Sql Server instance of interest?

    .PARAMETER ScanDateUTC
    You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time. Default is the
    current time, in UTC.

    .PARAMETER SqlCredential
    What credential should be used? The default is to use the current user credential.

    .LINK
    Get-DbaAgentJob

    .EXAMPLE
    Get-SqlServerDatabaseFileGroup -SqlInstance localhost

    Runs the command
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [string[]] $SqlInstance,
        [datetime] $ScanDateUTC = (Get-Date).ToUniversalTime(),
        [System.Management.Automation.PSCredential] $SqlCredential

    )

    begin {

    }

    process {
        try {

            foreach ($c in $SqlInstance) {

                if ($SqlCredential) {
                    $Items = Get-DbaDbFileGroup -SqlInstance $c -SqlCredential $SqlCredential
                } else {
                    $Items = Get-DbaDbFileGroup -SqlInstance $c
                }

                foreach ($Item in $Items) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)' = $ScanDateUTC

                        'ComputerName'    = $Item.ComputerName
                        'PSComputerName'  = $Item.ComputerName
                        'InstanceName'    = $Item.InstanceName
                        'SqlInstance'     = $Item.SqlInstance
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'DatabaseName'    = ($Item.'Parent').ToString().Replace('[', '').Replace(']', '')
                        'FileGroupName'   = $Item.'Name'
                        'Files'           = ($Item.'Files').Count
                        'IsDefault'       = $Item.'IsDefault'

                        'IsReadOnly'      = $Item.'ReadOnly'
                        'Type'            = $Item.'FileGroupType'
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
