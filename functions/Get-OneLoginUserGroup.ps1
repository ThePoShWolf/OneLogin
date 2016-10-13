function Get-OneLoginUserGroup
{
    [CmdletBinding()]
    [OutputType([OneLogin.Group])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.User]
        $Identity,

        [Parameter(Mandatory)]
        [OneLogin.Token]
        $Token
    )
    
    process
    {
        foreach ($Id in $Identity.group_id)
        {
            Get-OneLoginGroup -Identity $Id -Token $Token
        }
    }
}