<# 
  _               _                                    
 / |_            (_)                                   
`| |-'_   _   __ __  _ .--.   .--.  _ .--..--.  .---.  
 | | [ \ [ \ [  |  |[ `.-. |/ .'`\ [ `.-. .-. |/ /__\\ 
 | |, \ \/\ \/ / | | | | | || \__. || | | | | || \__., 
 \__/  \__/\__/ [___|___||__]'.__.'[___||__||__]'.__.'                                         
 
/_____/_____/_____/_____/_____/_____/_____/_____/_____/

Script: twinomeSharePointOnlineFunctions.ps1
Author: Matt Warburton
Date: 24/06/16
Comments: SharePoint Online functions
Requires: SharePOint Online & Office Dev PnP PowerShell cmdlets 
#>

Function ApprovedVerb-TWPATTERNErrorHandle {
    <#
    .SYNOPSIS
        Blah
    .DESCRIPTION
        TEMPLATE
    .PARAMETER 1
        Blah
    .PARAMETER 2
        Blah
    .EXAMPLE
        ApprovedVerb-TWPATTERNErrorHandle -site https://speval -lib "customLib"
    #>
    [CmdletBinding()] 
    param (
        [string]$site, 
        [string]$lib
    )
      
    BEGIN {

        $ErrorActionPreference = 'Stop'    
    }
    
    PROCESS {

        try{
            $web = Get-SPWeb $site
            $list = $web.Lists[$lib]

                if($list) {
                    try {
                        Start-Sleep -s 15
                        $list.delete()
                        $web.Update()
                        Write-Output "list $lib deleted"                    
                    }
        
                    catch {
                        $error = $_
                        Write-Output "$($error.Exception.Message) - Line Number: $($error.InvocationInfo.ScriptLineNumber)"                   
                    }
                }

                else {
                    Write-Output "list $lib doesnt exist in $site"                
                }
        }

        catch{
            $error = $_
            Write-Output "$($error.Exception.Message) - Line Number: $($error.InvocationInfo.ScriptLineNumber)"  
        }
    }

    END {

        $web.dispose()    
    }
} 

Function Set-DefaultView {
    <#
    .SYNOPSIS
        Blah
    .DESCRIPTION
        TEMPLATE
    .PARAMETER 1
        Blah
    .PARAMETER 2
        Blah
    .EXAMPLE
        Set-DefaultView -site "a tenent site collection" -web "a web" -list "Documents" -view "All Documents"
    #>
    [CmdletBinding()] 
    param (
        [string]$site,
        [string]$web,  
        [string]$list, 
        [string]$view
    )
      
    BEGIN {

        $ErrorActionPreference = 'Stop'    
    }
    
    PROCESS {

        try{
            Connect-SPOnline -Url $site -Credentials O365TeamSite
            $ctx = Get-SPOContext
            $wb = Get-SPOWeb -Identity $web
            $ctx.Load($wb.lists)
            $ctx.ExecuteQuery()
            $lst = $wb.lists | Where-Object {$_.Title -eq $list}
            $ctx.Load($lst.views)
            $ctx.ExecuteQuery()
            $vw = $lst.views | Where-Object {$_.Title -eq $view}
            $vw.defaultview = $true
            $vw.update()
            $ctx.ExecuteQuery()                 
        }

        catch{
            $error = $_
            Write-Output "$($error.Exception.Message) - Line Number: $($error.InvocationInfo.ScriptLineNumber)"  
        }
    }
} 