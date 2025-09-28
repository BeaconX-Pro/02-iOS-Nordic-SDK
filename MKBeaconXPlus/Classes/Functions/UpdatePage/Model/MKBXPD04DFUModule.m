//
//  MKBXPD04DFUModule.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2025/9/22.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPD04DFUModule.h"

#import "MKMacroDefines.h"

#import "MKBXPCentralManager.h"

@import iOSDFULibrary;

static NSString *const dfuUpdateDomain = @"com.moko.dfuUpdateDomain";

@interface MKBXPD04DFUModule()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate>

@property (nonatomic, copy)void (^progressBlock)(CGFloat progress);

@property (nonatomic, copy)void (^updateSucBlock)(void);

@property (nonatomic, copy)void (^updateFailedBlock)(NSError *error);

@property (nonatomic, strong)DFUServiceController *dfuController;

@property (nonatomic, strong)CBPeripheral *periheral;

@end

@implementation MKBXPD04DFUModule

- (void)dealloc{
    NSLog(@"MKBXPD04DFUModule销毁");
}

#pragma mark - DFUServiceDelegate

- (void)updateWithFileUrl:(NSString *)url
            progressBlock:(void (^)(CGFloat progress))progressBlock
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!ValidStr(url)) {
        [self operationFailedBlock:failedBlock msg:@"The url is invalid!"];
        return;
    }
    NSData *zipData = [NSData dataWithContentsOfFile:url];
    if (!ValidData(zipData)) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    NSError *error = nil;
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithZipFile:zipData error:&error];// or
    //Use the DFUServiceInitializer to initialize the DFU process.
    if (!selectedFirmware) {
        [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        return;
    }
    self.periheral = [MKBXPCentralManager shared].peripheral;
    //先断开连接
    [[MKBXPCentralManager shared] disconnect];
    // 等待短暂时间后重新连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MKBXPCentralManager shared] dfuconnectPeripheral:self.periheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
            self.progressBlock = nil;
            self.progressBlock = progressBlock;
            self.updateSucBlock = nil;
            self.updateSucBlock = sucBlock;
            self.updateFailedBlock = nil;
            self.updateFailedBlock = failedBlock;
            [self startDFUProcess:selectedFirmware];
        } failedBlock:^(NSError * _Nonnull error) {
            [self operationFailedBlock:failedBlock msg:@"Dfu upgrade failure!"];
        }];
    });
    
    
}

- (void)dfuStateDidChangeTo:(enum DFUState)state{
    //升级完成
    if (state==DFUStateCompleted) {
        moko_dispatch_main_safe(^{
            if (self.updateSucBlock) {
                self.updateSucBlock();
            }
        });
    }
    if (state == DFUStateUploading) {
        [MKBXPCentralManager sharedDealloc];
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    [self operationFailedBlock:self.updateFailedBlock msg:message];
}

#pragma mark - Private method
- (void)startDFUProcess:(DFUFirmware *)selectedFirmware {
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) progressQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) loggerQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                          centralManagerOptions:@{}];
    initiator = [initiator withFirmware:selectedFirmware];
    initiator.logger = self; // - to get log info
    initiator.delegate = self; // - to be informed about current state and errors
    initiator.progressDelegate = self; // - to show progress bar
    
    self.dfuController = [initiator startWithTarget:[MKBXPCentralManager shared].peripheral];
}

#pragma mark - DFUProgressDelegate
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    float currentProgress = (float) progress /totalParts;
    moko_dispatch_main_safe(^{
        if (self.progressBlock) {
            self.progressBlock(currentProgress);
        }
    });
}

#pragma mark - LoggerDelegate
- (void)logWith:(enum LogLevel)level message:(NSString *)message{
    NSLog(@"%logWith ld: %@", (long) level, message);
}

#pragma mark -

- (void)operationFailedBlock:(void (^)(NSError *error))failedBlock msg:(NSString *)msg {
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:dfuUpdateDomain
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            failedBlock(error);
        }
    });
}

@end
