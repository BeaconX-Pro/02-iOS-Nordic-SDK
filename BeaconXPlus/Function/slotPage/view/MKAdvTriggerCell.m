//
//  MKAdvTriggerCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/28.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvTriggerCell.h"

@interface MKAdvTriggerCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

//@property (nonatomic, strong)

@end

@implementation MKAdvTriggerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

@end
