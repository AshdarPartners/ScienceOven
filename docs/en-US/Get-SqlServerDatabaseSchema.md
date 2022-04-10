---
external help file: ScienceOven-help.xml
Module Name: ScienceOven
online version:
schema: 2.0.0
---

# Get-SqlServerDatabaseSchema

## SYNOPSIS
Returns SqlServerDatabaseSchema data for a specific Sql Instance

## SYNTAX

```
Get-SqlServerDatabaseSchema [-SqlInstance] <String[]> [[-ScanDateUTC] <DateTime>]
 [[-SqlCredential] <PSCredential>] [-IncludeSystemDatabases] [-IncludeSystemSchemas] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SqlServerDatabaseSchema -SqlInstance localhost
```

Runs the command

## PARAMETERS

### -SqlInstance
What is the Sql Server instance of interest?

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
Default value: (Get-Date).ToUniversalTime()
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlCredential
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

### -IncludeSystemDatabases
{{ Fill IncludeSystemDatabases Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSystemSchemas
{{ Fill IncludeSystemSchemas Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
The attributes given here are influenced by the columns in the relevant worksheet of the "SQL Server Inventory - Database Engine Config" workbook.

This cmdlet is about gathering data, putting it into an object and returning it to the caller, for it to format as it sees fit.

## RELATED LINKS
