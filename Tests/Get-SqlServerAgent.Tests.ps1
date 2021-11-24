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

    Get-Module -All -Name $moduleName | Remove-Module
    $ModuleInfo = Import-Module -Name $Path -Force -PassThru

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
        $server.Query("EXEC msdb.dbo.sp_add_alert @name=N'ScienceOvenTestAlert',@message_id=0,@severity=6,@enabled=1,@delay_between_responses=0,@include_event_description_in=0,@category_name=N'[Uncategorized]',@job_id=N'00000000-0000-0000-0000-000000000000'")

        $null = New-DbaAgentOperator @cp -Operator 'ScienceOvenTestOperator' -Force -EmailAddress 'operator@nowhere.com' -PagerDay 'Everyday'
        $null = New-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -FrequencyType 'Monthly' -FrequencyInterval 10 -FrequencyRecurrenceFactor 1 -Force

        $null = New-DbaAgentJob @cp -Job 'ScienceOvenTestJob' -Description 'A test job for ScienceOven unit tests'
        $null = New-DbaAgentJobStep @cp -Job 'ScienceOvenTestJob' -StepName 'Step1' -Command 'select getdate()'
    }

    AfterAll {
        $SqlInstance = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlInstance.ps1'))

        $SqlCredential = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlCredential.ps1'))

        $cp = @{
            SqlInstance   = $SqlInstance
            SqlCredential = $SqlCredential
        }
        $server = Connect-DbaInstance @cp -Database 'master'
        $null = Remove-DbaAgentJob @cp -Job 'ScienceOvenTestJob'
        $null = Remove-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -Confirm:$false

        # $null = New-DbaAgentJobStep @cp -Job 'ScienceOvenTestJob' -StepName 'Step1' -Command 'select getdate()'
        $null = Remove-DbaAgentOperator @cp -Operator 'ScienceOvenTestOperator' -Confirm:$false

        $server.Query("EXEC msdb.dbo.sp_delete_alert @name=N'ScienceOvenTestAlert'")

    }

    Context 'Get-SqlServerAgentConfiguration' {
        It 'Returns some/any output for Get-SqlServerAgentConfiguration' {
            # Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
            Get-SqlServerAgentConfiguration @cp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-SqlServerAgentJob' {
        It 'Returns some/any output for Get-SqlServerAgentJob' {
            # Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
            Get-SqlServerAgentJob @cp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-SqlServerAgentJobStep' {
        It 'Returns some/any output for Get-SqlServerAgentJobStep' {
            # Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
            Get-SqlServerAgentJobStep @cp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-SqlServerAgentSchedule' {
        It 'Returns some/any output for Get-SqlServerAgentSchedule' {
            Get-SqlServerAgentSchedule @cp | Should -Not -BeNullOrEmpty
        }
    }

    # There are "Job alerts" and there are "Agent Alerts". DbaTools supports Get-DbaAgentAlert only.
    Context 'Get-SqlServerAgentJobAlert' {
        It 'Returns some/any output for Get-SqlServerAgentJobAlert' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    # there is no Dbatools\Get-DbaAgentJobNotification.
    Context 'Get-SqlServerAgentJobNotification' {
        It 'Returns some/any output for Get-SqlServerAgentJobNotification' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    # There are "Job alerts" and there are "Agent Alerts". DbaTools supports Get-DbaAgentAlert only.
    Context 'Get-SqlServerAgentAlert' {
        It 'Returns some/any output for Get-SqlServerAgentAlert' {
            Get-SqlServerAgentAlert @cp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-SqlServerAgentOperator' {
        It 'Returns some/any output for Get-SqlServerAgentOperator' {
            Get-SqlServerAgentOperator @cp | Should -Not -BeNullOrEmpty
        }
    }
}
