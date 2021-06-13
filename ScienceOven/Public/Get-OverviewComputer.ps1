function Get-OverviewComputer {
    <#
    .SYNOPSIS
    Returns overview data for a specific computer

    .DESCRIPTION
    Returns overview data for a specific computer

    .PARAMETER Computer
    What is the Computer of interest?

    .PARAMETER Credential
    What credential should be used? The default is to use the current user credential.

    .EXAMPLE
    PS> Get-OverviewComputer

    Runs the command
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    param (

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [string[]] $Computer,
        [System.Management.Automation.PSCredential] $Credential

        # FIXME: I might really want to pass a CIMInstance here

    )

    begin {

    }

    process {
        try {

            # FIXME: Obviously, this is just roughed-in until I get some aspects of the build system sorted.

            # $ci = New-CimSession -ComputerName $Computer
            # $ci
            # $r = Get-CimInstance -CimSession $ci -ClassName 'win32_computersystem'

            $o = [PSCustomObject] @{
                'Computer Name'         = $Computer
                'Machine Name'         = 'hal9000'
                'Scan Date (UTC)'      = Get-Date -AsUTC
                'Manufacturer'         = 'foo'
                'Product Name'         = 'foo'
                'Product ID'           = 'foo'
                'Product Version'      = 'foo'
                'Operating System'     = 'foo'
                'Version'              = 'foo'
                'Service Pack'         = 'foo'
                'Install Date (UTC)'   = 'bar'
                'Domain'               = 'foo'
                'Role'                 = 'foo'
                'Physical Processors'  = 'foo'
                'Processor Cores'      = 'foo'
                'Logical Processors'   = 'foo'
                'Physical Memory (MB)' = -1
                'Logical Drives'       = 'C: (99.48 GB);  D: (1,023.87 GB);'

            }
            $o
        }
        catch {
            Throw
        }
    }

    end {

    }
}


#
# if (-not $c) {
#     $c = Get-Credential -UserName 'corp\dstrait'
# }

# Get-OverviewComputer -verbose -Computer 'PHOBOS' -Credential $c
