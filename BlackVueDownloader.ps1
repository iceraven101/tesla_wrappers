﻿#                   __   __ ___    ____   ___    _   ____                   
#                   \ \ / // _ \  / ___| / _ \  ( ) / ___|                  
#                    \ V /| | | || |  _ | | | | |/  \___ \                  
#                     | | | |_| || |_| || |_| |      ___) |                 
#                     |_|  \___/  \____| \___/      |____/                  
#           ____   _         _     ____  _  ____     __ _   _  _____        
#          | __ ) | |       / \   / ___|| |/ /\ \   / /| | | || ____|       
#          |  _ \ | |      / _ \ | |    | ' /  \ \ / / | | | ||  _|         
#          | |_) || |___  / ___ \| |___ | . \   \ V /  | |_| || |___        
#          |____/ |_____|/_/   \_\\____||_|\_\   \_/    \___/ |_____|       
#  ____    ___ __        __ _   _  _      ___     _     ____   _____  ____  
# |  _ \  / _ \\ \      / /| \ | || |    / _ \   / \   |  _ \ | ____||  _ \ 
# | | | || | | |\ \ /\ / / |  \| || |   | | | | / _ \  | | | ||  _|  | |_) |
# | |_| || |_| | \ V  V /  | |\  || |___| |_| |/ ___ \ | |_| || |___ |  _ < 
# |____/  \___/   \_/\_/   |_| \_||_____|\___//_/   \_\|____/ |_____||_| \_\
#
##############################################################################


#           CURRENTLY IN TESTING - YOU MAY GET UNEXPECTED RESULTS!



#    THE COMBINATION OF THE BELOW TEXT WILL TELL THE SCRIPT WHERE YOU WANT TO PUT YOUR VIDEO FILES



#    YOU WILL NEED TO PRE-CREATE THE FOLDERS FOR IT, FOR EXAMPLE, THE FIRST ENTRY BELOW WILL PUT VIDEO FILES INTO C:\Dashcams\Car1-Folder



#    THIS IS VERIFIED TO WORK WITH THE BLACKVUE DR650S-2CH, THIS IS THE ONLY ONE I HAVE TO WORK WITH, SO I'M NOT SURE HOW IT WILL BEHAVE IF YOU HAVE SOMETHING DIFFERENT, CHECK THE FORUM TO SEE OTHER COMPATIBLE CAMERAS



#    AS A PRECAUTION (FOR ME) YOU ASSUME ALL LIABILITY FOR ANY LOSS, AND IN NO WAY WILL HOLD ME RESPONSIBLE FOR ANY BAD STUFF THAT HAPPENS...



#    YOU NEED TO HAVE THE DASHCAM CONNECTED TO THE SAME NETWORK AS THE COMPUTER YOU ARE RUNNING THIS SCRIPT ON








###############################
### SET YOUR VARIABLES HERE ###
###############################
   
$script:DCROOT_DRIVE = "P:"					#ENTER THE DRIVE LETTER FOLLOWED BY A COLON WHERE YOU WISH TO STORE THE VIDEO FILES
$script:DCROOT_FOLDER = "ServerFolders\Pictures\BlackVue"			#ENTER THE FOLDER NAME (NO SLASHES) OF THE FOLDER IN WHICH THE VIDEO FILES WILL BE STORED

###########################################################################################################

$script:DC_CAR1 = "CAR1-NAME"				#ENTER A COMMON NAME FOR THE CAR WITH THIS DASHCAM HERE
$script:DC_IP_1 = "0"				#ENTER THE IP ADDRESS OF THE DASHCAM HERE
$script:IP_1_PATH = "Record"			#ENTER THE FOLDER NAME WHER THE VIDEO FILES WILL BE STORED

###########################################################################################################

$script:DC_CAR2 = "CAR2-NAME"				#ENTER A COMMON NAME FOR THE CAR WITH THIS DASHCAM HERE
$script:DC_IP_2 = "0"				#ENTER THE IP ADDRESS OF THE DASHCAM HERE
$script:IP_2_Path = "CAR2-FOLDER"			#ENTER THE FOLDER NAME WHER THE VIDEO FILES WILL BE STORED

###########################################################################################################

$script:DC_CAR3 = "CAR3-NAME"				#ENTER A COMMON NAME FOR THE CAR WITH THIS DASHCAM HERE
$script:DC_IP_3 = "0"				#ENTER THE IP ADDRESS OF THE DASHCAM HERE
$script:IP_3_Path = "CAR3-FOLDER"			#ENTER THE FOLDER NAME WHER THE VIDEO FILES WILL BE STORED

###########################################################################################################

$script:DC_CAR4 = "CAR4-NAME"				#ENTER A COMMON NAME FOR THE CAR WITH THIS DASHCAM HERE
$script:DC_IP_4 = "0"				#ENTER THE IP ADDRESS OF THE DASHCAM HERE
$script:IP_4_Path = "CAR4-NAME"				#ENTER THE FOLDER NAME WHER THE VIDEO FILES WILL BE STORED

###########################################################################################################

$script:DC_CAR5 = "CAR5-NAME"				#ENTER A COMMON NAME FOR THE CAR WITH THIS DASHCAM HERE
$script:DC_IP_5 = "0"				#ENTER THE IP ADDRESS OF THE DASHCAM HERE
$script:IP_5_Path = "CAR5-FOLDER"			#ENTER THE FOLDER NAME WHER THE VIDEO FILES WILL BE STORED


function LogIt
{
  param (
  [Parameter(Mandatory=$true)]
  $message,
  [Parameter(Mandatory=$true)]
  $component,
  [Parameter(Mandatory=$true)]
  $type )

  switch ($type)
  {
    1 { $type = "Info" }
    2 { $type = "Warning" }
    3 { $type = "Error" }
    4 { $type = "Verbose" }
  }

  if (($type -eq "Verbose") -and ($Global:Verbose))
  {
    $toLog = "{0} `$$<{1}><{2} {3}><thread={4}>" -f ($type + ":" + $message), ($Global:ScriptName + ":" + $component), (Get-Date -Format "MM-dd-yyyy"), (Get-Date -Format "HH:mm:ss.ffffff"), $pid
    $toLog | Out-File -Append -Encoding UTF8 -FilePath ("filesystem::{0}" -f $Global:LogFile)
    Write-Host $message
  }
  elseif ($type -ne "Verbose")
  {
    $toLog = "{0} `$$<{1}><{2} {3}><thread={4}>" -f ($type + ":" + $message), ($Global:ScriptName + ":" + $component), (Get-Date -Format "MM-dd-yyyy"), (Get-Date -Format "HH:mm:ss.ffffff"), $pid
    $toLog | Out-File -Append -Encoding UTF8 -FilePath ("filesystem::{0}" -f $Global:LogFile)
    Write-Host $message
  }
  if (($type -eq 'Warning') -and ($Global:ScriptStatus -ne 'Error')) { $Global:ScriptStatus = $type }
  if ($type -eq 'Error') { $Global:ScriptStatus = $type }

  if ((Get-Item $Global:LogFile).Length/1KB -gt $Global:MaxLogSizeInKB)
  {
    $log = $Global:LogFile
    Remove-Item ($log.Replace(".log", ".lo_"))
    Rename-Item $Global:LogFile ($log.Replace(".log", ".lo_")) -Force
  }
} 

function GetScriptDirectory
{
  $invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $invocation.MyCommand.Path
} 

$VerboseLogging = "true"
[bool]$Global:Verbose = [System.Convert]::ToBoolean($VerboseLogging)
$Global:LogFile = Join-Path (GetScriptDirectory) 'BlackVue.log' 
$Global:MaxLogSizeInKB = 5120
$Global:ScriptName = 'BlackVueDownloader.ps1'
$Global:ScriptStatus = 'Success'






#####################################################################################
#########    D O   N O T   E D I T   A N Y T H I N G   B E L O W   T H I S   ########
#####################################################################################






function set_arrays
{
$Script:Car1 = [PSCustomObject]@{
    IP = $DC_IP_1
    CarName = $DC_CAR1
    Carpath = $IP_1_PATH
    }

$Script:Car2 = [PSCustomObject]@{
    IP = $DC_IP_2
    CarName = $DC_CAR2
    Carpath = $IP_2_PATH
    }

$Script:Car3 = [PSCustomObject]@{
    IP = $DC_IP_3
    CarName = $DC_CAR3
    Carpath = $IP_3_PATH
    }

$Script:Car4 = [PSCustomObject]@{
    IP = $DC_IP_4
    CarName = $DC_CAR4
    Carpath = $IP_4_PATH
    }

$Script:Car5 = [PSCustomObject]@{
    IP = $DC_IP_5
    CarName = $DC_CAR5
    Carpath = $IP_5_PATH
    }
}


function intro
{
$host.ui.RawUI.WindowTitle = "YOGO'S BLACKVUE DOWNLOADER v0.4"
CLS
$timestamp = Get-Date -Format "HH:mm:ss.ffffff"
LogIt -message ("BlackVue Downloader Started") -component "intro()" -type 1 
write-output "`n"
write-output "`n"
write-output "YOGO'S BLACKVUE DOWNLOADER v0.4"
write-output "`n"
write-output "`n"
}


function check_paths
{


$carpaths = New-Object System.Collections.Generic.List[System.Object]
if ($Car1.IP -ne 0){$carpaths.add($Car1.Carpath)}
if ($Car2.IP -ne 0){$carpaths.add($Car2.Carpath)}
if ($Car3.IP -ne 0){$carpaths.add($Car3.Carpath)}
if ($Car4.IP -ne 0){$carpaths.add($Car4.Carpath)}
if ($Car5.IP -ne 0){$carpaths.add($Car5.Carpath)}

Foreach ($checkpath in $CarPaths)

{

write-output " ------------------------------------------------------------------------------------------------------- "
write-output "`n"
write-output "Testing path: $DCROOT_DRIVE\$DCROOT_FOLDER\$Checkpath\"
LogIt -message ("Testing path: $DCROOT_DRIVE\$DCROOT_FOLDER\$Checkpath\") -component "check_paths()" -type 1 
if (test-path $DCROOT_DRIVE\$DCROOT_FOLDER\$Checkpath\) 
    { 
        write-output " -- TEST SUCCESSFUL"
        LogIt -message (" -- TEST SUCCESSFUL") -component "check_paths()" -type 1

    } 
    else {
        $Host.UI.WriteErrorLine("          The folder structure is not set up properly.") 
        write-output "`n"
        $Host.UI.WriteErrorLine("    Please double check the settings at the top of this file")
        write-output "`n"
        $Host.UI.WriteErrorLine("Alternatively, please see the readme file that cam with this script")
        write-output "Press any key to exit..."
        $HOST.UI.RawUI.Flushinputbuffer()
        $HOST.UI.RawUI.ReadKey(“NoEcho,IncludeKeyDown”) | OUT-NULL
        $HOST.UI.RawUI.Flushinputbuffer()
        EXIT
        }
    }
}


function Cam_Choice
{
$IPList_temp = ($Car1.IP,$Car2.IP,$Car3.IP,$Car4.IP,$Car5.IP)

$IPList = $IPList_temp | Where-Object {$_ -ne "0"}
$Results = foreach ($IP in $IPList)
    {
        IF ($IP -EQ $CAR1.IP) {$CAR_FRIENDLY = $CAR1.CARNAME}
        IF ($IP -EQ $CAR2.IP) {$CAR_FRIENDLY = $CAR2.CARNAME}
        IF ($IP -EQ $CAR3.IP) {$CAR_FRIENDLY = $CAR3.CARNAME}
        IF ($IP -EQ $CAR4.IP) {$CAR_FRIENDLY = $CAR4.CARNAME}
        IF ($IP -EQ $CAR5.IP) {$CAR_FRIENDLY = $CAR5.CARNAME}
    write-host "Testing for Camera connection on $IP ..." -ForegroundColor Yellow
    LogIt -message ("Testing for Camera connection on $IP ...") -component "Cam_Choice()" -type 2 

    $Response = Test-Connection -ComputerName $IP -Count 1 -Quiet
    $TempObject = [PSCustomObject]@{
        IP = $IP
        Status = ('Offline - No response', 'Online')[$Response]
        Name = $CAR_FRIENDLY
        }
    $TempObject
    }



$OnlineIPList = ($Results | Where-Object {$_.Status -eq 'Online'}).IP



$MidDot = [char]183
$Choice = ''
while ($Choice -eq '')
    {
    Clear-Host
    $ValidChoices = @('A', 'X')
    foreach ($Index in 0..($Results.Count - 1))
        {
        $PaddedIP = $Results[$Index].IP.PadRight(13, $MidDot)
        $PaddedName = $Results[$Index].Name.PadRight(10, $MidDot)
        "[ {0} ] - {1,-10} {2,-10} {3}" -f $Index, $PaddedName, $PaddedIP, $Results[$Index].Status
        $ValidChoices += $Index
        }
    ''
    $Choice = '0'
    #$Choice = (Read-Host 'Please choose a [number], [A] for All Online, or [X] to exit.').ToUpper()
    if ($Choice -notin $ValidChoices)
        {
        #[console]::Beep(1000, 300)
        Write-Output "    >> $Choice << is not a valid selection, please try again."
        LogIt -message (">>$Choice << is not a valid selection, please try again.") -component "Cam_Choice()" -type 3 

        #start-sleep -s 5
        ''
        #Break
        EXIT
        #$Choice = ''

        continue
        }
    $TargetList = @()
    switch ($Choice)
        {
        {$_ -in 0..4}
            {
            if ($Results[$Choice].Status -eq 'Online')
                {
                $TargetList += $Results[$Choice].IP
                }
                else
                {
                Write-Output ''
                "The address you chose >> [{0}] - {1} << is offline." -f $Choice, $Results[$Choice].IP
                '    Returning to the menu.'
                LogIt -message ("The address you chose >> [{0}] - {1} << is offline." -f $Choice, $Results[$Choice].IP) -component "Cam_Choice()" -type 3 

                #pause
                EXIT
                
                }
            #$Choice = ''
            Break
          
            }
        'A'
            {
            $TargetList = $OnlineIPList
            $SCRIPT:CARTARGET = $CAR1,$CAR2,$CAR3,$CAR4,$CAR5
            $Host.UI.WriteWarningLine("THIS FEATURE HAS NOT BEEN IMPLEMENTED YET")
            #DOWNLOAD-ALL
            EXIT
            $Choice = '' 
            break
            }
        'X'
            {break}
        default
            {$Choice}
        }


    if ($TargetList.Count -gt 0)
        {
        Clear-Host
        foreach ($TL_IP in $TargetList)
            {
            $Script:TL_IP = $TL_IP

            Process_Files $TL_IP

            }
        }
    }





# restore previous VerbosePref
$VerbosePreference = $Old_VPref



}


function Process_Files
{
Param(
    [parameter(Mandatory=$true)]
    [String]
    $IP_Target
)
IF ($IP_TARGET -EQ $CAR1.IP) {$SCRIPT:CARTARGET = $CAR1}
IF ($IP_TARGET -EQ $CAR2.IP) {$SCRIPT:CARTARGET = $CAR2}
IF ($IP_TARGET -EQ $CAR3.IP) {$SCRIPT:CARTARGET = $CAR3}
IF ($IP_TARGET -EQ $CAR4.IP) {$SCRIPT:CARTARGET = $CAR4}
IF ($IP_TARGET -EQ $CAR5.IP) {$SCRIPT:CARTARGET = $CAR5}




$SCRIPT:CARPATH = $CARTARGET.CARPATH
$SCRIPT:DC_IP = $CARTARGET.IP
write-output "`n"
write-output "RETREIVING FILE LIST FROM CAMERA"
LogIt -message ("Retreiving File List From Camera") -component "Process_Files()" -type 1
(New-Object System.Net.WebClient).DownloadString("http://{0}/blackvue_vod.cgi" -f $CARTARGET.IP) >$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\file.list
write-output "`n"

if (test-path $DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\file.list) {
    write-output "File List successfully retreived"
    LogIt -message ("File List successfully retreived") -component "Process_Files()" -type 2
    }else{
        #$Host.UI.WriteWarningLine("UNABLE TO CONTACT CAMERA... EXITING")
        LogIt -message ("UNABLE TO CONTACT CAMERA... EXITING") -component "Process_Files()" -type 3
        write-output "Press any key to exit..."
        #$HOST.UI.RawUI.Flushinputbuffer()
        #$HOST.UI.RawUI.ReadKey(“NoEcho,IncludeKeyDown”) | OUT-NULL
        #$HOST.UI.RawUI.Flushinputbuffer()
        EXIT
}
write-output "`n"


$SCRIPT:FILE_LIST1 = (Get-Content $DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\file.list) -notmatch "v:" -split "`r`n"
DEL $DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\file.list
$SCRIPT:FILE_COUNT = $FILE_LIST1 | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT
$SCRIPT:VID_COUNT = [math]::round( ($FILE_COUNT / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:PARK_COUNT = ($FILE_LIST1 | WHERE-OBJECT  {$_ -LIKE "*_P*.MP4*"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:PARK_COUNT= [math]::round( ($PARK_COUNT / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:EVENT_COUNT = ($FILE_LIST1 | WHERE-OBJECT {$_ -LIKE "*_E*.MP4*"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:EVENT_COUNT= [math]::round( ($EVENT_COUNT / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:MANUAL_COUNT = ($FILE_LIST1 | WHERE-OBJECT {$_ -LIKE "*_M*.MP4*"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:MANUAL_COUNT= [math]::round( ($MANUAL_COUNT / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:NORMAL_COUNT = ($FILE_LIST1 | WHERE-OBJECT {$_ -LIKE "*_N*.MP4*"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:NORMAL_COUNT= [math]::round( ($NORMAL_COUNT / 2) , [system.midpointrounding]::AwayFromZero )



$SCRIPT:FILE_LIST2 = $FILE_LIST1 | % { if ($_) { $_.trimstart('n:/Record/').split(',')[0] }}


$FILE_LIST3 = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_EVENT = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_PARK = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_NORMAL = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_MANUAL = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_ALL = New-Object System.Collections.Generic.List[System.Object]

$SCRIPT:FILE_LIST_EVENT_TMP = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_PARK_TMP = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_NORMAL_TMP = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_MANUAL_TMP = New-Object System.Collections.Generic.List[System.Object]
$SCRIPT:FILE_LIST_ALL_TMP = New-Object System.Collections.Generic.List[System.Object]



FOREACH ($LISTING IN $FILE_LIST2) {IF ( test-path "$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\$LISTING" ) {
    }else{ 
          $FILE_LIST3.ADD("$LISTING")
         }
    }


$SCRIPT:PARK_COUNT_NEW = ($FILE_LIST3 | WHERE-OBJECT  {$_ -LIKE "*_P*.MP4"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:PARK_COUNT_NEW = [math]::round( ($PARK_COUNT_NEW / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:EVENT_COUNT_NEW = ($FILE_LIST3 | WHERE-OBJECT {$_ -LIKE "*_E*.MP4"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:EVENT_COUNT_NEW= [math]::round( ($EVENT_COUNT_NEW / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:MANUAL_COUNT_NEW = ($FILE_LIST3 | WHERE-OBJECT {$_ -LIKE "*_M*.MP4"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:MANUAL_COUNT_NEW= [math]::round( ($MANUAL_COUNT_NEW / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:NORMAL_COUNT_NEW = ($FILE_LIST3 | WHERE-OBJECT {$_ -LIKE "*_N*.MP4"} | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$SCRIPT:NORMAL_COUNT_NEW = [math]::round( ($NORMAL_COUNT_NEW / 2) , [system.midpointrounding]::AwayFromZero )
$SCRIPT:VID_COUNT_NEW = ($SCRIPT:NORMAL_COUNT_NEW + $SCRIPT:MANUAL_COUNT_NEW + $SCRIPT:EVENT_COUNT_NEW + $SCRIPT:PARK_COUNT_NEW)





FOREACH ($ENTRY IN $FILE_LIST3) {IF ($ENTRY -LIKE "*_E*.mp4") {
    $ENTRY = $ENTRY.trimend("F.mp4")
    $ENTRY = $ENTRY.trimend("R.mp4")
    $FILE_LIST_EVENT_TMP.ADD("$ENTRY")
    $ENTRY = ''
    }
}
$FILE_LIST_EVENT = $FILE_LIST_EVENT_TMP|
    Sort-Object |
    Get-Unique





FOREACH ($ENTRY IN $FILE_LIST3) {IF ($ENTRY -LIKE "*_P*.mp4") {
    $ENTRY = $ENTRY.trimend("F.mp4")
    $ENTRY = $ENTRY.trimend("R.mp4")
    $FILE_LIST_PARK_TMP.ADD("$ENTRY")
    $ENTRY = ''
    }
}
$FILE_LIST_PARK = $FILE_LIST_PARK_TMP|
    Sort-Object |
    Get-Unique






FOREACH ($ENTRY IN $FILE_LIST3) {IF ($ENTRY -LIKE "*_N*.mp4") {
    $ENTRY = $ENTRY.trimend("F.mp4")
    $ENTRY = $ENTRY.trimend("R.mp4")
    $FILE_LIST_NORMAL_TMP.ADD("$ENTRY")
    $ENTRY = ''
    }
}
$FILE_LIST_NORMAL = $FILE_LIST_NORMAL_TMP|
    Sort-Object |
    Get-Unique






FOREACH ($ENTRY IN $FILE_LIST3) {IF ($ENTRY -LIKE "*_M*.mp4") {
    $ENTRY = $ENTRY.trimend("F.mp4")
    $ENTRY = $ENTRY.trimend("R.mp4")
    $FILE_LIST_MANUAL_TMP.ADD("$ENTRY")
    $ENTRY = ''
    }
}
$FILE_LIST_MANUAL = $FILE_LIST_MANUAL_TMP|
    Sort-Object |
    Get-Unique





FOREACH ($ENTRY IN $FILE_LIST3) {IF (1 -EQ 1) {
    $ENTRY = $ENTRY.trimend("F.mp4")
    $ENTRY = $ENTRY.trimend("R.mp4")
    $FILE_LIST_ALL_TMP.ADD("$ENTRY")
    $ENTRY = ''
    }
}
$FILE_LIST_ALL = $FILE_LIST_ALL_TMP|
    Sort-Object |
    Get-Unique






write-output "`n"
write-output "`n"
write-output "`n"
write-output "`n"
write-output "`n"
write-output " ------------------------------------------------------------------------------------------------------- "
write-output "`n"
write-output "TOTAL NUMBER OF VIDEOS ON THE CAMERA IS $VID_COUNT WITH $VID_COUNT_NEW NEW"
LogIt -message ("Total:  $VID_COUNT | New: $VID_COUNT_NEW ") -component "Process_Files()" -type 1
write-output "`n"
write-output "NUMBER OF NORMAL RECORDINGS IS $NORMAL_COUNT WITH $NORMAL_COUNT_NEW NEW"
LogIt -message ("Normal: $NORMAL_COUNT | New: $NORMAL_COUNT_NEW") -component "Process_Files()" -type 1
write-output "`n"
write-output "NUMBER OF EVENT RECORDINGS IS $EVENT_COUNT WITH $EVENT_COUNT_NEW NEW"
LogIt -message ("Event:  $EVENT_COUNT | New: $EVENT_COUNT_NEW") -component "Process_Files()" -type 1
write-output "`n"
write-output "NUMBER OF PARKED RECORDINGS IS $PARK_COUNT WITH $PARK_COUNT_NEW NEW"
LogIt -message ("Parked: $PARK_COUNT | New: $PARK_COUNT_NEW") -component "Process_Files()" -type 1
write-output "`n"
write-output "NUMBER OF MANUAL RECORDINGS IS $MANUAL_COUNT WITH $MANUAL_COUNT_NEW NEW"
LogIt -message ("Manual: $MANUAL_COUNT | New: $MANUAL_COUNT_NEW") -component "Process_Files()" -type 1
write-output "`n"
write-output " ------------------------------------------------------------------------------------------------------- "






$Choice = ''
while ($Choice -eq '')
    {
    $ValidChoices = @('E', 'N', 'P', 'M', 'A', 'X')
    write-output " Please choose from the following options:
                `n
                -------------------------------------
                [E] For Event recordings Only
                [N] For Normal recordings only
                [P] For Parking mode recordings only
                [M] For Manual recordings only
                [A] For all recordings
                -------------------------------------
                [X] To Quit
                `n
                "
    $Choice = 'A'
    #$Choice = (Read-Host 'Please enter a selection  ').ToUpper()
    if ($Choice -notin $ValidChoices)
        {
        #[console]::Beep(1000, 300)
        Write-Output "    >> $Choice << is not a valid selection, please try again."
        start-sleep -s 5
        ''
        $Choice = ''

        continue
        }
    switch ($Choice)
        {
        'A'
            {
            $SCRIPT:FILE_COUNT = ($VID_COUNT_NEW*2)
            DOWNLOAD_VIDS ALL
            $Choice = '' 
            break
            }
        'X'
            {exit}
            exit
            {$Choice}
        'E'
            {
            $SCRIPT:FILE_COUNT = ($EVENT_COUNT_NEW*2)
            DOWNLOAD_VIDS EVENT
            $Choice = '' 
            break
            }
        'P'
            {
            $SCRIPT:FILE_COUNT = ($PARK_COUNT_NEW*2)
            DOWNLOAD_VIDS PARKING
            $Choice = '' 
            break
            }
        'M'
            {
            $SCRIPT:FILE_COUNT = ($MANUAL_COUNT_NEW*2)
            DOWNLOAD_VIDS MANUAL
            $Choice = '' 
            break
            }
        'N'
            {
            $SCRIPT:FILE_COUNT = ($NORMAL_COUNT_NEW*2)
            DOWNLOAD_VIDS NORMAL
            $Choice = '' 
            break
            }

        }


    }


}


FUNCTION DOWNLOAD_VIDS 
{
Param(
    [parameter(Mandatory=$true)]
    [String]
    $SELECTION
)

write-output "Downloading Video and Data Files... Please Wait (Press Ctrl + C to abort at any time)"
LogIt -message (Downloading Video and Data Files...) -component "Download_Vids()" -type 2

 
$PROCESSTIME = Get-Date
IF ($SELECTION -EQ 'ALL') {$FILE_LIST = $FILE_LIST_ALL}
IF ($SELECTION -EQ 'ALL') {$VID_COUNT = $VID_COUNT_NEW}

IF ($SELECTION -EQ 'PARKING') {$FILE_LIST = $FILE_LIST_PARK}
IF ($SELECTION -EQ 'PARKING') {$VID_COUNT = $PARK_COUNT_NEW}

IF ($SELECTION -EQ 'MANUAL') {$FILE_LIST = $FILE_LIST_MANUAL}
IF ($SELECTION -EQ 'MANUAL') {$VID_COUNT = $MANUAL_COUNT_NEW}

IF ($SELECTION -EQ 'NORMAL') {$FILE_LIST = $FILE_LIST_NORMAL}
IF ($SELECTION -EQ 'NORMAL') {$VID_COUNT = $NORMAL_COUNT_NEW}

IF ($SELECTION -EQ 'EVENT') {$FILE_LIST = $FILE_LIST_EVENT}
IF ($SELECTION -EQ 'EVENT') {$VID_COUNT = $EVENT_COUNT_NEW}


$FILENUM_PROGRESS_UNROUNDED = 0
$FILENUM_PROGRESS = 0
$ACTIVITY_ID = 0
$FILENUM_PROGRESS_UNROUNDED = 0
$VID_COUNT = ($FILE_LIST | MEASURE |SELECT-OBJECT -EXPANDPROPERTY COUNT)
$MATHCOUNT = ($VID_COUNT *2)
$FILECOUNT = ($VID_COUNT *2)

FOREACH ($DATA IN $FILE_LIST)
{
$ACTIVITY_ID = ($ACTIVITY_ID+1)
$FILENUM_PERCENTAGE = 0
$FILENUM_PROGRESS = ($FILENUM_PROGRESS+1)

$Progress = [math]::Round((($FILENUM_PROGRESS / $VID_COUNT) * 100),2)
Write-Output -ID 1 -ACTIVITY "DOWNLOADING VIDEO FILES: $Progress%"
LogIt -message ("Downloading Video Files: $Progress%") -component "Download_Vids()" -type 1

Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT"  -CurrentOperation "Retreiving video files from camera: 0%"
LogIt -message ("Getting video $FILENUM_PROGRESS of $VID_COUNT") -component "Download_Vids()" -type 1 
LogIt -message ("Retreiving video files from camera: 0%") -component "Download_Vids()" -type 1 

$urlF = "http://$DC_IP/Record/$DATA" + "F.mp4"
$urlR = "http://$DC_IP/Record/$DATA" + "R.mp4"
$urlG = "http://$DC_IP/Record/$DATA.gps"
$url3 = "http://$DC_IP/Record/$DATA.3gf"

$VIDNAME = $DATA + 'F.mp4'
Write-Output $VIDNAME
$DEST = "$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\$VIDNAME"
(New-Object System.Net.WebClient).DownloadFile($urlF, $DEST)
    IF ($FILENUM_PROGRESS_UNROUNDED -EQ $VID_COUNT)
    {
    } ELSE {
        $FILENUM_PROGRESS_UNROUNDED = ($FILENUM_PROGRESS_UNROUNDED+0.5)
        $FILENUM_PERCENTAGE = ($FILENUM_PERCENTAGE+50)
    }
    Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT" -CurrentOperation "Retrieving video files from camera: $FILENUM_PERCENTAGE%"
    LogIt -message ("Getting video $VIDNAME | $FILENUM_PROGRESS of $VID_COUNT") -component "Download_Vids()" -type 2 
    LogIt -message ("Retrieving video files from camera: $FILENUM_PERCENTAGE%") -component "Download_Vids()" -type 1 
    
$VIDNAME = $DATA + 'R.mp4'
Write-Output $VIDNAME
$DEST = "$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\$VIDNAME"
(New-Object System.Net.WebClient).DownloadFile($urlR, $DEST)
    IF ($FILENUM_PROGRESS_UNROUNDED -EQ $VID_COUNT)
    {
    } ELSE {
        $FILENUM_PROGRESS_UNROUNDED = ($FILENUM_PROGRESS_UNROUNDED+0.3)
        $FILENUM_PERCENTAGE = ($FILENUM_PERCENTAGE+30)
    }
    Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT" -CurrentOperation "Retrieving video files from camera: $FILENUM_PERCENTAGE%"
    LogIt -message ("Getting video $VIDNAME | $FILENUM_PROGRESS of $VID_COUNT") -component "Download_Vids()" -type 2
    LogIt -message ("Retrieving video files from camera: $FILENUM_PERCENTAGE%") -component "Download_Vids()" -type 1 
    
$VIDNAME = $DATA + '.gps'
Write-Output $VIDNAME
$DEST = "$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\$VIDNAME"
(New-Object System.Net.WebClient).DownloadFile($urlG, $DEST)
    IF ($FILENUM_PROGRESS_UNROUNDED -EQ $VID_COUNT)
    {
    } ELSE {
        $FILENUM_PROGRESS_UNROUNDED = ($FILENUM_PROGRESS_UNROUNDED+0.1)
        $FILENUM_PERCENTAGE = ($FILENUM_PERCENTAGE+10)
    }
    Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT" -CurrentOperation "Retrieving video files from camera: $FILENUM_PERCENTAGE%"
    LogIt -message ("Getting video $VIDNAME | $FILENUM_PROGRESS of $VID_COUNT") -component "Download_Vids()" -type 2
    LogIt -message ("Retrieving video files from camera: $FILENUM_PERCENTAGE%") -component "Download_Vids()" -type 1 
    
Start-Sleep -m 100

$VIDNAME = $DATA + '.3gf'
Write-Output $VIDNAME 
$DEST = "$DCROOT_DRIVE\$DCROOT_FOLDER\$CARPATH\$VIDNAME"
(New-Object System.Net.WebClient).DownloadFile($url3, $DEST)
    IF ($FILENUM_PROGRESS_UNROUNDED -EQ $VID_COUNT)
    {
    } ELSE {
        $FILENUM_PROGRESS_UNROUNDED = ($FILENUM_PROGRESS_UNROUNDED+0.1)
        $FILENUM_PERCENTAGE = ($FILENUM_PERCENTAGE+10)
    }
    Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT" -CurrentOperation "Retrieving video files from camera: $FILENUM_PERCENTAGE%"
    LogIt -message ("Getting video $VIDNAME | $FILENUM_PROGRESS of $VID_COUNT") -component "Download_Vids()" -type 2
    LogIt -message ("Retrieving video files from camera: $FILENUM_PERCENTAGE%") -component "Download_Vids()" -type 1 
    
Start-Sleep -m 250

Write-Output -ID ($ACTIVITY_ID+1) -Activity "Getting video $FILENUM_PROGRESS of $VID_COUNT"  -Completed
LogIt -message ("Getting video $FILENUM_PROGRESS of $VID_COUNT Completed") -component "Download_Vids()" -type 1 


}

Write-Output "Time taken: $((Get-Date).Subtract($PROCESSTIME).Seconds) second(s)"
LogIt -message ("Time taken: $((Get-Date).Subtract($PROCESSTIME).Seconds) second(s)") -component "Download_Vids()" -type 1 


Write-Output -ID 1 -ACTIVITY "DOWNLOADING VIDEO FILES" -Completed
LogIt -message ("DOWNLOADING VIDEO FILES COMPLETED") -component "Download_Vids()" -type 1 

write-output "`n"
write-output "`n"

write-output "All files have been downloaded from the camera."
LogIt -message ("All files have been downloaded from the camera.") -component "Download_Vids()" -type 1 
write-output "`n"
#write-output " Please press a key to complete the operaton. "
#$HOST.UI.RawUI.Flushinputbuffer()
#$HOST.UI.RawUI.ReadKey(“NoEcho,IncludeKeyDown”) | OUT-NULL
#$HOST.UI.RawUI.Flushinputbuffer()


write-output " ------------------------------------------------------------------------------------------------------- "
write-output " ------------------------------------------------------------------------------------------------------- "
write-output " ------------------------------------------------------------------------------------------------------- "
write-output "`n"
write-output "`n"
EXIT



}




SET_ARRAYS
INTRO
CHECK_PATHS
CAM_CHOICE