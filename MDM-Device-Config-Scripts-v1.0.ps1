# ---------------------------------------------------------------------------------------
# Intune  : List all All Device Configuration | Scripts
# Author  : Gilles Breton
# Date    : 2020-07-30
# Version : 1.0
# ---------------------------------------------------------------------------------------
# Get-installedmodule
# get-module Microsoft.Graph.Intune  | Foreach { $_.ExportedCommands }
# get-command -module Microsoft.Graph.Intune  | Where { $_.Name -like '*Connect*' }

cls

$a = Connect-MSGraph -ForceInteractive
 
# very important to use beta for Win32 apps
$b = Update-MSGraphEnvironment -SchemaVersion 'beta'

Write-Host "Tenant ......................:  " $a.TenantID "`t" $a.UPN 

# Get-Organization

$str1 = (Get-Organization).Displayname
$str2 = (Get-Organization).ID
$str3 = (Get-Organization).createdDateTime

Write-Host "GetOrganization .............:  " $str2 "`t" $str1" ("$str3")"
Write-Host "SchemaVersion  ..............:  " $b.Schemaversion
Write-Host ""


# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
#$DMS.value

#$AllDeviceConfigScripts = $DMS.value | Where-Object {$_.assignments -match $Group.id}
$AllDeviceConfigScripts = $DMS.value 


Write-host "Number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
 
Foreach ($c in $AllDeviceConfigScripts) 
        {
           
            $str4 = $c.displayname + "....................................." ; 
            $str4 = $str4.subString(0, 30)

            $str5 = $c.fileName
            

            Write-host $str4 "`t" $c.id  "`t" $str5 -ForegroundColor Green

 
            Foreach( $e in $c.groupAssignments ) 

                    {
          
                    $str10 = $e.targetGroupId
                    try
                    {
                        $str6 = (Get-AADGroup -groupid $e.targetGroupId).DisplayName 
                    }
                    catch
                    {}
 
    
                    Write-Host  "Target Group ID ..............  " $str10  "`t" $str6 -ForegroundColor Yellow
                    
                  


                    try 
                    {    $f = Get-AADGroupMember -groupId $e.targetGroupId

                        

                        Foreach( $i in $f ) 

                                {
                                $str8 = $i.DisplayName
                                $str9 = $i.'@odata.type'
                                $str9 = $str9.Replace("#microsoft.graph.","")
                                $str10 = $i.id
    
                                #  Write-Host "Target User/Dev ------------->  " $str10 "`t" $str8"("$str9")"
                                Write-Host  "Target User/Dev ..............  " $str10 "`t" $str8"("$str9")" "`t" $i.trustType 
           
                                #$e

                                }
                     }   
                     catch
                     {}




            }


}