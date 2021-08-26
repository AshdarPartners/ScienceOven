@{
    PSDependOptions = @{
        Target = 'CurrentUser'
    }

    'Pester'        = @{
        Version    = '5.2.2'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
}
