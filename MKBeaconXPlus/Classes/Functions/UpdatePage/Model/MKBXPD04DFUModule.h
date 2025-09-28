//
//  MKBXPD04DFUModule.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2025/9/22.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPD04DFUModule : NSObject

- (void)updateWithFileUrl:(NSString *)url
            progressBlock:(void (^)(CGFloat progress))progressBlock
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
