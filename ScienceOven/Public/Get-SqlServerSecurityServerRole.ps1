function Get-SqlServerSecurityServerRole {
    <#
    .SYNOPSIS
    Returns SqlServerSecurityServerRole data for a specific Sql Instance

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

    .EXAMPLE
    Get-SqlServerSecurityServerRole -SqlInstance localhost

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
                    $cp = @{
                        SqlInstance = $c
                        SqlCredential = $SqlCredential
                    }
                } else {
                    $cp = @{
                        SqlInstance = $c
                    }
                }
                $Roles = Get-DbaServerRole @cp

                foreach ($Role in $Roles) {

                    $Props = [PSCustomObject] @{
                        'Scan Date (UTC)'  = $ScanDateUTC

                        'ComputerName'     = $Role.ComputerName
                        'PSComputerName'   = $Role.ComputerName
                        'InstanceName'     = $Role.InstanceName
                        'SqlInstance'      = $Role.SqlInstance
                        # How many attributes with (nearly) the same meaning do we need?
                        # 'Machine Name'         = $CIMComputerSystem.Name

                        'RoleName'         = $Role.'Name'
                        'IsFixedRole'      = $Role.'IsFixedRole'

                        # "Member Definition", in the original Power SQL Doc output this provides DDL to add members to the role
                        # It's super-unlikely than anyone would want to do that based on documentation, if they did they could
                        # write commands pretty quickly. So, we won't bother providing it here.
                        # 'MemberDefinition' = $Role.'MemberDefinition'

                        # FIXME: It's not immediately apparent, given my test environments and the original Power SQL Doc output,
                        # what "MemberOf" meas, here. Is it the other roles that this role is a member of? Fixed Server roles
                        # usuially aren't handled that way, are they?
                        # 'MemberOf'         = $Role.'MemberOf'

                        'Members'          = (Get-DbaServerRoleMember @cp -ServerRole $Role.'Name').Name
                        'Owner'            = $Role.'Owner'

                        'CreateDate'       = $Role.'DateCreated'
                        'ModifyDate'       = $Role.'DateModified'
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
