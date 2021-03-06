@{
    PSDependOptions = @{
        Target = 'CurrentUser'
    }

    # This package is needed to gather data for Subject Areas.
    # IOW, you can't run ScienceOven without dbatools-it is a required dependency.
    # 1.1.0 was the "last big release", as of 2021/08/27
    'dbatools' = @{
        Version = '1.1.0'
    }

    # These four packages are mainly for "the build system" or frameworked testing that build.ps does.
    # IOW, they aren't needed to use ScienceOven, specifically.
    'BuildHelpers' = @{
        Version = '2.0.16'
    }
    'PowerShellBuild' = @{
        Version = '0.6.1'
    }
    'psake' = @{
        Version = '4.9.0'
    }
    'PSScriptAnalyzer' = @{
        Version = '1.19.1'
    }

    # FIXME: Pester install/version collides with the 5.2.2 installed in ubuntu testrunner in Github Actions.
    # The root cause seems to be that the testrunner has it installed Scope=AllUser, while we are trying to install it
    # as Scope=CurrentUser. I usually install "stuff" as Scope=CurrentUser on my dev machine. Is that so wrong?
    # 'Pester'        = @{
    #     Version    = '5.2.2'
    #     Parameters = @{
    #         SkipPublisherCheck = $true
    #     }
    # }

}
