/*
 头文件说明：
 1、所有app里定义的枚举类型
 */


/**
 Slot配置页面frameType
 */
typedef NS_ENUM(NSInteger, slotFrameType) {
    slotFrameTypeiBeacon,
    slotFrameTypeUID,
    slotFrameTypeURL,
    slotFrameTypeTLM,
    slotFrameTypeNull,
    slotFrameTypeInfo,
    slotFrameTypeThreeASensor,
    slotFrameTypeTHSensor,
};

/**
 Slot配置页面显示cell
 
 */
typedef NS_ENUM(NSInteger, MKSlotConfigCellType) {
    iBeaconAdvContent,              //
    uidAdvContent,
    urlAdvContent,
    baseParam,
};
