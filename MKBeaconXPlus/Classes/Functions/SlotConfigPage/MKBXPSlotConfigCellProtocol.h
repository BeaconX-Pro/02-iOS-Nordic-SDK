
#import <Foundation/Foundation.h>

static NSString *const bxp_slotConfig_advContentType = @"00";
static NSString *const bxp_slotConfig_advParamType = @"01";
static NSString *const bxp_slotConfig_advTriggerType = @"02";

static NSString *const bxp_slotConfig_beaconData = @"beaconKey";
static NSString *const bxp_slotConfig_infoData = @"infoKey";
static NSString *const bxp_slotConfig_uidData = @"uidKey";
static NSString *const bxp_slotConfig_urlData = @"urlKey";

@protocol MKBXPSlotConfigCellProtocol <NSObject>

- (NSDictionary *)bxp_slotConfigCell_paramValue;

@end
