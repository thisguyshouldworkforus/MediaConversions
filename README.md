# Media Conversion Scripts

## Purpose
- To learn PowerShell 7+ (pwsh)
- Learn HandBrakeCLI
- Learn FFMPEG (CLI)
- Learn how to create multi-stream videos
  - Optimize media library for a wide range of mid-to-low bandwidth Roku devices

## Language
- PowerShell v7.2.6
  *- I'm already a "Power User" with Linux/BASH ... can do some basic things in Python, but I really fall short on PowerShell, so I thought this would be a great project to introduce me to the language.  I appreciate any feedback on the code, and/or tips/tricks!  Thank you!*

## Tools
- [HandBrakeCLI](https://handbrake.fr/downloads2.php)
- [FFMPEG](https://ffmpeg.org/download.html)

## Documentation
### RTFM
- https://handbrake.fr/docs/en/1.5.0/
- https://ffmpeg.org/documentation.html
  - https://trac.ffmpeg.org/

## Process
### The Bit Ladder
As outlined here (https://developer.roku.com/docs/specs/media/streaming-specifications.md), the Roku developer platform talks about how the devices can integlligently switch between the available streams within the file to best serve content.  I had always assumed that my [Plex server](https://www.plex.tv/media-server-downloads/) would do this with various versions of the media I had stored in the "[Plex Versions](https://support.plex.tv/articles/213095317-creating-optimized-versions/)" folder.  Perhaps my mistake was manually re-encoding the videos and just dropping them there, perhaps I had to use the [Plex method so the media could be "Tagged" somehow -- I'm not sure](https://github.com/ccjensen/PlexMediaTagger).

So, I decided I would follow the Roku recommedation and try to create the "[Bit Ladder](https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings)."
![Roku Bit Ladder](https://i.imgur.com/B55cvjb.jpg)

## The Code
### With this information in hand, I set out to create a script that would automatically convert a movie into the requisite 8 parts:

```powershell
'%HANDBRAKECLI%' `
--preset-import-file '%HANDBRAKEPRESETS%\BITLADDER.json' `
--preset BITLADDER/STEP$_ `
--input $SOURCE `
--output $OUTPUT `
--verbose | Tee-Object -FilePath "$LOGFILE" -Append
```
The preset file I'm passing to HandBrake is whats actually doing all the hard work, and its actually really cool to watch, [if you're into that kind of thing](https://buzz.ng/wp-content/uploads/2019/01/maxresdefault-1-1.jpg).

```json
{
  "PresetList": [
    {
      "ChildrenArray": [
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 384,
          "PictureHeight": 216,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 384x216, 400kbps",
          "PresetName": "STEP8",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 400,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 512,
          "PictureHeight": 288,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 512x288, 700kbps",
          "PresetName": "STEP7",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 700,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 720,
          "PictureHeight": 404,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 720x404, 1100kbps",
          "PresetName": "STEP6",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 1100,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 720,
          "PictureHeight": 404,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 720x404, 1750kbps",
          "PresetName": "STEP5",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 1750,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 1280,
          "PictureHeight": 720,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 1280x720, 2750kbps",
          "PresetName": "STEP4",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 2750,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 1280,
          "PictureHeight": 720,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 1280x720, 3500kbps",
          "PresetName": "STEP3",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 3500,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 1920,
          "PictureHeight": 1080,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 1920x1080, 4300kbps",
          "PresetName": "STEP2",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 4300,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        },
        {
          "AlignAVStart": true,
          "AudioCopyMask": [
            "copy:aac"
          ],
          "AudioEncoderFallback": "mp3",
          "AudioLanguageList": [
            "eng"
          ],
          "AudioList": [
            {
              "AudioBitrate": 128,
              "AudioCompressionLevel": 0,
              "AudioEncoder": "av_aac",
              "AudioMixdown": "stereo",
              "AudioNormalizeMixLevel": false,
              "AudioSamplerate": "48",
              "AudioTrackQualityEnable": false,
              "AudioTrackQuality": 3,
              "AudioTrackGainSlider": 0,
              "AudioTrackDRCSlider": 0
            }
          ],
          "AudioSecondaryEncoderMode": true,
          "AudioTrackSelectionBehavior": "first",
          "ChapterMarkers": true,
          "ChildrenArray": [],
          "Default": false,
          "FileFormat": "av_mp4",
          "Folder": false,
          "FolderOpen": false,
          "Mp4HttpOptimize": false,
          "Mp4iPodCompatible": false,
          "PictureAutoCrop": false,
          "PictureBottomCrop": 0,
          "PictureLeftCrop": 0,
          "PictureRightCrop": 0,
          "PictureTopCrop": 0,
          "PictureDARWidth": 0,
          "PictureDeblockPreset": "off",
          "PictureDeblockTune": "medium",
          "PictureDeblockCustom": "strength=strong:thresh=20:blocksize=8",
          "PictureDeinterlaceFilter": "off",
          "PictureCombDetectPreset": "off",
          "PictureCombDetectCustom": "",
          "PictureDenoiseCustom": "",
          "PictureDenoiseFilter": "off",
          "PictureDenoisePreset": "medium",
          "PictureDenoiseTune": "none",
          "PictureSharpenCustom": "",
          "PictureSharpenFilter": "off",
          "PictureSharpenPreset": "medium",
          "PictureSharpenTune": "none",
          "PictureDetelecine": "off",
          "PictureDetelecineCustom": "",
          "PictureColorspacePreset": "off",
          "PictureColorspaceCustom": "",
          "PictureChromaSmoothPreset": "off",
          "PictureChromaSmoothTune": "none",
          "PictureChromaSmoothCustom": "",
          "PictureItuPAR": false,
          "PictureKeepRatio": true,
          "PictureLooseCrop": false,
          "PicturePAR": "auto",
          "PicturePARWidth": 0,
          "PicturePARHeight": 0,
          "PictureWidth": 1920,
          "PictureHeight": 1080,
          "PictureUseMaximumSize": true,
          "PictureAllowUpscaling": true,
          "PictureForceHeight": 0,
          "PictureForceWidth": 0,
          "PicturePadMode": "none",
          "PicturePadTop": 0,
          "PicturePadBottom": 0,
          "PicturePadLeft": 0,
          "PicturePadRight": 0,
          "PresetDescription": "https://developer.roku.com/docs/specs/media/streaming-specifications.md#avc-1080p-encodings :: 1920x1080, 5800kbps",
          "PresetName": "STEP1",
          "Type": 1,
          "SubtitleAddCC": true,
          "SubtitleAddForeignAudioSearch": true,
          "SubtitleAddForeignAudioSubtitle": false,
          "SubtitleBurnBehavior": "first",
          "SubtitleBurnBDSub": false,
          "SubtitleBurnDVDSub": false,
          "SubtitleLanguageList": [
            "eng"
          ],
          "SubtitleTrackSelectionBehavior": "first",
          "VideoAvgBitrate": 5800,
          "VideoColorMatrixCode": 0,
          "VideoEncoder": "nvenc_h264",
          "VideoFramerateMode": "vfr",
          "VideoGrayScale": false,
          "VideoScaler": "swscale",
          "VideoPreset": "medium",
          "VideoTune": "",
          "VideoProfile": "main",
          "VideoLevel": "4.1",
          "VideoOptionExtra": "",
          "VideoQualityType": 1,
          "VideoQualitySlider": 25,
          "VideoQSVDecode": true,
          "VideoQSVAsyncDepth": 0,
          "VideoTwoPass": false,
          "VideoTurboTwoPass": false,
          "x264UseAdvancedOptions": false,
          "PresetDisabled": false,
          "MetadataPassthrough": true
        }
      ],
      "Folder": true,
      "PresetName": "BITLADDER",
      "PresetDescription": "Group of Roku Developer Bitladder Guidelines",
      "Type": 0
    }
  ],
  "VersionMajor": 47,
  "VersionMicro": 0,
  "VersionMinor": 0
}
```
The [PowerShell script "BitLadder.ps1"](https://github.com/thisguyshouldworkforus/MediaConversions/blob/master/bitladder.ps1) uses the new PowerShell 7+ `ForEach-Object -Parallel` which allows me to encdode all 8 Bitladder Steps at once.
It definitely hit my system like a freight train, but it handled it quite well:
![Windows Task Manager getting absolutely murdered](https://i.imgur.com/666yNnw.png)

In (*roughly*) 18 minutes, I had 8 versions of the same file!
![BitLadder Steps Output](https://i.imgur.com/AHNTZqG.png)

## FFMPEG
### Last Step
I got learned up on using FFMPEG, and learned about "Complex Filter Maps" and how I could "Map" the audio and video of my eight (8) input files into my single output file.  I wrote the automation for it with a loop, so the end command would be formatted properly:
```powershell
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
```
If I comment out the executable, this is the output I get, and which I would correctly expect / want:
```
ffmpeg.exe \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP1.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP2.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP3.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP4.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP5.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP6.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP7.mp4 \
-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP8.mp4 \
-filter_complex "[0:v][v0],[1:v][v1],[2:v][v2],[3:v][v3],[4:v][v4],[5:v][v5],[6:v][v6],[7:v][v7];[0:a][a0],[1:a][a1],[2:a][a2],[3:a][a3],[4:a][a4],[5:a][a5],[6:a][a6],[7:a][a7];[v0][v1][v2][v3][v4][v5][v6][v7][video];[a0][a1][a2][a3][a4][a5][a6][a7][audio]" \
-map [video][audio] \
-c:v h264 \
-c:a copy \
-f matroska \
"E:\MediaConversions\White.Boy.Rick.2018_MultiStreamTest_AAC.H264.mkv"
```
## Errors
- It doesn't work
  - Because of course it doesn't.
- Running the code above will generate this absolutely general and unhelpful error:

```error
Unrecognized option '-i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP1.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP2.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP3.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP4.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP5.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP6.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP7.mp4 -i White.Boy.Rick.2018.1080p.WEB-DL.H264.AC3-EVO_STEP8.mp4 -filter_complex [0:v][v0],[1:v][v1],[2:v][v2],[3:v][v3],[4:v][v4],[5:v][v5],[6:v][v6],[7:v][v7];[0:a][a0],[1:a][a1],[2:a][a2],[3:a][a3],[4:a][a4],[5:a][a5],[6:a][a6],[7:a][a7];[v0][v1][v2][v3][v4][v5][v6][v7][video];[a0][a1][a2][a3][a4][a5][a6][a7][audio] -map [video][audio] -c:v h264 -c:a copy'.
Error splitting the argument list: Option not found
```
What option?  What's wrong?  Cool, thanks -- good talk FFMPEG.

My journey continues.
