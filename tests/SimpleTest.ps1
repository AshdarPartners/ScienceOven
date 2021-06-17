<#
.SYNOPSIS
This is a simple test script, not a Pester test script, not part of the build system.

.NOTES
This is super-rough right now, I just want to make it a little easier to run debugging sessions

#>

# $CmdletName = $MyInvocation.MyCommand.Name.Replace('.Tests.ps1', '')

$Path = $(Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition))
$Path = Join-Path -Path $Path -ChildPath 'ScienceOven'
$ManifestFile = (Get-ChildItem  -Path $Path -Filter '*.psd1').FullName
Import-Module $ManifestFile -DisableNameChecking -Force


#
# if (-not $c) {
#     $c = Get-Credential -UserName 'corp\dstrait'
# }

$Computers = @(
    'hera'
    'juno'
    'zeus'
)

# Get-OverviewComputer -verbose -Computer 'PHOBOS' -Credential $c
Get-OverviewComputer -Computer $Computers
# Get-OverviewComputer -Computer zeus

<#
Here are the names of the worksheets in the ""
Overview
Physical Memory
Processor
Network Adapter
Printer
CD & DVD Drive
Disk Drive
Tape Drive
Video Adapter
Event Log
IPV4 Route
Page File
Registry
Power Plans
Startup Commands
Processes
Services
Shares
Local Groups
Local Users
Desktop Sessions
Applications
Patches


#>
