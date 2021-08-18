//
//  MKBXScanPageAdopter.m
//  MKBeaconXProTLA
//
//  Created by aa on 2021/8/12.
//

#import "MKBXScanPageAdopter.h"

#import "MKBXScanBeaconCell.h"
#import "MKBXScanHTCell.h"
#import "MKBXScanThreeASensorCell.h"
#import "MKBXScanTLMCell.h"
#import "MKBXScanUIDCell.h"
#import "MKBXScanURLCell.h"

@implementation MKBXScanPageAdopter

+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        MKBXScanUIDCell *cell = [MKBXScanUIDCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanURLCellModel.class]) {
        //URL
        MKBXScanURLCell *cell = [MKBXScanURLCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanTLMCellModel.class]){
        //TLM
        MKBXScanTLMCell *cell = [MKBXScanTLMCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCell *cell = [MKBXScanBeaconCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanHTCellModel.class]) {
        //HT
        MKBXScanHTCell *cell = [MKBXScanHTCell initCellWithTable:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanThreeASensorCellModel.class]) {
        //三轴
        MKBXScanThreeASensorCell *cell = [MKBXScanThreeASensorCell initCellWithTable:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXScanPageAdopterIdenty"];
}

+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        return 85.f;
    }
    if ([dataModel isKindOfClass:MKBXScanURLCellModel.class]) {
        //URL
        return 70.f;
    }
    if ([dataModel isKindOfClass:MKBXScanTLMCellModel.class]){
        //TLM
        return 110.f;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCellModel *model = (MKBXScanBeaconCellModel *)dataModel;
        return [MKBXScanBeaconCell getCellHeightWithUUID:model.uuid];
    }
    if ([dataModel isKindOfClass:MKBXScanHTCellModel.class]) {
        //HT
        return 105.f;
    }
    if ([dataModel isKindOfClass:MKBXScanThreeASensorCellModel.class]) {
        //三轴
        return 140.f;
    }
    return 0;
}

+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanUIDCellModel")]) {
        //UID
        return 0;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanURLCellModel")]) {
        //URL
        return 1;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanTLMCellModel")]) {
        //TLM
        return 2;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanBeaconCellModel")]) {
        //iBeacon
        return 3;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanThreeASensorCellModel")]) {
        //三轴
        return 4;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanHTCellModel")]) {
        //温湿度
        return 5;
    }
    return 6;
}

@end
