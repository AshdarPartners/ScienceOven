# Dot source public/private functions

$PublicPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$public  = @(Get-ChildItem -Path $PublicPath -filter '*.ps1'  -Recurse -ErrorAction Stop)

# We might not actually have an Private functions, so be careful

$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'
$private = @(Get-ChildItem -Path $PrivatePath -filter '*.ps1' -Recurse -ErrorAction Stop)

foreach ($import in @($public + $private)) {
    try {
        . $import.FullName
    } catch {
        throw "Unable to dot source [$($import.FullName)]"
    }
}

Export-ModuleMember -Function $public.Basename
