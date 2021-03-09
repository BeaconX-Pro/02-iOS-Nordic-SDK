//
//  MKMeasureTxPowerCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_deviceTxPower) {
    mk_deviceTxPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_deviceTxPowerNeg20dBm,   //-20dBm
    mk_deviceTxPowerNeg16dBm,   //-16dBm
    mk_deviceTxPowerNeg12dBm,   //-12dBm
    mk_deviceTxPowerNeg8dBm,    //-8dBm
    mk_deviceTxPowerNeg4dBm,    //-4dBm
    mk_deviceTxPower0dBm,       //0dBm
    mk_deviceTxPower3dBm,       //3dBm
    mk_deviceTxPower4dBm,       //4dBm
};

@interface MKMeasureTxPowerCellModel : NSObject

@property (nonatomic, assign)float measurePower;

@property (nonatomic, assign)mk_deviceTxPower txPower;

@end

@protocol MKMeasureTxPowerCellDelegate <NSObject>

- (void)mk_measureTxPowerCell_measurePowerValueChanged:(NSString *)measurePower;

- (void)mk_measureTxPowerCell_txPowerValueChanged:(mk_deviceTxPower)txPower;

@end

@interface MKMeasureTxPowerCell : MKBaseCell

@property (nonatomic, strong)MKMeasureTxPowerCellModel *dataModel;

@property (nonatomic, weak)id <MKMeasureTxPowerCellDelegate>delegate;

+ (MKMeasureTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
