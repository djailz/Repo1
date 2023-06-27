
# ---------------------------------------------------------------------------------------
# Intune  : List all All Device Configuration | Profiles
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

# -----------------------------------------------------------
# Get All Device Configuration | Profiles
# -----------------------------------------------------------
Write-Host "--------------------------------"
Write-Host "Device Configuration | Profiles "
Write-Host "--------------------------------"
$b = Get-DeviceManagement_DeviceConfigurations 

Foreach ($c in $b )
{
 
 # $c = DeviceConfigurations

 $str4 = $c.displayname + "....................................." ; 
 $str4 = $str4.subString(0, 30)

 $str5 = $c.'@odata.type'
 $str5=$str5.Replace("#microsoft.graph.","")

 Write-host $str4 "`t" $c.id  "`t" $str5 -ForegroundColor Green
 #$c
 $d = $c.id

#  Write-Host $c.omaSettings.omaUri
 Write-host omaUri  "                     `t" $c.omaSettings.omaUri -ForegroundColor Yellow

 try
 {

    $str6 = (Get-AADGroup -groupid (Get-DeviceManagement_DeviceConfigurations_Assignments -deviceConfigurationId $c.id).Target.GroupID).DisplayName 
    $str7 = (Get-DeviceManagement_DeviceConfigurations_Assignments -deviceConfigurationId $c.id).Target.GroupID
    # $str71 = (Get-DeviceManagement_DeviceConfigurations_Assignments -deviceConfigurationId $c.id).Target.'@odata.type'
    $str71 = (Get-DeviceManagement_DeviceConfigurations_Assignments -deviceConfigurationId $c.id).Target
    
    Write-Host "Target Group .................  " $str7  "`t" $str6
    # Write-Host "Target Group .................  " $str71
                 
     $g = (Get-DeviceManagement_DeviceConfigurations_Assignments -deviceConfigurationId $c.id).Target.GroupID

      
    #microsoft.graph.
    

    $f = Get-AADGroupMember -groupId $g

    Foreach( $e in $f ) 

            {
            $str8 = $e.DisplayName
            $str9 = $e.'@odata.type'
            $str9 = $str9.Replace("#microsoft.graph.","")
            $str10 = $e.id
    
          #  Write-Host "Target User/Dev ------------->  " $str10 "`t" $str8"("$str9")"
            Write-Host  "Target User/Dev ..............  " $str10 "`t" $str8"("$str9")" "`t" $e.trustType 
           
            #$e

            }
 }
 catch
 {}

 write-host ""
}
