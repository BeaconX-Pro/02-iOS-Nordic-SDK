//
//  MKBXPTaskOperation.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPTaskOperation.h"
#import "MKBXPDefines.h"
#import "MKBXPDataParser.h"
#import "MKBXPAdopter.h"

NSString *const MKBXPAdditionalInformation = @"MKBXPAdditionalInformation";
NSString *const MKBXPDataInformation = @"MKBXPDataInformation";
NSString *const MKBXPDataStatusLev = @"MKBXPDataStatusLev";

@interface MKBXPTaskOperation ()

/**
 对于需要先接收到总的数据条数才能确定本次通信成功所需要的数据总条数的任务，先开启条数接受定时器，如果没有接收到总条数，则直接超时
 */
@property (nonatomic, strong)dispatch_source_t numTaskTimer;

/**
 超过2s没有接收到新的数据，超时
 */
@property (nonatomic, strong)dispatch_source_t receiveTimer;

/**
 线程ID
 */
@property (nonatomic, assign)MKBXPOperationID operationID;

/**
 总的数据条数
 */
@property (nonatomic, assign)NSInteger respondNumber;

/**
 线程结束时候的回调
 */
@property (nonatomic, copy)void (^completeBlock)(NSError *error, MKBXPOperationID operationID, id returnData);

@property (nonatomic, copy)void (^commandBlock)(void);

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 超时标志
 */
@property (nonatomic, assign)BOOL timeout;

/**
 接受数据超时个数
 */
@property (nonatomic, assign)NSInteger receiveTimerCount;

/**
 是否需要改变目标数据条数
 */
@property (nonatomic, assign)BOOL needResetNum;

/**
 需要从外部设备获取条数信息等附加信息的时候，需要把这些附加信息也返回
 */
@property (nonatomic, strong)NSDictionary *additionalInformation;

/**
 对于需要拿个数的任务，如果已经接受了个数，则应该关闭接受新的个数
 */
@property (nonatomic, assign)BOOL hasReceive;

/**
 由于业务罗需要，对于计步、睡眠、心率数据，如果超时的时候接收到了部分数据，也认为是接受成功
 */
@property (nonatomic, assign)BOOL needPartOfData;

@end

@implementation MKBXPTaskOperation
@synthesize executing = _executing;
@synthesize finished = _finished;


#pragma mark - life circle

- (void)dealloc{
    NSLog(@"任务销毁");
}

- (instancetype)initOperationWithID:(MKBXPOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, MKBXPOperationID operationID, id returnData))completeBlock{
    if (self = [super init]) {
        _executing = NO;
        _finished = NO;
        _completeBlock = nil;
        _completeBlock = completeBlock;
        _commandBlock = nil;
        _commandBlock = commandBlock;
        _operationID = operationID;
        _respondNumber = 1;
        _needResetNum = resetNum;
    }
    return self;
}

#pragma mark - super method
- (void)main{
    @try {
        @autoreleasepool{
            [self startCommunication];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        
    }
}

- (void)start{
    if (self.isFinished || self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self parseDataSuccess:[MKBXPDataParser parseReadDataFromCharacteristic:characteristic]];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self parseDataSuccess:[MKBXPDataParser parseWriteDataFromCharacteristic:characteristic]];
}

#pragma mark - Private method
- (void)startCommunication{
    if (self.isCancelled) {
        return;
    }
    if (self.commandBlock) {
        self.commandBlock();
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __weak __typeof(&*self)weakSelf = self;
    //需要从外设拿当前通信的总条数
    if (self.needResetNum) {
        self.numTaskTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.numTaskTimer,dispatch_walltime(NULL, 0),1.f * NSEC_PER_SEC, 0); //每秒执行
        __block NSUInteger interval = 2;
        dispatch_source_set_event_handler(self.numTaskTimer, ^{
            if (weakSelf.timeout || interval <= 0) {
                [weakSelf communicationTimeout];
                return ;
            }
            interval --;
        });
        //如果需要从外设拿总条数，则在拿到总条数之后，开启接受超时定时器
        dispatch_resume(self.numTaskTimer);
        return;
    }
    //如果不需要重新获取条数，直接开启接受超时
    [self startReceiveTimer];
}

/**
 如果需要从外设拿总条数，则在拿到总条数之后，开启接受超时定时器，开启定时器的时候已经设置了当前线程的生命周期，所以不需要重新beforeDate了。如果是直接开启的接收超时定时器，这个时候需要控制当前线程的生命周期
 
 */
- (void)startReceiveTimer{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.receiveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(self.receiveTimer, dispatch_walltime(NULL, 0), 0.2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.receiveTimer, ^{
        if (weakSelf.timeout || weakSelf.receiveTimerCount >= 10) {
            //接受数据超时
            weakSelf.receiveTimerCount = 0;
            [weakSelf communicationTimeout];
            return ;
        }
        weakSelf.receiveTimerCount ++;
    });
    if (self.isCancelled) {
        return;
    }
    //如果需要从外设拿总条数，则在拿到总条数之后，开启接受超时定时器
    dispatch_resume(self.receiveTimer);
}

- (void)finishOperation{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)communicationTimeout{
    self.timeout = YES;
    if (self.numTaskTimer) {
        dispatch_cancel(self.numTaskTimer);
    }
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    [self finishOperation];
    if (self.completeBlock) {
        if (self.needPartOfData) {
            //由于业务罗需要，对于计步、睡眠、心率数据，如果超时的时候接收到了部分数据，也认为是接受成功
            NSDictionary *resultDic = @{
                                        MKBXPAdditionalInformation:(self.additionalInformation ?: @{}),
                                        MKBXPDataInformation:self.dataList,
                                        //对于有附加信息的，lev为2，对于普通不包含附加信息的，lev为1.
                                        MKBXPDataStatusLev:(self.additionalInformation ? @"2" : @"1"),
                                        };
            if (self.completeBlock) {
                self.completeBlock(nil, self.operationID, resultDic);
            }
            return;
        }
        NSError *error = [MKBXPAdopter getErrorWithCode:MKCommunicationTimeout message:@"Communication timeout"];
        self.completeBlock(error, self.operationID, nil);
    }
}

- (void)communicationSuccess{
    if (self.numTaskTimer) {
        dispatch_cancel(self.numTaskTimer);
    }
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    [self finishOperation];
    //接受数据成功
    NSDictionary *resultDic = @{
                                MKBXPAdditionalInformation:(self.additionalInformation ?: @{}),
                                MKBXPDataInformation:self.dataList,
                                //对于有附加信息的，lev为2，对于普通不包含附加信息的，lev为1.
                                MKBXPDataStatusLev:(self.additionalInformation ? @"2" : @"1"),
                                };
    if (self.completeBlock) {
        self.completeBlock(nil, self.operationID, resultDic);
    }
}

- (void)setRespondCount:(NSString *)respondNumber{
    if (!MKValidStr(respondNumber)) {
        return;
    }
    _respondNumber = [respondNumber integerValue];
}

- (void)needPartOfData:(NSNumber *)need{
    _needPartOfData = [need boolValue];
}

- (void)parseDataSuccess:(NSDictionary *)dataDic{
    if (!dataDic || self.isCancelled || !_executing || self.timeout) {
        return;
    }
    MKBXPOperationID operationID = [dataDic[@"operationID"] integerValue];
    if (operationID == MKBXPOperationDefaultID || operationID != self.operationID) {
        return;
    }
    NSDictionary *returnData = dataDic[@"returnData"];
    if (!returnData) {
        return;
    }
    NSString *numString = returnData[MKBXPDataNum];
    if (MKValidStr(numString)) {
        //本条数据是总数信息
        if (!self.needResetNum || self.hasReceive) {
            return;
        }
        //如果需要拿总条数，则总条数必须在正式的数据到来之前到达，否则认为出错
        if (self.dataList.count != 0) {
            //接受数据异常
            return;
        }
        //认为接受数据总条数成功
        self.respondNumber = [numString integerValue];
        self.additionalInformation = returnData;
        //已经接受了个数信息，再有新的个数信息到来，直接过滤
        self.hasReceive = YES;
        if (self.respondNumber == 0) {
            //如果没有数据，则直接认为通信成功
            [self communicationSuccess];
            return;
        }
        if (self.numTaskTimer) {
            //关闭总数接受定时器
            dispatch_cancel(self.numTaskTimer);
        }
        //开启接受超时定时器
        [self startReceiveTimer];
        return;
    }
    if (self.needResetNum && !self.hasReceive) {
        //需要从外设拿数据总条数的情况下，如果数据先于数据到来，不接收
        return;
    }
    self.receiveTimerCount = 0;
    if (self.timeout) {
        return;
    }
    [self.dataList addObject:returnData];
    if (self.dataList.count == self.respondNumber) {
        [self communicationSuccess];
    }
}

#pragma mark - setter & getter
- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isFinished{
    return _finished;
}

- (BOOL)isExecuting{
    return _executing;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
