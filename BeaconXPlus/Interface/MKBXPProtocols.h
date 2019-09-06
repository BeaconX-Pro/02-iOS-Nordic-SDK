#import "MKBXPEnumeration.h"


@class MKBXPBaseBeacon;
@protocol MKBXPScanDelegate <NSObject>

- (void)bxp_didReceiveBeacon:(NSArray <MKBXPBaseBeacon *>*)beaconList;

@optional
- (void)bxp_centralManagerStartScan;
- (void)bxp_centralManagerStopScan;

@end

@protocol MKBXPCentralManagerDelegate <NSObject>

- (void)bxp_centralStateChanged:(MKBXPCentralManagerState)managerState;

- (void)bxp_peripheralConnectStateChanged:(MKBXPConnectStatus)connectState;

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState;

@end


@protocol MKBXPDeviceTimeProtocol <NSObject>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@protocol MKBXPHTStorageConditionsProtocol <NSObject>

@property (nonatomic, assign)HTStorageConditions condition;

/**
 HTStorageConditions != HTStorageConditionsTime,0~1000，Represent 0 ° C ~ 100 ° C
 */
@property (nonatomic, assign)NSInteger temperature;

/**
 HTStorageConditions != HTStorageConditionsTime,0~1000, Represent 0%~100%
 */
@property (nonatomic, assign)NSInteger humidity;

/**

 HTStorageConditions == HTStorageConditionsTime, In case, the range value is 1~255
 */
@property (nonatomic, assign)NSInteger time;

@end
