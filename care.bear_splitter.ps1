# --------------------------------------------------------------
# Name: dino.ranch_splitter.ps1
#
# Dependency:
# Access to '\\truenas\splishsplash\media', mounted as "P:\"
#
# Description:
# Loop through children's media and break apart multi-episodes,
# but also encode for preferred formats, for better user experience.
# --------------------------------------------------------------

# Get root path
$ROOT = "F:\media_downloads\torrent\complete\The.Care.Bears.S01-S04.DVDRip.Webrip"
$DATE = (Get-Date -Format "yyyyMMdd").ToString()
$FOLDER = "The.Care.Bears.S04.1988.AMZN.WEBRip.X264"
$FULL_FOLDER = $ROOT + '\' + $FOLDER
$FULL_FILE = $FULL_FOLDER + '\' + $FILE

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

# Set the Variables
$SPLIT_AB = "parts:-00:10:58"
$SPLIT_BC = "parts:00:10:58-"
    
# Define the regular expression
$SPLIT_REGEX = "(S04E)([0-9]{2})(-)([0-9]{2})( - )(.*)(\-)(.*)(\.)([a-z]{2,4})"

foreach ($FILE in Get-ChildItem -Path $FULL_FOLDER -Exclude 'Plex Versions' -Name | Where-Object {$_.Name -like "*.mp4" -or "*.avi" -or "*.mpg" -or "*.mkv" -or "*.m4v"}){
    if ($FILE -Match $SPLIT_REGEX){
        Loggit "`r`nSplitting '$FILE' ('$FULL_FILE')"
        $SOURCE = $ROOT + '\' + $FOLDER + '\' + $FILE
        $OUTPUT1 = $ROOT + '\' + $FOLDER + '\' + $Matches[1] + $Matches[2] + $Matches[3] + $Matches[6] + $Matches[9] + $Matches[10]
        $OUTPUT2 = $ROOT + '\' + $FOLDER + '\' + $Matches[1] + $Matches[4] + $Matches[7] + $Matches[8] + $Matches[9] + $Matches[10]
        Loggit "`r`nSource File: '$SOURCE'"
        Loggit "`r`nSplit_AB File: '$OUTPUT1'"
        Loggit "`r`nSplit_BC File: '$OUTPUT2'"
        F:\MediaApps\Tools\mkvmerge.exe --output $OUTPUT1 --split $SPLIT_AB $SOURCE --verbose
        if ($?){
            Loggit "`r`nSplitting of '$FILE', into '$OUTPUT1' was successful"
            F:\MediaApps\Tools\mkvmerge.exe --output $OUTPUT2 --split $SPLIT_BC $SOURCE --verbose
            if ($?){
                Loggit "`r`nSplitting of '$FILE', into '$OUTPUT2' was successful"
                #Remove-Item $SOURCE -Force
                #if ($?){
                #    Loggit "`r`n'$SOURCE' was successfully removed.`r`n`r`n"
                #}else{
                #    Loggit "`r`nThere was an error trying to remove '$SOURCE'.`r`nPlease review.`r`n`r`n"
                #}
            }else{
                Loggit "`r`nThere was an error trying to split '$FILE' into '$OUTPUT2'.`r`nPlease review.`r`n`r`n"
            }
        }else{
            Loggit "`r`nThere was an error trying to split '$FILE' into '$OUTPUT1'.`r`nPlease review.`r`n`r`n"
        }
    }else{
        Loggit "`r`n'$FILE' did not match '$SPLIT_REGEX'"
    }
}
