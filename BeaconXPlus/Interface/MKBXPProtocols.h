#import "MKBXPEnumeration.h"


@class MKBXPBaseBeacon;
@protocol MKBXPScanDelegate <NSObject>

- (void)bxp_didReceiveBeacon:(MKBXPBaseBeacon *)beacon;

@optional
- (void)bxp_centralManagerStartScan;
- (void)bxp_centralManagerStopScan;

@end

@protocol MKBXPCentralManagerDelegate <NSObject>

- (void)bxp_centralStateChanged:(MKBXPCentralManagerState)managerState;

- (void)bxp_peripheralConnectStateChanged:(MKBXPConnectStatus)connectState;

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState;

@end
