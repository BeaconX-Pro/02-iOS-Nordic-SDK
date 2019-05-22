
/**
 广播帧类型
 
 - MKBXPUIDFrameType: UID
 - MKBXPURLFrameType: URL
 - MKBXPTLMFrameType: TLM
 - MKBXPDeviceInfoFrameType: 设备信息帧
 - MKBXPBeaconFrameType: iBeacon信息帧
 - MKBXPThreeASensorFrameType: 3轴加速度传感器信息帧
 - MKBXPTHSensorFrameType: 温湿度传感器信息帧
 - MKBXPCustomFrameType: 自定义广播信息帧
 - MKBXPUnkonwFrameType:未知信息帧
 */
typedef NS_ENUM(NSInteger, MKBXPDataFrameType) {
    MKBXPUIDFrameType,
    MKBXPURLFrameType,
    MKBXPTLMFrameType,
    MKBXPDeviceInfoFrameType,
    MKBXPBeaconFrameType,
    MKBXPThreeASensorFrameType,
    MKBXPTHSensorFrameType,
    MKBXPCustomFrameType,
    MKBXPUnknownFrameType,
};

typedef NS_ENUM(NSInteger, MKBXPConnectStatus) {
    MKBXPConnectStatusUnknow,
    MKBXPConnectStatusConnecting,
    MKBXPConnectStatusConnected,
    MKBXPConnectStatusConnectedFailed,
    MKBXPConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, MKBXPCentralManagerState) {
    MKBXPCentralManagerStateUnable,
    MKBXPCentralManagerStateEnable,
};

typedef NS_ENUM(NSInteger, MKBXPLockState) {
    MKBXPLockStateUnknow,
    MKBXPLockStateLock,
    MKBXPLockStateOpen,
    MKBXPLockStateUnlockAutoMaticRelockDisabled,
};
