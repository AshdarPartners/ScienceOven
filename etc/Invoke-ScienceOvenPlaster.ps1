<#
.SYNOPSIS
A working file to make it easier to build a new project.

.NOTES
This script should only be run once, but it provides some useful/historical documentation

I do not remember, off the top of my head, if Plaster presented me with any choices or what my decisions were.
I suspect that I let it create the MD documentation files, though I have never really worked with them.

The whole ".\Output" directory and building various "versioned" things there seems like overkill to me, but I will just
tell git to ignore those files and continue.

install-module Plaster,Stucco -scope CurrentUser
#>

$NewModuleName = 'ScienceOven'
$plasterDest = Join-Path -Path '..\..\' -ChildPath $NewModuleName

# do I want to use this fancy template or the default template?

if ($false) {
    # this is the default template name
    $PlasterTemplateTitle = 'New PowerShell Manifest Module'
    $defaultTemplate = Get-PlasterTemplate |
        Where-Object -FilterScript { $PSItem.Title -eq $PlasterTemplateTitle }
}

else {
    $PlasterTemplateTitle = 'High-Quality PowerShell Module Template'
    $defaultTemplate = Get-StuccoTemplate |
        Where-Object -FilterScript { $PSItem.Title -eq $PlasterTemplateTitle }
}


$cp = @{
    TemplatePath    = $defaultTemplate.TemplatePath
    DestinationPath = $plasterDest
    ModuleName      = $NewModuleName
    Version         = '0.0.1'
    Verbose         = $true
    NoLogo          = $true
}

if ($false) {
    # do not accientally run this!
    Invoke-Plaster @cp
}

