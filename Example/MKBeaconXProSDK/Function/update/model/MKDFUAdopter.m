//
//  MKDFUAdopter.m
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDFUAdopter.h"
#import "MKDFUModel.h"
#import "MKFileManager.h"

@interface MKDFUAdopter()

@property (nonatomic, strong)dispatch_queue_t watchQueue;

@property (nonatomic, strong)dispatch_source_t watchSource;

@property (nonatomic, strong)MKDFUModel *dfuModel;

@end

@implementation MKDFUAdopter

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKDFUAdopter销毁");
}

#pragma mark - Public method

// 监听指定目录的文件改动
- (void)startMonitoringDirectory:(void (^)(void))dfuFileDatasChangedBlock
{
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *directoryURL = [NSURL URLWithString:directoryPath];
    // 创建 file descriptor (需要将NSString转换成C语言的字符串)
    // open() 函数会建立 file 与 file descriptor 之间的连接
    int filedes = open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (filedes < 0) {
        NSLog(@"Unable to open the path = %@", [directoryURL path]);
        return;
    }
    // 创建 dispatch queue, 当文件改变事件发生时会发送到该 queue
    self.watchQueue = dispatch_queue_create("ZFileMonitorQueue", 0);
    
    // 创建 GCD source. 将用于监听 file descriptor 来判断是否有文件写入操作
    self.watchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, filedes, DISPATCH_VNODE_WRITE, self.watchQueue);
    // 当文件发生改变时会调用该 block
    dispatch_source_set_event_handler(self.watchSource, ^{
        // 在文件发生改变时发出通知
        // 在子线程发送通知, 这个通知触发的方法会在子线程当中执行
        moko_dispatch_main_safe(^{
            if (dfuFileDatasChangedBlock) {
                dfuFileDatasChangedBlock();
            }
        });
    });
    
    // 当文件监听停止时会调用该 block
    dispatch_source_set_cancel_handler(self.watchSource, ^{
        // 关闭文件监听时, 关闭该 file descriptor
        close(filedes);
    });
    
    // 开始监听文件
    dispatch_resume(self.watchSource);
}

/**
 获取dfu数据，zip格式的
 
 @return @[]
 */
- (NSArray *)getDfuFilesList{
    NSArray *dufList = [MKFileManager getDocumentFiles];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *string in dufList) {
        if (string.length > 4) {
            NSString *lastString = [string substringWithRange:NSMakeRange(string.length - 4, 4)];
            if ([[lastString lowercaseString] isEqualToString:@".zip"]) {
                [list addObject:string];
            }
        }
    }
    return list;
}

/**
 根据名字来获取dfu文件路径
 
 @param fileName dfu文件名字
 @return 路径
 */
- (NSString *)getDfuFilePathWithFileName:(NSString *)fileName{
    if (!ValidStr(fileName)) {
        return @"";
    }
    return [[MKFileManager document] stringByAppendingPathComponent:fileName];
}

/**
 dfu升级
 
 @param fileName 选取的固件名字
 @param controller 当前控制器
 */
- (void)dfuUpdateWithFileName:(NSString *)fileName target:(UIViewController *)controller{
    if (!ValidStr(fileName)) {
        [controller.view showCentralToast:@"Select the firmware is invalid"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:controller.view isPenetration:NO];
    NSString *url = [self getDfuFilePathWithFileName:fileName];
    WS(weakSelf);
    [self.dfuModel dfuUpdateWithFileUrl:url progressBlock:^(CGFloat progress) {
        NSString *msg = [NSString stringWithFormat:@"%.1f%@",progress,@"%"];
        [[MKHudManager share] showHUDWithTitle:msg inView:controller.view isPenetration:NO];
    } sucBlock:^{
        [[MKHudManager share] showHUDWithTitle:@"DFU Successfully!" inView:controller.view isPenetration:NO];
        [weakSelf performSelector:@selector(updateComplete:) withObject:controller afterDelay:1.f];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] showHUDWithTitle:@"Opps!DFU Failed. Please try again!" inView:controller.view isPenetration:NO];
        [weakSelf performSelector:@selector(updateComplete:) withObject:controller afterDelay:1.f];
    }];
}

- (void)cancel{
    if (!self.watchSource) {
        return;
    }
    dispatch_cancel(self.watchSource);
}


#pragma mark -

- (void)updateComplete:(UIViewController *)vc{
    [[MKHudManager share] hide];
    [MKBXPCentralManager attempDealloc];
    [vc.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKCentralDeallocNotification" object:nil];
}

#pragma mark - setter & getter
- (MKDFUModel *)dfuModel {
    if (!_dfuModel) {
        _dfuModel = [[MKDFUModel alloc] init];
    }
    return _dfuModel;
}

@end
