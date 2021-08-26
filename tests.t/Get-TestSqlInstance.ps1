<#
.EXAMPLE
$SqlInstance = .\Get-TestSqlInstance.ps1
#>

param(
    [string] $SqlInstance
)

if ($SqlInstance) {
    $SqlInstance
} elseif ($ENV:TEST_SQLINSTANCE) {
    $ENV:TEST_SQLINSTANCE
} else {
    'localhost'
}
