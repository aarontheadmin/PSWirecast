# PSWirecast

PSWirecast offers a PowerShell interface for automating common actions in Wirecast:
* Start/stop live streaming with or without delays
* Start/stop recording
* Set active shot
* Export .wcst from template .wcst file
* Specify local or remote upstream URLs
* Get TCP connections of live streams (macOS)

## Requirements
### PSWirecast.json
The included PSWirecast.json file contains customizable paths and settings for the automation to work. It is recommended to place this file outside of the module folder, i.e. Documents folder.

### PSWirecast.config
The PSWirecast.config file lives in the module folder and contains the path to where the PSWirecast.json file is located; this must be updated.

### Wirecast .wcst Template
A __production-ready__ .wcst file needs to be created and fully functional; it is used as a template for all subsequent live stream events.

Currently, PSWirecast supports only the use of Master Layer 1 with 3 shots (more can exist but will not be automated unless added to the Shots object in PSWirecast.json). Shots can be suitably named in Wirecast but the names need to be specified in PSWirecast.json under STANDBY, PROGRAM, and END.

The 'template' .wcst file must contain 3 shots in Master Layer 1:

| Type | Purpose | Example |
| --- | --- | --- |
| STANDBY	| Pre-stream/standby | Live stream is pending, technical difficulties |
| PROGRAM | Program/live | Live stream in progress |
| END | Close/Offline | Live stream ending, credits, gratitude, etc. |

Note: PSWirecast only supports one RTMP URL for all live streams in a .wcst document, except for the destination file name. For example, the "https://stream.website.net/live" RTMP URL below would be used for all live streams in the .wcst document:

```
https://stream.website.net/live/high.mp4
https://stream.website.net/live/low.mp4
https://stream.website.net/live/audio-only.mp4
```

### XMLElementIndex
The XMLElementIndex references the correct element in the .wcst XML containing the path of the recording master file.

To find the index, open the completed .wcst template and locate the <advanced_output><advanced_output …> section. You should see an <output> element containing "Record To Disk …". The screenshot below shows the master file name is at index 6. It does not matter what the master file name is in the template .wcst document as it gets updated each time its exported).

![XML Element Index in .wcst](/assets/screenshots/xml_element_index.png "XML Element Index in .wcst")

## PSWirecast Setup

1. Download PSWirecast and place it in your modules folder.
2. In the module root, copy PSWirecast.json_default to Documents (or other suitable location) without "_default".
3. In the module root, copy the VirtualOperator folder to Documents (or other suitable location). This folder contains AppleScripts that interact between PowerShell and Wirecast.
   * Permissions may need to be set on the .scpt files but that is not covered here.
4. Configure PSWirecast.json
   * Under **Path**, specify the path to the VirtualOperator folder.
   * Under **Broadcast** > **UpstreamURL**, specify the Local and Remote URL to the upstream server (IP or DNS).
       * Local is used if streams are sent to a local upstream server.
       * Remote is used for streams sent to a remote upstream server.
   * Under **Broadcast** > **Layers** (Master Layer 1) > **Shots**, specify the Name of each shot to match the shot names in the template .wcst. Do not modify the "Type" values.
   * Under **Broadcast** > **WcstWorkingPath**, specify the full path to where the exported .wcst file should exist.
   
       Note: When the .wcst file is exported to this path, a pre-existing file with the same name will be overwritten.
   * Under **Broadcast** > **WcstTemplatePath**, specify the full path to the template .wcst file.
   * Under **Broadcast** > **MasterFile**, specify the path of where the live event should be recorded to (without a filename).
   
## Example
Export template to working file
```powershell
PS />Export-Wcst -TemplatePath /Users/streamer/Documents/LiveStreaming/MultitrackEventTemplate.wcst -Destination /Users/streamer/Desktop/MultitrackEvent.wcst
```
Update the working file using a master file name of V19-0529_Multitrack.mp4 and a Local UpstreamURL:
```powershell
PS />Update-Wcst -Path /Users/streamer/Desktop/MultitrackEvent.wcst -RecordToDiskPath /Users/streamer/Desktop/MultitrackMasters/V19-0529_Multitrack.mp4 -UpstreamURL Local -RecordToDiskXMLElementIndex 6
```
![XML Element Index Updated in .wcst](/assets/screenshots/xml_element_index_updated.png "XML Element Index Updated in .wcst")

Because the -UpstreamURL was set to Local in this example, all live streams were updated to the Local URL specified in PSWirecast.json. The XML element index for the Record-To-Disk path is 6 (0-5 correspond to the live streams), hence that is where the master file name is updated.

### Commands
Values are case-sensitive for -Name and -DocumentName parameters.

| Action | Command |
| --- | --- |
| Open Wirecast | Open-Wcst -Path /Users/streamer/Desktop/MultitrackEvent.wcst |
| Set Active Shot | Set-WcstShot -Name 'PROGRAM' -LayerName 'Master Layer 1' -DocumentName MultitrackEvent |
| Visual Countdown Timer | Invoke-Countdown -Seconds 30 |
| Start Live Streaming | Start-LiveStreaming -DocumentName MultitrackEvent -DelayInSeconds 30 |
| Stop Live Streaming | Stop-LiveStreaming -DocumentName MultitrackEvent -DelayInSeconds 30 |
| Start Recording | Start-WcstRecording -DocumentName MultitrackEvent |
| Stop Recording | Stop-WcstRecording -DocumentName MultitrackEvent |
| Get Wirecast TCP Connections (macOS only) | Get-LiveStreamingStatus |
| Entire PSWirecast Configuration (PSWirecast.json) | Get-PSWirecastConfiguration |
| Broadcast-related Settings (PSWirecast.json) | Get-BroadcastSetting |	