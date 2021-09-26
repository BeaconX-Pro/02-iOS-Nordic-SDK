//
//  MKBXPLightSensorButtonView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPLightSensorButtonViewModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIImage *icon;

@end

@interface MKBXPLightSensorButtonView : UIControl

@property (nonatomic, strong)MKBXPLightSensorButtonViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
