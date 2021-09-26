//
//  MKUpdateController.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/9/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKDFUProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKUpdateController : MKBaseViewController

@property (nonatomic, strong)id <MKDFUProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
