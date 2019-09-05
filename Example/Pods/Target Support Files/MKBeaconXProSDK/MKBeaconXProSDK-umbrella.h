#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CBPeripheral+MKAdd.h"
#import "MKBXPAdopter.h"
#import "MKBXPBaseBeacon.h"
#import "MKBXPCentralManager.h"
#import "MKBXPDataParser.h"
#import "MKBXPDefines.h"
#import "MKBXPEnumeration.h"
#import "MKBXPInterface+MKConfig.h"
#import "MKBXPInterface.h"
#import "MKBXPNormalDefines.h"
#import "MKBXPOperationIDDefines.h"
#import "MKBXPProtocols.h"
#import "MKBXPSDKHeader.h"
#import "MKBXPService.h"
#import "MKBXPTaskOperation.h"

FOUNDATION_EXPORT double MKBeaconXProSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXProSDKVersionString[];

