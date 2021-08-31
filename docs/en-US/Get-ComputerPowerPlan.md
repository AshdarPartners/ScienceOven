---
external help file: ScienceOven-help.xml
Module Name: ScienceOven
online version:
schema: 2.0.0
---

# Get-ComputerPowerPlan

## SYNOPSIS
Returns PowerPlan data for a specific computer

## SYNTAX

```
Get-ComputerPowerPlan [-Computer] <String[]> [[-ScanDateUTC] <DateTime>] [[-Credential] <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns PowerPlan data for a specific computer

## EXAMPLES

### EXAMPLE 1
```
Get-ComputerPowerPlan -Computer localhost
```

Runs the command

## PARAMETERS

### -Computer
What is the Computer of interest?

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ScanDateUTC
You can pass in the date of the scan, which could be handy for tying all report-gathering to the same time.
Default is the
current time, in UTC.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-Date -AsUTC)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
What credential should be used?
The default is to use the current user credential.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
This cmdlet requires 'Run As Adminstrator" if you run it against the local system, either by providing the name of the
computer you are 'running on' or 'localhost'.
If you provide the name of a remote computer, your local session does not
require elevation.
Of course, your must be running with credentials that have adminstrative permissions on the remote
computer or you must provide a $Credential parameter with such permissions.

The attributes given here are influenced by the columns in the "PowerPlan" tab of the "SQL Server Inventory - Windows" workbook.

This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

## RELATED LINKS
