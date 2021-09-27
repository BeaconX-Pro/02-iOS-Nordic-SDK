
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@protocol MKBXScanInfoCellProtocol <NSObject>

@property (nonatomic, strong)CBPeripheral *peripheral;

/// 设备广播名称
@property (nonatomic, copy)NSString *deviceName;

/// 设备可连接状态
@property (nonatomic, assign)BOOL connectable;

/**
 信号值强度,会动态变化，TLM、iBeacon、UID、URL、info都会改变这个值
 */
@property (nonatomic, copy)NSString *rssi;

/// 用于记录本次扫到该设备距离上次扫到该设备的时间差，单位ms.
@property (nonatomic, copy)NSString *displayTime;

/// Whether the device has light sensor.
@property (nonatomic, assign)BOOL lightSensor;

/// lightSensor must be YES.
@property (nonatomic, assign)BOOL lightSensorStatus;

//dBm,当lightSensor=YES，则显示lightSensorStatus，当lightSensor=NO才会显示rangingData
@property (nonatomic, copy)NSString *rangingData;

@property (nonatomic, copy)NSString *txPower;
//Battery Voltage
@property (nonatomic, copy) NSString *battery;

@property (nonatomic, copy) NSString *macAddress;

@end


@protocol MKBXScanInfoCellDelegate <NSObject>

- (void)mk_bx_connectPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
