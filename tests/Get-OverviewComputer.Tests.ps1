BeforeAll {
    $moduleName         = $env:BHProjectName
    $manifest           = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    # $outputDir          = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    # $outputModDir       = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    # $outputModVerDir    = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    # $outputManifestPath = Join-Path -Path $outputModVerDir -Child "$($moduleName).psd1"
    # $manifestData       = Test-ModuleManifest -Path $outputManifestPath -Verbose:$false -ErrorAction Stop -WarningAction SilentlyContinue

    # $FileName = Split-Path -Path $PSScriptRoot -LeafBase
    # there has to be a better way to get the cmdletname from the name of this Pester test.
    $CmdletName = 'Get-OverviewComputer.ps1'

    $Path = Split-Path -Path $PSScriptRoot -Parent
    $Path = Join-Path -Path $Path -ChildPath $moduleName
    $Path = Join-Path -Path $Path -ChildPath 'Public'
    $Path = Join-Path -Path $Path -ChildPath $CmdletName

    #C:\Users\dstrait\repo\ashdar\ScienceOven\ScienceOven\Public\Get-OverviewComputer.ps1
    . $Path
}

Describe "Get-OverviewComputer" {
    It "Returns some output" {
        Get-OverviewComputer -Computer 'localhost' | Should -Not -BeNullOrEmpty
    }
}
