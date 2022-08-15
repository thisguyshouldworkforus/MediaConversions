# --------------------------------------------------------------
# Name: tv_kids_media_scanner.ps1
#
# Dependency:
# Access to '\\truenas\splishsplash', mounted as "T:\"
#
# Description:
# Loop through movies and create a single file with multiple audio/video streams
# to improve UX on low bandwidth Roku devices
# --------------------------------------------------------------

# Create the various Bitrate Ladder versions, as suggested by Roku
# https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings

1..8 | Foreach-Object -ThrottleLimit 10 -Parallel {
    # Get root path
    $ROOT = "T:\movies"
    $TEMPDIR = "E:\MediaConversions\BitLadder"
    $DATE = (Get-Date -Format "yyyyMMdd").ToString()
    $FOLDERS = @('White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO')

    # Itterate through list and act on results
    foreach ($FOLDER in $FOLDERS){
        $LOGFILE = "E:\MediaConversions" + '\' + $FOLDER + '.' + $DATE + '_' + $_ + '.log'
        $FULL_FOLDER = $ROOT + '\' + $FOLDER

        if ( ! (Test-Path -Path $TEMPDIR)){
            New-Item -Path $TEMPDIR -ItemType Directory | Out-Null
            Write-Host -NoNewline "`nCreated '$TEMPDIR' directory path.`r`n" | Tee-Object -FilePath "$LOGFILE" -Append
        }

        # Report the current directory
        Write-Host -NoNewline "`nWorking Directory: '$FOLDER'" | Tee-Object -FilePath "$LOGFILE" -Append
        foreach ($FILE in Get-ChildItem -Path $FULL_FOLDER | Where-Object Name -Match "(.*)(\.)(mp4|avi|mpg|mpeg|mkv|m4v)"){
            $FULL_FOLDER = $ROOT + '\' + $FOLDER
            $SOURCE = $FULL_FOLDER + '\' + $Matches[0]
            $PLEXFILE = $Matches[1] + "_STEP" + $_ + '.mp4'
            $OUTPUTDIR = $TEMPDIR + '\' + $FOLDER

            if ( ! (Test-Path -Path $OUTPUTDIR)){
                New-Item -Path $OUTPUTDIR -ItemType Directory | Out-Null
                Write-Host -NoNewline "`nCreated '$OUTPUTDIR' directory path.`r`n" | Tee-Object -FilePath "$LOGFILE" -Append
            }

            $OUTPUT = $TEMPDIR + '\' + $FOLDER + '\' + $PLEXFILE

            #Write-Host -NoNewline "`nRegex Group 0: "$Matches[0] | Tee-Object -FilePath "$LOGFILE" -Append
            #Write-Host -NoNewline "`nRegex Group 1: "$Matches[1] | Tee-Object -FilePath "$LOGFILE" -Append
            #Write-Host -NoNewline "`nRegex Group 2: "$Matches[2] | Tee-Object -FilePath "$LOGFILE" -Append
            #Write-Host -NoNewline "`nRegex Group 3: "$Matches[3] | Tee-Object -FilePath "$LOGFILE" -Append
            Write-Host -NoNewline "`nSource: '$SOURCE'" | Tee-Object -FilePath "$LOGFILE" -Append
            Write-Host -NoNewline "`nFull Folder: '$FULL_FOLDER'" | Tee-Object -FilePath "$LOGFILE" -Append
            Write-Host -NoNewline "`nPlex File: '$PLEXFILE'" | Tee-Object -FilePath "$LOGFILE" -Append
            Write-Host -NoNewline "`nFinal Output: '$OUTPUT'" | Tee-Object -FilePath "$LOGFILE" -Append

            if ( ! (Test-Path -Path $OUTPUT)){
                Write-Host -NoNewline "`nOrignal Path: '$FULL_FOLDER'" | Tee-Object -FilePath "$LOGFILE" -Append
                Write-Host -NoNewline "`nOptimized Path: '$OUTPUT'" | Tee-Object -FilePath "$LOGFILE" -Append
                Write-Host -NoNewline "`nOptimizing '$FILE' as '$PLEXFILE' in '$TEMPDIR'." | Tee-Object -FilePath "$LOGFILE" -Append
                D:\Applications\HandBrake\HandBrakeCLI.exe --preset-import-file 'D:\MediaApps\MuxScripts\HandBrake_Presets\BITLADDER.json' --preset BITLADDER/STEP$_ --input $SOURCE --output $OUTPUT --verbose | Tee-Object -FilePath "$LOGFILE" -Append
                if ($?){
                    Write-Host -NoNewline "`n`nEncoding of '$PLEXFILE' in '$TEMPDIR' was successful.`n`n`n"
                }else{
                    Write-Host -NoNewline -BackgroundColor Red -ForegroundColor White "`n`n`nEncoding of '$PLEXFILE' in '$TEMPDIR' was NOT SUCCESSFUL.`n`n`n"
                    Write-Error -Message "Error encoding '$PLEXFILE'!" -Category InvalidResult -RecommendedAction "Exit" -Verbose
                }
            }else{
                Write-Host -NoNewline "`n'$OUTPUT' already exists, skipping.`n`n" | Tee-Object -FilePath "$LOGFILE" -Append
            }
        }
    }
}

# Mux the 8 Bitrate Ladder steps into a single file, with a common audio stream
$STEPS = @(Get-ChildItem -Path $OUTPUTDIR -Name)
$COUNT = 0
ForEach ($STEP in $STEPS){
    $INPUT_FILES += ("-i $STEP ")
    $VIDEO += ("[" + $COUNT + ":v]" + "[v" + $COUNT + "],")
    $V_ALIAS += ("[v" + $COUNT + "]")
    $AUDIO += ("[" + $COUNT + ":a]" + "[a" + $COUNT + "],")
    $A_ALIAS += ("[a" + $COUNT + "]")
    $COUNT++
}

$V_ALIAS += ("[video]")
$A_ALIAS += ("[audio]")
$FLATTEN = ('-' + "$INPUT_FILES" + "-filter_complex " + '"' + "$VIDEO" + ";" + "$AUDIO" + '"' + ';' + "$V_ALIAS" + ';' + "$A_ALIAS" + '"' + " -map [video][audio] -c:v h264 -c:a copy").Replace(',;', ';').Replace(',";', ';').Replace(',[video]', '[video]').Replace(',[audio]', '[audio]').TrimStart(' ')

D:\Applications\ffmpeg\bin\ffmpeg.exe $FLATTEN -f matroska "E:\MediaConversions\White.Boy.Rick.2018_MultiStreamTest_AAC.H264.mkv"