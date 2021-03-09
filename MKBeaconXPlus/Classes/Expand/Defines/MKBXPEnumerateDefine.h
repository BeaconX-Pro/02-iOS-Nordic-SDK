
/**
 Slot配置页面frameType
 */
typedef NS_ENUM(NSInteger, mk_bxp_slotFrameType) {
    mk_bxp_slotFrameTypeBeacon,
    mk_bxp_slotFrameTypeUID,
    mk_bxp_slotFrameTypeURL,
    mk_bxp_slotFrameTypeTLM,
    mk_bxp_slotFrameTypeNull,
    mk_bxp_slotFrameTypeInfo,
    mk_bxp_slotFrameTypeThreeASensor,
    mk_bxp_slotFrameTypeTHSensor,
};

/**
 Slot配置页面显示cell
 
 */
typedef NS_ENUM(NSInteger, mk_bxp_slotConfigCellType) {
    mk_bxp_beaconAdvContent,              //
    mk_bxp_uidAdvContent,
    mk_bxp_urlAdvContent,
    mk_bxp_deviceAdvContent,
    mk_bxp_axisAcceDataContent,
    mk_bxp_axisAcceParamsContent,
    mk_bxp_thDataContent,
    mk_bxp_triggerPramsContent,
    mk_bxp_baseParam,
};
