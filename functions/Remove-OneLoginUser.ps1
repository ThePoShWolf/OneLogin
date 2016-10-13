function Remove-OneLoginUser
{
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact = "High")]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.User]
        $Identity,

        [OneLogin.Token]
        $Token
    )
    
    begin
    {
        $Splat = @{
            Token  = $Token
            Method = "Del"
            Body   = $Body
        }
    }
    
    process
    {
        $Splat["Endpoint"] = "api/1/users/$($Identity.Id)"
        if ($PSCmdlet.ShouldProcess($Identity, $MyInvocation.MyCommand.Name))
        {
            Invoke-OneLoginRestMethod @Splat
        }
    }
}
