# corewlan
# Copyright Dominik Picheta. Licensed under MIT.
# A simple wrapper of the macOS CoreWLAN framework.
{.passL: "-framework CoreWLAN".}
{.passL: "-framework Foundation".}
const header = "<CoreWLAN/CoreWLAN.h>"

type
  NSString* {.importc, header: "<Foundation/NSString.h>".} = ptr object

# TODO: s/toCString/`$`/ causes odd corruption when used with echo.
proc toCString*(s: NSString): cstring
  {.importobjc: "UTF8String", header: "<Foundation/NSString.h>".}

type
  NSInteger* = clong
  NSUInteger* = NSInteger # Not quite, but there is no culong.

type
  NSSet* {.importc, header: "<Foundation/NSSet.h>".} = ptr object

  NSArray* {.importc, header: "<Foundation/NSArray.h>".} = ptr object

proc allObjects*(self: NSSet): NSArray
  {.importobjc.}

proc count*(self: NSArray): NSInteger {.importobjc.}
proc objectAtIndex*(self: NSArray, index: NSUInteger): pointer {.importobjc.}

iterator items*[T](t: typedesc[T], arr: NSArray): T =
  let count = arr.count()
  var i = 0
  while i < count:
    yield cast[T](arr.objectAtIndex(i))
    i.inc()

# CWChannel

type
  CWChannel* {.importc, header: header, final.} = ptr object

  CWChannelBand* = enum
    kCWChannelBandUnknown, kCWChannelBand2GHz, kCWChannelBand5GHz

  CWChannelWidth* = enum
    kCWChannelWidthUnknown, kCWChannelWidth20MHz, kCWChannelWidth40MHz,
    kCWChannelWidth80MHz, kCWChannelWidth120MHz

proc channelBand*(self: CWChannel): CWChannelBand {.importobjc, header: header.}
proc channelNumber*(self: CWChannel): NSInteger {.importobjc, header: header.}
proc channelWidth*(self: CWChannel): CWChannelWidth {.importobjc, header: header.}

# CWInterface

type
  CWInterface* {.importc, header: header,
                 final.} = ptr object

proc interfaceName*(self: CWInterface): NSString {.importobjc, header: header.}
proc ssid*(self: CWInterface): NSString {.importobjc, header: header.}
proc wlanChannel*(self: CWInterface): CWChannel {.importobjc, header: header.}
proc disassociate*(self: CWInterface) {.importobjc, header: header.}
proc supportedWLANChannels*(self: CWInterface): NSSet {.importobjc, header: header.}
proc setWLANChannel*(self: CWInterface, channel: CWChannel, error: pointer = nil)
  {.importobjc, header: header.}

# CWWifiClient

type
  CWWiFiClient* {.importc, header: header,
                 final.} = ptr object

proc sharedWiFiClient*(): CWWiFiClient
  {.importobjc: "CWWiFiClient sharedWiFiClient", header: header, nodecl.}

proc getInterface*(self: CWWiFiClient): CWInterface
  {.importobjc: "interface", header: header.}



