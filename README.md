# ScienceOven

Simplify SQL Server documentation

## Overview
The basic idea is something like SQLPowerDoc, but focused more on retrieving data into PowerShell data structures (allowing for
easier export into whatever format is desired (CSV, HTML, XLXS, the RDBMS of choice, Confluence and so forth) and focused less on
server discovery (which I feel should be the responsibility of some other tool) and the formatting of the data.

And no use of GZ files. I never understood that choice.

The main driver of this is that the SQL PowerDoc code that I've been using since I downloaded it from CodePlex isn't as stable as I'd like
and doesn't give me the format(s) that I want. There are few forks of SQL PowerDoc on Github, but none seem to be actively developed and,
even if they are, it still isn't _quite_ what I want.

Plus, I'd like to have a "fully fledged" GitHub project, with a "devops" pipeline and all the trimmings.
## Installation
Eventually, I hope to wire this into the well-established GitHub/PSGallery scheme.

## Build Issues
I used Platypus to generate this project because it seemed to be what the cool kids did. Platypus wrote a build.ps1 for me and created a requirements.psd1 file. This file specifies certain modules and version levels, and specifies that they should be installed in the scope of 'CurrentUser'.

The problem is that the task runners that Github Actions provide already have Pester installed in the 'AllUser' scope.
When build.ps1 does not notice that the requested version of Pester is installed, so it tries to install it and fails.
Apparently, you can't the same version of a module installed as CurrentUser and AllUser. Rather than trying to bug-fix
PSDepends, I am just pulling out the Pester requirement information and putting it into requirements.other.psd1, for
safe-keeping. The chances are any machine you run on will have Pester installed, though it might be an old version. If
you are trying to test locally, you will find that the Tests.ps1 files are written for Pester 5.x (though they might be compatible with 4.x too) and that the really old, 'default' versions of Pester will choke on the new syntax.

## Examples
FIXME: We need some examples.
