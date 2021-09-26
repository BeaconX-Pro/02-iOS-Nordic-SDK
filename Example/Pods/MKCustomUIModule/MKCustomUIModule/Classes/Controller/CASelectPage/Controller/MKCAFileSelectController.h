//
//  MKCAFileSelectController.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_certListPageType) {
    mk_caCertSelPage,
    mk_clientKeySelPage,
    mk_clientCertSelPage,
    mk_clientP12CertPage,
};

@protocol MKCAFileSelectControllerDelegate <NSObject>

- (void)mk_certSelectedMethod:(mk_certListPageType)certType certName:(NSString *)certName;

@end

@interface MKCAFileSelectController : MKBaseViewController

@property (nonatomic, weak)id <MKCAFileSelectControllerDelegate>delegate;

@property (nonatomic, assign)mk_certListPageType pageType;

@end

NS_ASSUME_NONNULL_END
