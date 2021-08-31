BeforeDiscovery {
    # BeforeAll {
    $moduleName = $env:BHProjectName
    # $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    # $outputDir          = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    # $outputModDir       = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    # $outputModVerDir    = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    # $outputManifestPath = Join-Path -Path $outputModVerDir -Child "$($moduleName).psd1"
    # $manifestData       = Test-ModuleManifest -Path $outputManifestPath -Verbose:$false -ErrorAction Stop -WarningAction SilentlyContinue

    $Path = Split-Path -Path $PSScriptRoot -Parent
    $Path = Join-Path -Path $Path -ChildPath $moduleName
    $Path = Join-Path -Path $Path -ChildPath ($moduleName + '.psd1')

    # $ModuleInfo = Import-Module -Name $Path -Force -PassThru

    $SubjectArea = (Split-Path -Path $PSCommandPath -Leaf) -Replace 'Get\-','' -Replace '.Tests.ps1',''

}

<#
I borrowed the general structure of this from github.com/Pester/Pester/blobl/main/tst/Help.Tests.ps1

I dreamed up the Name = $_.Name stuff and the Invoke-Expression stuff by myself, with Google's help.

I like this because it will automatically add testing for any functions I add to the module.

This could be an issue when/if I add a funtion that doesn't have -Computer as a parameter.

#>
Describe "Tests for Subject Area '$SubjectArea'" -Tag $SubjectArea, SQLServer {

    BeforeAll {
        $SqlInstance = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlInstance.ps1'))

        $SqlCredential = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlCredential.ps1'))

        $cp = @{
            SqlInstance   = $SqlInstance
            SqlCredential = $SqlCredential
        }

        # I am mimicking the dbatools Pester code when. SqlCollaborative knows more about using dbatools in tests than I do...
        $server = Connect-DbaInstance @cp -Database 'master'
        # $server.Query("EXEC msdb.dbo.sp_add_alert @name=N'test alert',@message_id=0,@severity=6,@enabled=1,@delay_between_responses=0,@include_event_description_in=0,@category_name=N'[Uncategorized]',@job_id=N'00000000-0000-0000-0000-000000000000'")
        # $null = New-DbaAgentOperator @cp -Operator 'DBA' -Force -EmailAddress 'operator@operator.com' -PagerDay 'Everyday'
        # $null = New-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -FrequencyType 'Monthly' -FrequencyInterval 10 -FrequencyRecurrenceFactor 1 -Force
    }

    AfterAll {
        $SqlInstance = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlInstance.ps1'))

        $SqlCredential = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlCredential.ps1'))

        $cp = @{
            SqlInstance   = $SqlInstance
            SqlCredential = $SqlCredential
        }
        $server = Connect-DbaInstance @cp -Database 'master'
        # $server.Query("EXEC msdb.dbo.sp_delete_alert @name=N' test alert'")
        # $null = Remove-DbaAgentOperator @cp -Operator 'DBA' -Confirm:$false
        # $null = Remove-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -Confirm:$false

    }

    Context 'Get-SQLServerDatabaseConfigurationOverview' {
        It 'Returns some/any output for Get-SQLServerDatabaseConfigurationOverview' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationGeneral' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationGeneral' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationFile' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationFile' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationFileGroup' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationFileGroup' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationOption' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationOption' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationAlwaysOn' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationAlwaysOn' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationChangeTracking' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationChangeTracking' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationPermission' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationPermission' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerDatabaseConfigurationMirroring' {
        It 'Returns some/any output for Get-SqlServerDatabaseConfigurationMirroring' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-' {
        It 'Returns some/any output for Get-' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

}
