//
//  MKSlotConfigCellModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKSlotBaseCell;
@interface MKSlotConfigCellModel : NSObject

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, strong)MKSlotBaseCell *cell;

@end

NS_ASSUME_NONNULL_END
