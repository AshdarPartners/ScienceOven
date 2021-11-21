function Get-SqlServerAgentJobStep {
    <#
    .SYNOPSIS
    Returns SqlServerAgentJobStep data for a specific Sql Instance

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
    Get-DbaAgentJobStep

    .EXAMPLE
    Get-SqlServerAgentJobStep -SqlInstance localhost

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
                    $Items = Get-DbaAgentJobStep -SqlInstance $c -SqlCredential $SqlCredential
                } else {
                    $Items = Get-DbaAgentJobStep -SqlInstance $c
                }

                foreach ($Item in $Items) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)'        = $ScanDateUTC

                        'ComputerName'           = $Item.ComputerName
                        'PSComputerName'         = $Item.ComputerName
                        'InstanceName'           = $Item.InstanceName
                        'SqlInstance'            = $Item.SqlInstance
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'JobName'                = $Item.'AgentJob'
                        'StepID'                 = $item.'StepID'
                        'JobStepName'            = $Item.'Name'
                        'Category'               = $Item.'Category'
                        'Description'            = $Item.'Description'
                        'Command'                = $item.'Command'
                        'Database'               = $item.'Database'
                        'LogFile'                = $item.'LogFile'
                        'OnFailAction'           = $item.'OnFailAction'
                        'OnFailStep'             = $item.'OnFailStep'
                        'OnSuccessAction'        = $item.'OnSuccessAction'
                        'OnSuccessStep'          = $item.'OnSuccessStep'
                        'RetryAttempts'          = $item.'RetryAttempts'
                        'RetryIntervalmins'      = $item.'RetryIntervalmins'
                        'RunAs'                  = $item.'RunAs'
                        'SuccessExitCode'        = $item.'SuccessExitCode'
                        'Type'                   = $item.'Type'

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
