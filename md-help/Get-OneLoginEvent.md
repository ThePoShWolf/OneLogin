# Get-OneLoginEvent

## SYNOPSIS
Retrieves events from a OneLogin account

## DESCRIPTION
Retrieves events such as logins, role assignments, and password resets from a OneLogin account. 

## PARAMETERS
### Filter
Specifies a combination of event properties to filter on. The filter should be in the form of a hashtable with one or more property names as keys. Note that the filter values should always be strings, and can contain asterisks as wildcards. Acceptable keys are:

client_id
created_at
directory_id
event_type_id
resolution
user_id

More information about possible event types can be found at https://developers.onelogin.com/api-docs/1/events/event-resource.

To learn more about hashtables, run the command:

Get-Help about_hash_tables

### Since
The earliest date for which to return events. This can be used with or without a filter. If you don't specify a filter, the -Since parameter will be required.

### Until
The latest date for which to return events. If you specify the -Since parameter but not the -Until parameter, this will have a value of the current date and time.

### Token
A OneLogin API access token that provides authorization for a OneLogin account. To generate an access token, use the New-OneLoginToken command.


## EXAMPLES
### --------------  Example 1  --------------

```powershell
Get-OneLoginEvent -Filter @{user_id = '112764'} -Token $Token
```

This example shows how to use a filter to return all events for a specific user, identified by the user_id property.

### --------------  Example 2  --------------

```powershell
Get-OneLoginEvent -Filter @{user_id = '112764'; event_type_id = '11'} -Token $Token
```

This example shows how to retrieve events for a specific user and specific event type, a password change.

### --------------  Example 3  --------------

```powershell
Get-OneLoginEvent -Filter @{user_id = '112764'} -Since "9/23/2016" -Until "9/24/2016" -Token $Token
```

This example will return all events for a specific user that occured between 9/23/2016 and 9/24/2016.

### --------------  Example 4  --------------

```powershell
Get-OneLoginEvent -Since "9/23/2016" -Until "9/24/2016" -Token $Token
```

This example will retrieve all events of any type between 9/23/2016 and 9/24/2016

## OUTPUTS
### OneLoginEvent