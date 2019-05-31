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
 HTStorageConditions != HTStorageConditionsTime,当前值会被缩小10倍之后设置给设备,0~1000
 */
@property (nonatomic, assign)NSInteger temperature;

/**
 HTStorageConditions != HTStorageConditionsTime,0~100
 */
@property (nonatomic, assign)NSInteger humidity;

/**

 HTStorageConditions == HTStorageConditionsTime, 情况下，范围值为1~255,
 */
@property (nonatomic, assign)NSInteger time;

@end
