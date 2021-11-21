function Get-SqlServerAgentConfiguration {
    <#
    .SYNOPSIS
    Returns SqlServerAgentConfiguration data for a specific Sql Instance

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
    Get-DbaAgentConfiguration

    .EXAMPLE
    Get-SqlServerAgentConfiguration -SqlInstance localhost

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
                    $Items = Get-DbaAgentServer -SqlInstance $c -SqlCredential $SqlCredential
                } else {
                    $Items = Get-DbaAgentServer -SqlInstance $c
                }

                foreach ($Item in $Items) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)'           = $ScanDateUTC

                        'ComputerName'              = $Item.ComputerName
                        'PSComputerName'            = $Item.ComputerName
                        'InstanceName'              = $Item.InstanceName
                        'SqlInstance'               = $Item.SqlInstance
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name' = $Item.Name
                        'Name'                      = $Item.'Name'
                        'JobHistoryIsEnabled'       = $Item.'JobHistoryIsEnabled'
                        'JobCategories'             = $Item.'JobCategories'
                        'OperatorCategories'        = $Item.'OperatorCategories'
                        'AlertCategories'           = $Item.'AlertCategories'
                        'AlertSystem'               = $Item.'AlertSystem'
                        # 'Alerts'                = $Item.'Alerts'
                        'Operators'                 = $Item.'Operators'
                        # 'TargetServers'         = $Item.'TargetServers'
                        # 'TargetServerGroups'    = $Item.'TargetServerGroups'
                        # 'Jobs'                  = $Item.'Jobs'
                        'SharedSchedules'           = $Item.'SharedSchedules'
                        # 'ProxyAccounts'         = $Item.'ProxyAccounts'
                        'SysAdminOnly'              = $Item.'SysAdminOnly'
                        'AgentDomainGroup'          = $Item.'AgentDomainGroup'
                        'AgentLogLevel'             = $Item.'AgentLogLevel'
                        'AgentMailType'             = $Item.'AgentMailType'
                        'AgentShutdownWaitTime'     = $Item.'AgentShutdownWaitTime'
                        'DatabaseMailProfile'       = $Item.'DatabaseMailProfile'
                        'ErrorLogFile'              = $Item.'ErrorLogFile'
                        'HostLoginName'             = $Item.'HostLoginName'
                        'IdleCpuDuration'           = $Item.'IdleCpuDuration'
                        'IdleCpuPercentage'         = $Item.'IdleCpuPercentage'
                        'IsCpuPollingEnabled'       = $Item.'IsCpuPollingEnabled'
                        'JobServerType'             = $Item.'JobServerType'
                        'LocalHostAlias'            = $Item.'LocalHostAlias'
                        'LoginTimeout'              = $Item.'LoginTimeout'
                        'MaximumHistoryRows'        = $Item.'MaximumHistoryRows'
                        'MaximumJobHistoryRows'     = $Item.'MaximumJobHistoryRows'
                        'NetSendRecipient'          = $Item.'NetSendRecipient'
                        'ReplaceAlertTokensEnabled' = $Item.'ReplaceAlertTokensEnabled'
                        'SaveInSentFolder'          = $Item.'SaveInSentFolder'
                        'ServiceAccount'            = $Item.'ServiceAccount'
                        'ServiceStartMode'          = $Item.'ServiceStartMode'
                        'SqlAgentAutoStart'         = $Item.'SqlAgentAutoStart'
                        'SqlAgentMailProfile'       = $Item.'SqlAgentMailProfile'
                        'SqlAgentRestart'           = $Item.'SqlAgentRestart'
                        'SqlServerRestart'          = $Item.'SqlServerRestart'
                        'WriteOemErrorLog'          = $Item.'WriteOemErrorLog'
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
