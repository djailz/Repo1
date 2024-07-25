# This script can keep the computer awake until this script stops.
# There are 3 different ways of staying awake:
#     Away Mode - Enable away mode
#     Display Mode - Keep the display on and don't go to sleep or hibernation
#     System Mode - Don't go to sleep or hibernation
# The default mode is the Display Mode.
# Away mode is only available when away mode is enabled in the advanced power options.
# These commands are advisory, the option to allow programs to request to disable
# sleep or display off is in advanced power options.
# The above options will need to be first enabled in the registry before you can
# see them in the advanced power options.

param (
    [ValidateSet('Away', 'Display', 'System')]
    [string]$Option = 'Display',
    [ValidateRange(30,2000)]
    [parameter(Mandatory=$false, HelpMessage="Maximum number of minutes to run the script.")]
    [int]$Duration = 720,
    [ValidateRange(1,15)]
    [parameter(Mandatory=$false, HelpMessage="Interval in minutes for the script loop.")]
    [int]$Interval = 3
)

$Code=@'
[DllImport("kernel32.dll", CharSet = CharSet.Auto,SetLastError = true)]
public static extern void SetThreadExecutionState(uint esFlags);
'@

$ste = Add-Type -memberDefinition $Code -name System -namespace Win32 -passThru

# Requests that the other EXECUTION_STATE flags set remain in effect until
# SetThreadExecutionState is called again with the ES_CONTINUOUS flag set and
# one of the other EXECUTION_STATE flags cleared.
$ES_CONTINUOUS = [uint32]"0x80000000"
$ES_AWAYMODE_REQUIRED = [uint32]"0x00000040"
$ES_DISPLAY_REQUIRED = [uint32]"0x00000002"
$ES_SYSTEM_REQUIRED = [uint32]"0x00000001"

Switch ($Option) {
    "Away"    {$Setting = $ES_AWAYMODE_REQUIRED}
    "Display" {$Setting = $ES_DISPLAY_REQUIRED}
    "System"  {$Setting = $ES_SYSTEM_REQUIRED}
}

$intSleepDuration = 60 * $Interval

for($intParsingDuration = 0; $intParsingDuration -lt $Duration; $intParsingDuration += $Interval) {
    $intDurationLeft = $Duration - $intParsingDuration
    Write-Host "$(Get-Date -Format 'hh:mm:ss') - AH AH AH AH Staying alive ($($intParsingDuration) minutes, max $($intDurationLeft) minutes remaining)..."
    $ste::SetThreadExecutionState($ES_CONTINUOUS -bor $Setting)
    #trigger garbage collector to free up some memory
    #[System.GC]::Collect() 
    Start-Sleep -Seconds $intSleepDuration
}
Write-Host "$(Get-Date -Format 'hh:mm:ss') - Max duration reached, closing the dance floor."