import strformat

import corewlan

let wfc = sharedWiFiClient()

echo wfc.repr

let wif = wfc.getInterface()
echo toCString(wif.interfaceName)
echo toCString(wif.ssid)
echo wif.wlanChannel.channelNumber

let channels = wif.supportedWLANChannels
echo(channels.allObjects().count())
for channel in items(CWChannel, channels.allObjects):
  echo fmt"{channel.channelNumber}, - {channel.channelBand} - {channel.channelWidth}"

echo("Let's attempt to disassociate")

wif.disassociate()