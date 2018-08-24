# xymon-client
A simple TCP client for Xymon implemented in Powershell.

Version 2016.01.10

## Description

The goal is to provide a script small enough to be easily understood in its
entirety. It is not intended to be a replacement for more full featured client like
[BBWin](http://bbwin.sourceforge.net/) or 
[WinPSClient](http://sourceforge.net/p/xymon/code/HEAD/tree/sandbox/WinPSClient/) 
but to provide minimal functionality to send status, data and raw strings to Xymon.

It could be used for example to send the success/failure status of a recurring job.

## Download
The latest version of this script can be always downloaded from: https://github.com/CodeAndLoathing/xymon-client/releases

## Usage examples
      Import-Module $PSScriptRoot\XymonClient.psm1
	  	  
      Send-XymonStatus -TestName testname -Color green -XymonServer xymon.example.com
	  
	  Send-XymonStatus -TestName testname -Color red -XymonServer @("xymona.example.com", "xymonb.example.com") -Verbose
	  
	  Send-XymonStatus -TestName testname -Color clear -XymonServer "xymon.example.com:1984" -Text "additional text"
	  
	  Send-XymonStatus -TestName testname -Host "host.example.com" -Color green -XymonServer "xymon.example.com"

	  Send-XymonStatus -Hostname "host.example.com" -TestName testname -Color clear -XymonServer "xymon.example.com" -Text "additional text" -Verbose
	  
## Installation
This script is implemented as a Powershell module. As such you have a couple of options on 
how you can use it. 

* From Powershell3 onwards you can use $PSScriptRoot to easily load a module in the same directory as an executing script:
      Import-Module $PSScriptRoot\XymonClient.psm1
	  
* From an interactive console with the module at the current path location
      Import-Module .\XymonClient.psm1

* Alternatively, you can [install the module](https://technet.microsoft.com/en-us/library/dd878350%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396)
  priot to importing.  

* Finally, you could just copy/paste the relevant functions into your own Powershell script.


## Additional Resources
* [Xymon Message Syntax](https://www.xymon.com/help/manpages/man1/xymon.1.html#lbAF)

## Versions

See [Releases](https://github.com/CodeAndLoathing/xymon-client/releases)

## License
See the LICENSE file for license details.
