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

    $ExportedFunctions = Get-Command -CommandType Cmdlet, Function -Module $moduleName
}

<#
I borrowed the general structure of this from github.com/Pester/Pester/blobl/main/tst/Help.Tests.ps1

I dreamed up the Name = $_.Name stuff and the Invoke-Expression stuff by myself, with Google's help.

I like this because it will automatically add testing for any functions I add to the module.

This could be an issue when/if I add a funtion that doesn't have -Computer as a parameter.

Another problem is that we aren't testing the -Credential feature at all.
#>
Describe "General Test $moduleName" -ForEach @{ExportedFunctions = $ExportedFunctions; moduleName = $ModuleName } {

    Context '<_.CommandType> <_.Name>' -ForEach $ExportedFunctions {

        It 'Does not throw for <Computer>' -TestCases @{Computer = 'localhost'; Name = $_.Name } {
            {Invoke-Expression "$Name -Computer $Computer"} | Should -Not -Throw
        }

        It 'Returns some/any output for <Computer>' -TestCases @{Computer = 'localhost'; Name = $_.Name  } {
            Invoke-Expression "$Name -Computer $Computer" | Should -Not -BeNullOrEmpty
        }

    }
}
