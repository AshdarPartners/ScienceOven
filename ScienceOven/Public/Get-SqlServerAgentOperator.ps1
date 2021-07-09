function Get-SqlServerAgentOperator {
    <#
    .SYNOPSIS
    Returns SqlServerAgentOperator data for a specific Sql Instance

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
    Get-DbaAgentOperator

    .EXAMPLE
    Get-SqlServerAgentOperator -SqlInstance localhost

    Runs the command
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [string[]] $SqlInstance,
        [datetime] $ScanDateUTC = (Get-Date -AsUTC),
        [System.Management.Automation.PSCredential] $SqlCredential

    )

    begin {

    }

    process {
        try {

            foreach ($c in $SqlInstance) {

                if ($SqlCredential) {
                    $Items = Get-DbaAgentOperator -SqlInstance $c -SqlCredential $SqlCredential
                } else {
                    $Items = Get-DbaAgentOperator -SqlInstance $c
                }

                foreach ($Item in $Items) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)'        = $ScanDateUTC

                        'ComputerName'                  = $Item.ComputerName
                        'PSComputerName'                = $Item.ComputerName
                        'InstanceName'                  = $Item.InstanceName
                        'SqlInstance'                   = $Item.SqlInstance
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'CategoryName'           = $Item.'CategoryName'
                        'EmailAddress'           = $Item.'EmailAddress'
                        'Enabled'                = $Item.'Enabled'

                        'RelatedJobs'            = $Item.'RelatedJobs'
                        'RelatedAlerts'          = $Item.'RelatedAlerts'

                        'LastEmailDate'          = $Item.'LastEmailDate'
                        'LastNetSendDate'        = $Item.'LastNetSendDate'
                        'LastPagerDate'          = $Item.'LastPagerDate'

                        'WeekdayPagerStartTime'  = $Item.'WeekdayPagerStartTime'
                        'WeekdayPagerEndTime'    = $Item.'WeekdayPagerEndTime'

                        'SaturdayPagerStartTime' = $Item.'SaturdayPagerStartTime'
                        'SaturdayPagerEndTime'   = $Item.'SaturdayPagerEndTime'

                        'SundayPagerStartTime'   = $Item.'SundayPagerStartTime'
                        'SundayPagerEndTime'     = $Item.'SundayPagerEndTime'

                        'NetSendAddress'         = $Item.'NetSendAddress'
                        'OperatorName'           = $Item.'Name'
                        'PagerAddress'           = $Item.'PagerAddress'
                        'PagerDays'              = $Item.'PagerDays'

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
