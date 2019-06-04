typedef NS_ENUM(NSInteger, MKBXPOperationID) {
    MKBXPOperationDefaultID,
    MKBXPReadVendorOperation,                     //读取厂商信息
    MKBXPReadModeIDOperation,                     //读取产品型号信息
    MKBXPReadProductionDateOperation,             //读取生产日期
    MKBXPReadHardwareOperation,                   //读取硬件信息
    MKBXPReadFirmwareOperation,                   //读取固件信息
    MKBXPReadSoftwareOperation,                   //读取软件版本
    MKBXPReadCapabilitiesOperation,               //获取capabilities数据
    MKBXPReadActiveSlotOperation,                 //获取activeSlot数据
    MKBXPReadAdvertisingIntervalOperation,        //获取广播间隔
    MKBXPReadRadioTxPowerOperation,               //获取发射功率
    MKBXPReadAdvTxPowerOperation,                 //获取广播功率
    MKBXPReadLockStateOperation,                  //获取eddystone的lock状态
    MKBXPReadUnlockOperation,
    MKBXPReadPublicECDHKeyOperation,
    MKBXPReadEidIdentityKeyOperation,
    MKBXPReadAdvSlotDataOperation,
    MKBXPSetActiveSlotOperation,                 //设置activeSlot数据
    MKBXPSetAdvertisingIntervalOperation,        //设置广播间隔
    MKBXPSetRadioTxPowerOperation,               //设置发射功率
    MKBXPSetAdvTxPowerOperation,                 //设置广播功率
    MKBXPSetLockStateOperation,                  //设置eddystone的lock状态
    MKBXPSetUnlockOperation,
    MKBXPSetPublicECDHKeyOperation,
    MKBXPSetEidIdentityKeyOperation,
    MKBXPSetAdvSlotDataOperation,
    MKBXPSetFactoryResetOperation,
    MKBXPReadMacAddressOperation,                   //获取eddystone的mac地址
    MKBXPReadSlotTypeOperation,                     //获取eddystone的通道类型
    MKBXPReadConnectEnableOperation,                //获取eddystone的可连接状态
    MKBXPSetConnectEnableOperation,              //设置eddystone的可连接状态
    MKBXPSetPowerOffOperation,                    //关机命令
    MKBXPReadBatteryOperation,                      //读取battery
    MKBXPReadDeviceTypeOperation,               //读取设备类型
    MKBXPReadThreeAxisParamsOperation,          //读取三轴传感器参数
    MKBXPSetThreeAxisParamsOperation,           //设置三轴传感器参数
    MKBXPReadHTSamplingRateOperation,           //读取温湿度采样率
    MKBXPSetHTSamplingRateOperation,           //设置温湿度采样率
    MKBXPReadHTStorageConditionsOperation,      //读取温湿度存储条件
    MKBXPSetHTStorageConditionsOperation,       //设置温湿度存储条件
    MKBXPReadDeviceTimeOperation,               //读取设备当前时间
    MKBXPSetDeviceTimeOperation,                //设置设备当前时间
    MKBXPReadTriggerConditionsOperation,        //读取触发条件
    MKBXPSetTriggerConditionsOperation,         //设置触发条件
    MKBXPDeleteRecordHTDataOperation,           //删除已存储的温湿度数据
};
