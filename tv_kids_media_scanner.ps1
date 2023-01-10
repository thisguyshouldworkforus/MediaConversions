# --------------------------------------------------------------
# Name: tv_kids_media_scanner.ps1
#
# Dependency:
# Access to '\\truenas\splishsplash\media', mounted as "P:\"
#
# Description:
# Loop through children's media and break apart multi-episodes,
# but also encode for preferred formats, for better user experience.
# --------------------------------------------------------------

# Get root path
$ROOT = "T:\tv.kids"
$DATE = (Get-Date -Format "yyyyMMdd").ToString()
$FOLDERS = @('Dino.Ranch', 'Paw.Patrol', 'Marvels.Spidey.and.His.Amazing.Friends', 'Sesame.Street')
Function Loggit{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $LOGSTRING
    )

    # Set a logfile
    $LOGDIR = "E:\MediaConversions"
    $MASTERLOG = $LOGDIR + '\' + $DATE + '.' + 'MASTERLOG.log'
    $LOGFILE = $DATE + '.' + $FOLDER.Replace(' ', '_') + '.log'
    $LOGPATH = "$LOGDIR" + '\' + "$LOGFILE"
    if ( ! (Test-Path -Path $LOGDIR)){
        New-Item "$LOGDIR" -ItemType Directory | Out-Null
    }
    if ( ! (Test-Path -Path $MASTERLOG)){
        New-Item -Path "$MASTERLOG" -ItemType File | Out-Null
    }
    if ( ! (Test-Path -Path $LOGPATH)){
        New-Item -Path "$LOGPATH" -ItemType File | Out-Null
    }
    if ( ! (Test-Path -Path $LOGPATH)){
        Write-Error -Message "Logpath does not exist!" -Category InvalidResult -RecommendedAction "Exit" -Verbose
        Exit-PSSession
    }
    if ( ! (Test-Path -Path $MASTERLOG)){
        Write-Error -Message "Masterlog does not exist!" -Category InvalidResult -RecommendedAction "Exit" -Verbose
        Exit-PSSession
    }
    if($null -ne $LOGSTRING){
        Add-content -NoNewline -Path $LOGPATH -Value $LOGSTRING
        Add-content -NoNewline -Path $MASTERLOG -Value $LOGSTRING
    }
}

function PlexOptimization{

    $PLEXVERSIONS = $FULL_FOLDER + '\' + "Plex Versions"
    
    if ( ! (Test-Path -Path $PLEXVERSIONS)){
        New-Item -Path $PLEXVERSIONS -ItemType Directory | Out-Null
        Loggit "`r`nCreated '$PLEXVERSIONS' directory path.`r`n"
    }

    foreach ($PROFILE in ('"NVENC/H.264 NVENC 1080p MP4 AAC (Roku)"', '"NVENC/H.264 NVENC 720p MP4 AAC (Roku)"', '"NVENC/H.265 NVENC 4k (iPad)"')){
        if ($PROFILE -like "*H.264*1080p*"){
            $EXT = "_H.264_NVENC_1080p_AAC.mp4"
            $PLEXDEVICE = 'roku'
        }elseif ($PROFILE -like "*H.264*720p*"){
            $EXT = "_H.264_NVENC_720p_AAC.mp4"
            $PLEXDEVICE = 'roku'
        }elseif($PROFILE -like "*H.265*"){
            $EXT = "_H.265_NVENC_2160p_AC3.m4v"
            $PLEXDEVICE = 'ipad'
        }

        $PLEXFILE = $Matches[1] + $Matches[2] + $Matches[3] + $EXT

        $PLEXLOCATION = $PLEXVERSIONS + '\' + $PLEXDEVICE
        if ( ! (Test-Path $PLEXLOCATION)){
            New-Item -Path $PLEXLOCATION -ItemType Directory | Out-Null
        }

        $OUTPUT = $PLEXVERSIONS + '\' + $PLEXDEVICE + '\' + $PLEXFILE
        if ( ! (Test-Path -Path $OUTPUT)){
            Loggit "`r`nOrignal Path: '$FULL_FOLDER'`r`nOptimized Path: '$OUTPUT`r`nOptimizing '$FILE' as '$PLEXFILE' in '$PLEXLOCATION'.`r`n`r`n"
            D:\Applications\HandBrake\HandBrakeCLI.exe --preset-import-file .\HandBrakePresets.json --preset $PROFILE --input $SOURCE --output $OUTPUT --verbose
            if ($?){
                Loggit "`r`nEncoding of '$PLEXFILE' in '$PLEXLOCATION' was successful.`r`n`r`n"
            }
        }else{
            Loggit "`r`n'$OUTPUT' already exists, skipping.`r`n"
        }
    }
}

# Itterate through list and act on results
foreach ($FOLDER in $FOLDERS){

    # Report the current directory
    Write-Output "Working Directory: '$FOLDER'"
    
    # Define the regular expression
    $FILE_REGEX = "(S[0-9]{2}E[0-9]{2})(\.)($FOLDER)(\.)([a-z]{2})"

    $FULL_FOLDER = $ROOT + '\' + $FOLDER

    foreach ($FILE in Get-ChildItem -Path $FULL_FOLDER -Exclude 'Plex Versions' -Name | Where-Object {$_.Name -like "*.mp4" -or "*.avi" -or "*.mpg" -or "*.mkv" -or "*.m4v"}){
        
        if ($FILE -Match $FILE_REGEX){

            $SOURCE = $ROOT + '\' + $FOLDER + '\' + $FILE
            PlexOptimization
        }else{
            Loggit "`r`n'$FILE' did not match '$FILE_REGEX'"
        }
    }
}
