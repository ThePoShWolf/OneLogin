# Invoke-OneLoginUserLockout

## SYNOPSIS
Locks out a OneLogin user for a specified period of time.

## DESCRIPTION
Locks out a OneLogin user for a specified period of time. While locked out, the user will not be able to sign in to OneLogin or provided applications.

##PARAMETERS
### Identity
Specifies the user who will be locked out.

### IntervalInMinutes
Specifies the duration in minutes that the user will be locked out. If you do not specify a value, or if you specify zero, the lockout duration will be the value of the lockout duration in the user's security policy. If the user's security policy does not specify a lockout duration, and the value of -IntervalInMinutes is 0 or unspecified, the lockout will remain in effect until you unlock the user.

### Token
A OneLogin API access token that provides authorization for a OneLogin account. To generate an access token, use the New-OneLoginToken command.

## EXAMPLES
### --------------  Example 1  --------------

```powershell
PS C:\> Get-OneLoginUser -Identity 123456 -Token $Token | Invoke-OneLoginUserLockout -IntervalInMinutes 60 -Token $Token
```

This example demonstrates how to lock out a user for one hour.

## INPUTS
### OneLoginUser