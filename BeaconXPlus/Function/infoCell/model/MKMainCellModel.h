//
//  MKMainCellModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMainCellModel : NSObject

//左侧icon图片
@property (nonatomic, copy)NSString *leftIconName;
//左侧标题
@property (nonatomic, copy)NSString *leftMsg;
//右侧标题
@property (nonatomic, copy)NSString *rightMsg;
//右侧icon图片，如果不设置则显示右向箭头
@property (nonatomic, copy)NSString *rightIconName;
//是否可点击
//@property (nonatomic, assign)BOOL clickEnable;
//是否隐藏右侧图标，如果设置成YES(不显示右侧图标)，则rightIconName设置无效
@property (nonatomic, assign)BOOL hiddenRightIcon;
//cell被选中时候绑定的控制器类
@property (nonatomic, assign)Class destVC;
//右侧开关是否打开
@property (nonatomic, assign)BOOL isOn;

@end

NS_ASSUME_NONNULL_END
