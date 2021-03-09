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

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseDataProtocol.h"
#import "MKBLEBaseLogManager.h"
#import "MKBLEBaseSDK.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

FOUNDATION_EXPORT double MKBaseBleModuleVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBaseBleModuleVersionString[];

