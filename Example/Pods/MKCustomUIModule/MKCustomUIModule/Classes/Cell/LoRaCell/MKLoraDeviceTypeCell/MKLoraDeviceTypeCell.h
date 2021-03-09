//
//  MKLoraDeviceTypeCell.h
//  MKLoraWANLib_Example
//
//  Created by aa on 2020/12/14.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_loraDeviceType) {
    mk_loraDeviceType_first,        //选中第一个button
    mk_loraDeviceType_second,       //选中第二个button
};

@interface MKLoraDeviceTypeCellModel : NSObject

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 第一个button的title
@property (nonatomic, copy)NSString *buttonTitle1;

/// 第二个button的title
@property (nonatomic, copy)NSString *buttonTitle2;

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 当前选中的button
@property (nonatomic, assign)mk_loraDeviceType type;

@end

@protocol MKLoraDeviceTypeCellDelegate <NSObject>

/// button点击回调事件
/// @param index 当前cell所在的index
/// @param deviceType 选中了哪个button
- (void)mk_loraDeviceTypeSelected:(NSInteger)index deviceType:(mk_loraDeviceType)deviceType;

@end

@interface MKLoraDeviceTypeCell : MKBaseCell

@property (nonatomic, strong)MKLoraDeviceTypeCellModel *dataModel;

@property (nonatomic, weak)id <MKLoraDeviceTypeCellDelegate>delegate;

+ (MKLoraDeviceTypeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
