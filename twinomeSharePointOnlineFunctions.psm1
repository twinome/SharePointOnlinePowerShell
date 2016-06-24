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
Comments: SharePoint functions
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


$module = Get-Module | Where-Object {$_.name -eq "Microsoft.Online.SharePoint.PowerShell"}

if(!$module){
    Import-Module Microsoft.Online.SharePoint.PowerShell -WarningAction SilentlyContinue
}

###Standard###

$cred = Get-Credential
Connect-SPOService -Url https://twinome-admin.sharepoint.com -Credential $cred

<#

PnP

mwarburton@twinome.com

help *spo*

#>

Connect-SPOnline -Url https://twinome.sharepoint.com -Credentials O365TeamSite
$ctx = Get-SPOContext

$webs = Get-SPOSubWebs

$webs | ForEach-Object{
    $ctx.Load($_.lists)
    $ctx.ExecuteQuery()
    $lists = $_.lists

    $lists | ForEach-Object{
        $ctx.Load($_.views)
        $ctx.ExecuteQuery()
        $views = $_.views | Where-Object {$_.DefaultView -eq $true}
        Write-Output $views
    }
}