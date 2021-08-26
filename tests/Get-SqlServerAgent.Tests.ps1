BeforeDiscovery {
    # BeforeAll {
    $moduleName = $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    # $outputDir          = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    # $outputModDir       = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    # $outputModVerDir    = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    # $outputManifestPath = Join-Path -Path $outputModVerDir -Child "$($moduleName).psd1"
    # $manifestData       = Test-ModuleManifest -Path $outputManifestPath -Verbose:$false -ErrorAction Stop -WarningAction SilentlyContinue

    $Path = Split-Path -Path $PSScriptRoot -Parent
    $Path = Join-Path -Path $Path -ChildPath $moduleName
    $Path = Join-Path -Path $Path -ChildPath ($moduleName + '.psd1')

    $ModuleInfo = Import-Module -Name $Path -Force -PassThru

    $filename = $MyInvocation.MyCommand.Name.Replace('.Tests.ps1', '')

}

<#
I borrowed the general structure of this from github.com/Pester/Pester/blobl/main/tst/Help.Tests.ps1

I dreamed up the Name = $_.Name stuff and the Invoke-Expression stuff by myself, with Google's help.

I like this because it will automatically add testing for any functions I add to the module.

This could be an issue when/if I add a funtion that doesn't have -Computer as a parameter.

# FIXME: We aren't testing the -Credential feature at all.

# FIXME: For the future, must be able to *externally* specify a computer name & a credential to test against & use

#>
# Describe "General Test $moduleName" -ForEach @{ExportedFunctions = $ExportedFunctions; moduleName = $ModuleName; SqlInstance = $SqlInstance } {
Describe "Tests for $filename" -Tag $Filename, SqlServerAgent, SQLServer {

    BeforeAll {
        $SqlInstance = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlInstance.ps1'))

        $SqlCredential = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlCredential.ps1'))

        $cp = @{
            SqlInstance   = $SqlInstance
            SqlCredential = $SqlCredential
        }

        # I will mimic the dbatools testing workflow when I need to.
        $server = Connect-DbaInstance @cp -Database 'master'
        $server.Query("EXEC msdb.dbo.sp_add_alert @name=N'test alert',@message_id=0,@severity=6,@enabled=1,@delay_between_responses=0,@include_event_description_in=0,@category_name=N'[Uncategorized]',@job_id=N'00000000-0000-0000-0000-000000000000'")
        $null = New-DbaAgentOperator @cp -Operator 'DBA' -Force -EmailAddress 'operator@operator.com' -PagerDay 'Everyday'
        $null = New-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -FrequencyType 'Monthly' -FrequencyInterval 10 -FrequencyRecurrenceFactor 1 -Force
    }

    AfterAll {
        $SqlInstance = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlInstance.ps1'))

        $SqlCredential = (Invoke-Expression -Command (Join-Path -Path $PSScriptRoot -ChildPath 'Get-TestSqlCredential.ps1'))

        $cp = @{
            SqlInstance   = $SqlInstance
            SqlCredential = $SqlCredential
        }
        $server = Connect-DbaInstance @cp -Database 'master'
        $server.Query("EXEC msdb.dbo.sp_delete_alert @name=N' test alert'")
        $null = Remove-DbaAgentOperator @cp -Operator 'DBA' -Confirm:$false
        $null = Remove-DbaAgentSchedule @cp -Schedule 'scienceoven_MonthlyTest' -Confirm:$false

    }

    Context 'Get-SqlServerAgentConfiguration' {
        It 'Returns some/any output for Get-SqlServerAgentConfiguration' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerAgentJob' {
        It 'Returns some/any output for Get-SqlServerAgentJob' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerAgentJobStep' {
        It 'Returns some/any output for Get-SqlServerAgentJobStep' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    Context 'Get-SqlServerAgentSchedule' {
        It 'Returns some/any output for Get-SqlServerAgentSchedule' {
            Get-SqlServerAgentSchedule @cp | Should -Not -BeNullOrEmpty
            # Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    # There are "Job alerts" and there are "Agent Alerts". DbaTools supports Get-DbaAgentAlert only.
    Context 'Get-SqlServerAgentJobAlert' {
        It 'Returns some/any output for Get-SqlServerAgentJobAlert' {
            Set-ItResult -Skipped -Because 'cmdlet has not been written yet.'
        }
    }

    # there is no Dbatools\Get=DbaAgentJobNotification.
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