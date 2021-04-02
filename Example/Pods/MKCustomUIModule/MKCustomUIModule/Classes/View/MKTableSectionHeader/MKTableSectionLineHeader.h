//
//  MKTableSectionLineHeader.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/4/2.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTableSectionLineHeaderModel : NSObject

@property (nonatomic, strong)UIColor *contentColor;

/// msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgTextFont;

/// msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgTextColor;

/// msg内容
@property (nonatomic, copy)NSString *text;

@end

@interface MKTableSectionLineHeader : UITableViewHeaderFooterView

@property (nonatomic, strong)MKTableSectionLineHeaderModel *headerModel;

+ (MKTableSectionLineHeader *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
