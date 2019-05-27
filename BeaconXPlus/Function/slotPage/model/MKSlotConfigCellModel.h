//
//  MKSlotConfigCellModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSlotConfigCellModel : NSObject

@property (nonatomic, assign)MKSlotConfigCellType cellType;

@property (nonatomic, strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
