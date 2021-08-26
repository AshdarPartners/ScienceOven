<#
.EXAMPLE
$SqlCredential = .\Get-TestCredential.ps1
#>
param (
    [string] $Username = 'sa',
    [securestring] $Password
)

if ($Password) {
    $SecureString = ConvertTo-SecureString -AsPlainText $Password -Force

}
else {
    $SecureString = ConvertTo-SecureString -AsPlainText $env:SA_PASSWORD -Force
}

New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $SecureString
