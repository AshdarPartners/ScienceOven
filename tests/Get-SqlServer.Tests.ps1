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

    <#
    The "Get-Computer" tests have a different parameter set than the "Get-SqlServer" tests, so discriminate which set of cmdlets we are
    testing here.
    #>
    $ExportedFunctions = Get-Command -CommandType Cmdlet, Function -Module $moduleName | Where-Object { $_.Name -match '^Get\-SqlServer' }

}

<#
I borrowed the general structure of this from github.com/Pester/Pester/blobl/main/tst/Help.Tests.ps1

I dreamed up the Name = $_.Name stuff and the Invoke-Expression stuff by myself, with Google's help.

I like this because it will automatically add testing for any functions I add to the module.

This could be an issue when/if I add a funtion that doesn't have -Computer as a parameter.

# FIXME: We aren't testing the -Credential feature at all.

# FIXME: For the future, must be able to *externally* specify a computer name & a credential to test against & use

#>
Describe "General Test $moduleName" -ForEach @{ExportedFunctions = $ExportedFunctions; moduleName = $ModuleName } -Skip {
<#
This is set to -Skip because I am having difficulty resolving "run a cmdlet specified in a string" and "Specify a -Credential".
I can't seem to find a way to simultaneously do both. Maybe doing both at the same time is a bad idea from a security perspective.
#>
    BeforeAll {
        $null = New-DbaAgentOperator -SqlInstance 'localhost' -SqlCredential $SqlCredential -Operator 'DBA' -Force -EmailAddress 'operator@operator.com' -PagerDay Everyday
    }

    AfterAll {
        $null = Remove-DbaAgentOperator -SqlInstance 'localhost' -SqlCredential $SqlCredential -Operator 'DBA' -Confirm:$false
    }

    Context '<_.CommandType> <_.Name>' -Foreach $ExportedFunctions {

        It 'Returns some/any output for <SqlInstance>' -TestCases @{ExportedFunctionName = $_.Name; SqlInstance = 'localhost' } {
            # Invoke-Expression "$ExportedFunctionName -Computer $Computer"  | Should -Not -BeNullOrEmpty
            # Invoke-Command -scriptblock {$ExportedFunctionName -Computer $Computer -Credential $SqlCredential}   | Should -Not -BeNullOrEmpty
            # Invoke-Command -scriptblock {Get-SqlServerAgentOperator -SqlInstance 'localhost' -SqlCredential $SqlCredential}   | Should -Not -BeNullOrEmpty
            # Invoke-Command -scriptblock {Get-SqlServerAgentOperator -SqlInstance $SqlInstance -SqlCredential $SqlCredential}   | Should -Not -BeNullOrEmpty
            $sb = [ScriptBlock]::Create("Get-SqlServerAgentOperator -SqlInstance $SqlInstance ")
            Invoke-Command -scriptblock $sb -computer . -Credential $SqlCredential  | Should -Not -BeNullOrEmpty

            # Invoke-Command -scriptblock {Get-SqlServerAgentOperator -SqlInstance $SqlInstance -SqlCredential $SqlCredential}   | Should -Not -BeNullOrEmpty
        }
    }
}
