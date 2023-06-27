# ---------------------------------------------------------------------------------------
# Intune  : List all apps 
# Author  : Gilles Breton
# Date    : 2020-07-30
# Version : 1.0
# ---------------------------------------------------------------------------------------
# Get-installedmodule
# install-module -name Microsoft.Graph.IntuneGet-AutoPilotImportedDevice
# get-module Microsoft.Graph.Intune  | Foreach { $_.ExportedCommands }
# Get-AzureADDevice
# ---------------------------------------------------------------------------------------

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
# Get All Applications
# -----------------------------------------------------------
Write-Host "------------------------------"
Write-Host "Client Apps | Apps "
Write-Host "------------------------------"


# ----------------------------------------------------
# List App type : windowsMobileMSI
# ----------------------------------------------------

$b = Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("windowsMobileMSI") }

Foreach ($c in $b )
{
 
 # object $c = Applications 

 $str4 = $c.displayname + "....................................." ; 
 $str4 = $str4.subString(0, 30)

 $str5 = $c.'@odata.type'
 $str5=  $str5.Replace("#microsoft.graph.","")

 Write-host $str4 "`t" $c.id  "`t" $str5
 $d = $c.id
 
}

Write-Host ""

# ----------------------------------------------------
# List App type : win32LobApp
# ----------------------------------------------------

$b = Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("win32LobApp") }

 

Foreach ($c in $b )
{
 
 # $c = Applications 

 $str4 = $c.displayname + "....................................." ; 
 $str4 = $str4.subString(0, 30)

 $str5 = $c.'@odata.type'
 $str5 = $str5.Replace("#microsoft.graph.","")

 Write-host $str4 "`t" $c.id  "`t" $str5
 $d = $c.id
}

# ----------------------------------------------------
# List App type : microsoftStoreForBusinessApp
# ----------------------------------------------------

$b = Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("microsoftStoreForBusinessApp") }

Foreach ($c in $b )
{
 
 # $c = Applications 

 $str4 = $c.displayname + "....................................." ; 
 $str4 = $str4.subString(0, 30)

 $str5 = $c.'@odata.type'
 $str5 = $str5.Replace("#microsoft.graph.","")

 Write-host $str4 "`t" $c.id  "`t" $str5
 $d = $c.id
}

write-host ""

# -------------------------------------------------------------------
# List App type : microsoftStoreForBusinessApp - Group Assignement
# -------------------------------------------------------------------

Write-Host "------------------------------"
Write-Host "Client Apps | Gp Assignments  "
Write-Host "------------------------------"

#$b = Get-DeviceAppManagement_MobileApps | Where-Object { ($_.'@odata.type').contains("microsoftStoreForBusinessApp") }
$b = Get-DeviceAppManagement_MobileApps 


Foreach ($c in $b )
{
 
 # $c = Applications 

 $str4 = $c.displayname + "....................................." ; 
 #write-host $c.displayname 
 $str4 = $str4.subString(0, 30)

 $str5 = $c.'@odata.type'
 $str5 = $str5.Replace("#microsoft.graph.","")


 $d = $c.id
 

 #Get-DeviceAppManagement_MobileApps_Assignments -mobileAppId $c.id
 $g = Get-DeviceAppManagement_MobileApps_Assignments -mobileAppId $c.id
 
 #if ([string]::IsNullOrEmpty($g.id))

 if ( $g.count -ne 0 ) 
  {
  
  #Write-Host "Count = " $g.count
   Write-host $str4 "`t" $c.id  "`t" $str5  "`t" -ForegroundColor Green
  
  foreach ( $i in $g.Target )
            {
                $str8=""
                $str8 = $i.'@odata.type'
     
                # $str6 = "#microsoft.graph.allDevicesAssignmentTarget"
                $str6 = $i.'@odata.type'
                $str6 = $str6.Replace("#microsoft.graph.","")
                $str6 = $str6.Replace("AssignmentTarget","")
                
                #           Zoom Rooms....................
                

                if ( ($i.'@odata.type').Contains("groupAssignmentTarget"))
                    { 
                        $str6 = $str6 + "," + $i.groupId + "," +(Get-AADGroup -groupid $i.groupId).Displayname + ",(" + (Get-AADGroupMember -groupid $i.groupId ).Count + ")"
                        $str9 = (Get-AADGroupMember -groupid $i.groupId).displayname
                    }

                Write-Host "Group Assignment .............  " $str6 
                Write-Host "Group Assignment .............  " $str9 
                Write-Host "Group Assignment .............  " $g.Intent 
    }
     #Write-Host $g.settings

     } # end if

}


