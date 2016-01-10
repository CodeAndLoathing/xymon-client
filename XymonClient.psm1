function Send-XymonStatus
{
    <#
        .SYNOPSIS
        Send a TCP status message for a test to Xymon server(s).
        .DESCRIPTION
        Send a TCP status message for a test to Xymon server(s).

        Xymon status message syntax was retrieved from : https://www.xymon.com/help/manpages/man1/xymon.1.html
        SYNTAX: status[+LIFETIME][/group:GROUP] HOSTNAME.TESTNAME COLOR <additional text>
        .PARAMETER Lifetime
        Number of seconds status remains valid after being received by Xymon. (Default is 30 minutes).
        .PARAMETER Group
        Used to direct alerts to a specific group
        .PARAMETER Hostname
        Host name of client sending status message to send to Xymon. Defaults to lower-case FQDN of client.
        .PARAMETER TestName
        Test name. (Xymon collector-id).
        .PARAMETER Color
        Color (status) of test. One of: green, yellow, red, clear.
        .PARAMETER Text
        Additional text to send.
        .PARAMETER XymonServer
        Xymon Server(s) to send status message to.
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$false, HelpMessage="Number of seconds status remains valid after being received by Xymon. (Default is 30 minutes).")]
        [ValidateRange(0,[int]::MaxValue)]
        [int] $Lifetime,
        [Parameter(Mandatory=$false, HelpMessage="Used to direct alerts to a specific group")]
        [string] $Group,
        [Parameter(Mandatory=$false, HelpMessage="Host name of client sending status message to send to Xymon. Defaults to lower-case FQDN of client.")]
        [string] $Hostname,
        [Parameter(Mandatory=$true, HelpMessage="Test name. (Xymon collector-id).")]
        [string] $TestName,
        [Parameter(Mandatory=$true, HelpMessage="Color (status) of test. One of: green, yellow, red, clear.")]
        [ValidateSet('green','yellow','red','clear')]
        [string] $Color,
        [Parameter(Mandatory=$false, HelpMessage="Additional text to send.")]
        [string] $Text,
        [Parameter(Mandatory=$true, HelpMessage="Xymon Server(s) to send status message to.")]
        [string[]] $XymonServer
    )
                    
    if ($Lifetime)
    {
        $LifetimeMsg = "+{0}" -f $Lifetime
    }
    if ($Group)
    {
        $GroupMsg = "/group:{0}" -f $Group
    }
    if (!$Hostname)
    {
        $v_IPGP = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
        $HostnameMsg = ("{0}.{1}" -f ($v_IPGP.HostName.Trim(".")), $v_IPGP.DomainName).Trim(".").ToLower();
    }
    else { $HostnameMsg = $Hostname}
    if ($Text)
    {
        $Text = " $Text"
    }
    Send-XymonRaw -XymonServer $XymonServer -Msg "Status$LifetimeMsg$GroupMsg $HostnameMsg.$TestName $Color$Text"
}

function Send-XymonRaw
{
    <#
        .SYNOPSIS
        Send a string without modificition via TCP to Xymon server(s).
        .DESCRIPTION
        Send a string without modificition via TCP to Xymon server(s).

        see https://www.xymon.com/help/manpages/man1/xymon.1.html for valid message syntax and other options.
        .PARAMETER XymonServer
        Xymon Server(s) to send status message to.
        .PARAMETER Msg
        String to send to Xymon
    #>
    Param(
        [Parameter(Mandatory=$true, HelpMessage="Xymon Server(s) to send status message to.")]
        [string[]] $XymonServer,

        [Parameter(Mandatory=$true, HelpMessage="Message text to send to Xymon")]
        [string] $Msg
    )

    foreach ($Svr in $XymonServer)
    {
        $Svr = $Svr.Split(":")
        If ($Svr.Count -gt 1) { $Port = $Svr[1] } else { $Port = 1984 }
        Write-Verbose ("Send-XymonRaw [{0}:{1}]{2}" -f $Svr[0],$Port,$Msg)
        $TcpClient = New-Object System.Net.Sockets.TCPClient
        $TcpClient.Connect($Svr[0],$Port)
        $Stream = $TcpClient.GetStream()
        $Writer = New-object System.IO.StreamWriter($Stream)
        $Writer.Write($Msg)
        $Writer.Dispose()
        $Stream.Dispose()
        $TcpClient.Close()
    }
}