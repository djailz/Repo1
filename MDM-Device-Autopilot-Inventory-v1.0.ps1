# ---------------------------------------------------------------------------------------
# Intune  : List all Autopilot Device 
# Author  : Gilles Breton
# Date    : 2020-09-01
# Version : 1.0
# ---------------------------------------------------------------------------------------
# Get-installedmodule
# install-module -name Microsoft.Graph.Intune
# install-module -name AzureAD
# get-module Microsoft.Graph.Intune  | Foreach { $_.ExportedCommands }
# get-command -module Microsoft.Graph.Intune  | Where { $_.Name -like '*Connect*' }

cls

#$a = Connect-MSGraph -ForceInteractive

# $a = Connect-MSGraph 
 
# very important to use beta for Win32 apps
$b = Update-MSGraphEnvironment -SchemaVersion 'beta'

#$Credential = Get-Credential
#$t = Connect-AzureAD -Credential $Credential

# Connect-AzureAD


Write-Host "Tenant ................ :  " $a.TenantID "`t" $a.UPN 
            
# Get-Organization

$str1 = (Get-Organization).Displayname
$str2 = (Get-Organization).ID
$str3 = (Get-Organization).createdDateTime
$str4 = (Get-Organization).VerifiedDomains.Name
#Get-Organization

Write-Host "GetOrganization ....... :  " $str2 "`t" $str1" ("$str3")"
Write-Host "SchemaVersion  ........ :  " $b.Schemaversion
Write-Host "Domain         ........ :  " $str4

Write-Host ""


 

# ------------------------------------------------------
# List All Autopilot devices
# ------------------------------------------------------

#$URI = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities?`$filter=contains(serialNumber,'$($IntuneDevice.serialNumber)')"

$URI = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities?"
$AutopilotDevice = Invoke-MSGraphRequest –Url $uri –HttpMethod GET –ErrorAction Stop


$AllDevices= $AutopilotDevice.value 
#$AllDevices

Write-host "Count Autopilot Devices :  $($AllDevices.ID.Count)" -ForegroundColor cyan
            
Foreach ($c in $AllDevices) 
        {

        $str4 = $c.ID
        $str5 = $c.Model
        $str6 = $c.SerialNumber
        $str7 = $c.deploymentProfileAssignmentStatus 
        $str8 = $c.azureActiveDirectoryDeviceId
        $str9 = $c.managedDeviceId

        Write-host "ID..................... : " $str4  
        Write-host "Model.................. : " $str5  
        Write-host "SerialNumber........... : " $str6  
        Write-host "AssignmentStatus....... : " $str7  
        Write-host "AAD-ID................. : " $str8  
        Write-host "Intune-ID.............. : " $str9  
        
        #$str5 "`t" $str6 "`t" $str7 "`t" $str8"(AAD)" -ForegroundColor Green
        
        }

# ------------------------------------------------------
# List All Intune devices
# ------------------------------------------------------

$AllDevices = Get-IntuneManagedDevice

#$alldevices

write-host  ""
Write-host "Count Intune Devices    :  $($AllDevices.ID.Count)" -ForegroundColor cyan
             
Foreach ($c in $AllDevices) 
        {

        $str4 = $c.ID
        $str5 = $c.Model
        $str6 = $c.SerialNumber
        $str7 = $c.deviceName
        $str8 = $c.joinType 
        $str9 = $c.azureADDeviceId
        
        Write-host "Intune-ID...............: " $str4  
        Write-host "Model.................. : " $str5  
        Write-host "SerialNumber........... : " $str6  
        Write-host "DeviceName............. : " $str7  
        Write-host "JoinType............... : " $str8  
        Write-host "AAD-ID................. : " $str9
         
        #Write-host $str4 "`t" $str5 "`t" $str6 "`t" $str7  "`t" $str8 -ForegroundColor Green
        $c 

        $j = $c.roleScopeTagIds 

        $str9=""
        foreach ( $k in $j ) 
        { #$e.Tostring() 
            { $str9 = $str9 + "roleScopeTagIds...... : "  + $k.Tostring() + "`r`n" }
        }

        #$c
        
        Write-host  $str9 


        }

    write-host ""

    $AllDevices2 = Get-IntuneManagedDevice -managedDeviceId f7e3e731-7c3d-4443-bb1f-05ef5396f3b5

    Foreach ($c in $AllDevices2) 
        {

         $j = $c.roleScopeTagIds 

         $str9=""
         foreach ( $k in $j ) 
            { #$e.Tostring() 
               $str9 = $str9 + "roleScopeTagIds...... : "  + $k.Tostring() + "`r`n" 
            }
        
        Write-host  $str9 


        }




# ------------------------------------------------------
# List All AAD devices
# ------------------------------------------------------

$AllDevices = Get-AzureADDevice
#$AllDevices | select *

Write-host "Number of AAD Device    :  $($AllDevices.DeviceId.Count)" -ForegroundColor cyan

 
Foreach ($c in $AllDevices) 
        {

        $str7 = $c.DisplayName 
        $str4 = $c.DeviceId
        $f = $c.DevicePhysicalIds 

        $str5=""
        foreach ( $e in $f ) 
        { #$e.Tostring() 
            if ( $e.Tostring() -like '*ID*' )
            { $str5 = $str5 + "DevicePhysicalIds...... : "  + $e.Tostring() + "`r`n" }
        }

        $str6 = $c.DeviceTrustType
        $str8 = $c.ProfileType 

        #Write-host $str4 "`t" $str5 "`t" $str6 "`t" $str7  "`t" $str8  "`t" $str9 -ForegroundColor Green

        
        Write-host "DisplayName............ : " $str7  
        Write-host "AAD-ID..................: " $str4  
        
        Write-host "TrustType.............. : " $str6  
        Write-host "ProfilType............. : " $str8  

        Write-host  $str5 

        Write-host ""
       

       

        }









$flag2 = 1 
$i1=0 

while ($flag2 -eq 0 ) 
{
    $i2 = $i2 % 100
    $i2 = $i2 + 1 
    $URI = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities?"
    $AutopilotDevice = Invoke-MSGraphRequest –Url $uri –HttpMethod GET –ErrorAction Stop

    $AllDevices= $AutopilotDevice.value 

    Foreach ($c in $AllDevices) 
        {

        $str4 = $c.ID
        $str5 = $c.Model
        $str6 = $c.SerialNumber
        $str7 = $c.deploymentProfileAssignmentStatus
        #Write-host $str4 "`t" $str5 "`t" $str6 -ForegroundColor Green
        }

        Write-Progress -Activity "in Progress" -Status  $str7  -PercentComplete $i2



}



 for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i;
}


 # $URI = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/$($str4)"
 # Invoke-MSGraphRequest –Url $uri –HttpMethod DELETE –ErrorAction Stop
 
               