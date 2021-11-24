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

    Get-Module -All -Name $moduleName | Remove-Module
    $ModuleInfo = Import-Module -Name $Path -Force -PassThru

    <#
    The "Get-Computer" tests have a different parameter set than the "Get-SqlServer" tests, so discriminate which set of cmdlets we are
    testing here.
    #>
    $ExportedFunctions = Get-Command -CommandType Cmdlet, Function -Module $moduleName | Where-Object { $_.Name -match '^Get\-Computer' }

    $WindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsIdentity)
    $AdministratorRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $IsElevated = $WindowsPrincipal.IsInRole($AdministratorRole)

}

<#
I borrowed the general structure of this from github.com/Pester/Pester/blobl/main/tst/Help.Tests.ps1

I dreamed up the Name = $_.Name stuff and the Invoke-Expression stuff by myself, with Google's help.

I like this because it will automatically add testing for any functions I add to the module.

This could be an issue when/if I add a funtion that doesn't have -Computer as a parameter.

# FIXME: We aren't testing the -Credential feature at all.

# FIXME: For the future, must be able to *externally* specify a computer name & a credential to test against & use

#>
Describe "General Test $moduleName" -ForEach @{ExportedFunctions = $ExportedFunctions; moduleName = $ModuleName } -Tag Computer {

    Context '<_.CommandType> <_.Name>' -Foreach $ExportedFunctions {

        It 'Returns some/any output for <Computer>' -TestCases @{Computer = 'localhost'; Name = $_.Name } {

            if (($Computer -eq 'localhost') -and ('Get-ComputerOpticalDrive' -contains $Name)) {
                Set-ItResult -Skipped -Because 'optical drives are rare on modern servers and cmdlet often returns no result'
            } elseif (($Computer -eq 'localhost') -and ('Get-ComputerTapeDrive' -contains $Name)) {
                Set-ItResult -Skipped -Because 'tape drives are rare on modern servers and cmdlet often returns no result'
            } elseif ((-not $IsElevated) -and ('Get-ComputerPowerPlan' -contains $Name)) {
                Set-ItResult -Skipped -Because 'the test must run in an elevated session to access Power Plan data'
            } else {
                Invoke-Expression "$Name -Computer $Computer" | Should -Not -BeNullOrEmpty
            }
        }

    }
}
