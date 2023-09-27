
typedef NS_ENUM(NSInteger, mk_bxp_taskOperationID) {
    mk_bxp_defaultTaskOperationID,
    
    mk_bxp_taskReadVendorOperation,                     //读取厂商信息
    mk_bxp_taskReadModeIDOperation,                     //读取产品型号信息
    mk_bxp_taskReadProductionDateOperation,             //读取生产日期
    mk_bxp_taskReadHardwareOperation,                   //读取硬件信息
    mk_bxp_taskReadFirmwareOperation,                   //读取固件信息
    mk_bxp_taskReadSoftwareOperation,                   //读取软件版本
    
    mk_bxp_taskReadCapabilitiesOperation,               //获取capabilities数据
    mk_bxp_taskReadActiveSlotOperation,                 //获取activeSlot数据
    mk_bxp_taskReadAdvertisingIntervalOperation,        //获取广播间隔
    mk_bxp_taskReadRadioTxPowerOperation,               //获取发射功率
    mk_bxp_taskReadAdvTxPowerOperation,                 //获取广播功率
    mk_bxp_taskReadLockStateOperation,                  //获取eddystone的lock状态
    mk_bxp_taskReadUnlockOperation,
    mk_bxp_taskReadPublicECDHKeyOperation,
    mk_bxp_taskReadEidIdentityKeyOperation,
    mk_bxp_taskReadAdvSlotDataOperation,
    mk_bxp_taskConfigActiveSlotOperation,                 //设置activeSlot数据
    mk_bxp_taskConfigAdvertisingIntervalOperation,        //设置广播间隔
    mk_bxp_taskConfigRadioTxPowerOperation,               //设置发射功率
    mk_bxp_taskConfigAdvTxPowerOperation,                 //设置广播功率
    mk_bxp_taskConfigLockStateOperation,                  //设置eddystone的lock状态
    mk_bxp_taskConfigUnlockOperation,
    mk_bxp_taskConfigPublicECDHKeyOperation,
    mk_bxp_taskConfigEidIdentityKeyOperation,
    mk_bxp_taskConfigAdvSlotDataOperation,
    mk_bxp_taskConfigFactoryResetOperation,
    mk_bxp_taskReadMacAddressOperation,                   //获取eddystone的mac地址
    mk_bxp_taskReadSlotTypeOperation,                     //获取eddystone的通道类型
    mk_bxp_taskReadConnectEnableOperation,                //获取eddystone的可连接状态
    mk_bxp_taskConfigConnectEnableOperation,              //设置eddystone的可连接状态
    mk_bxp_taskConfigPowerOffOperation,                    //关机命令
    mk_bxp_taskReadBatteryOperation,                      //读取battery
    mk_bxp_taskReadDeviceTypeOperation,               //读取设备类型
    mk_bxp_taskReadThreeAxisParamsOperation,          //读取三轴传感器参数
    mk_bxp_taskConfigThreeAxisParamsOperation,           //设置三轴传感器参数
    mk_bxp_taskReadHTSamplingRateOperation,           //读取温湿度采样率
    mk_bxp_taskConfigHTSamplingRateOperation,           //设置温湿度采样率
    mk_bxp_taskReadHTStorageConditionsOperation,      //读取温湿度存储条件
    mk_bxp_taskConfigHTStorageConditionsOperation,       //设置温湿度存储条件
    mk_bxp_taskReadDeviceTimeOperation,               //读取设备当前时间
    mk_bxp_taskConfigDeviceTimeOperation,                //设置设备当前时间
    mk_bxp_taskReadTriggerConditionsOperation,        //读取触发条件
    mk_bxp_taskConfigTriggerConditionsOperation,         //设置触发条件
    mk_bxp_taskReadButtonPowerStatusOperation,      //读取按键关机状态
    mk_bxp_taskConfigButtonPowerStatusOperation,    //设置按键关机状态
    
    mk_bxp_taskDeleteRecordHTDataOperation,           //删除已存储的温湿度数据
    
    mk_bxp_taskReadLightSensorStatusOperation,          //读取光感状态
    mk_bxp_taskDeleteRecordLightSensorDataOperation,    //删除已存储的光感数据
    
    mk_bxp_taskReadLEDTriggerStatusOperation,           //读取LED触发提醒状态
    mk_bxp_taskConfigLEDTriggerStatusOperation,         //设置LED触发提醒状态
    mk_bxp_taskReadResetBeaconByButtonStatusOperation,  //读取设备是否可以按键开关机
    mk_bxp_taskConfigResetBeaconByButtonStatusOperation,    //设置设备是否可以按键开关机
    mk_bxp_taskReadHundredHistoryDataOperation,             //读取100条历史数据
    mk_bxp_taskReadEffectiveClickIntervalOperation,         //读取按键间隔时长
    mk_bxp_taskConfigEffectiveClickIntervalOperation,       //设置按键间隔时长
    mk_bxp_taskReadTimeStampOperation,                      //读取当前BXP-CL-a设备的时间戳
    mk_bxp_taskConfigTimeStampOperation,                    //设置当前BXP-CL-a设备的时间戳
};
