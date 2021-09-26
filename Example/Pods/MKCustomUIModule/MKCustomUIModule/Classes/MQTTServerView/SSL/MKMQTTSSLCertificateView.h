//
//  MKMQTTSSLCertificateView.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMQTTSSLCertificateViewModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *fileName;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKMQTTSSLCertificateViewDelegate <NSObject>

- (void)mk_fileSelectedButtonPressed:(NSInteger)index;

@end

@interface MKMQTTSSLCertificateView : UIView

@property (nonatomic, strong)MKMQTTSSLCertificateViewModel *dataModel;

@property (nonatomic, weak)id <MKMQTTSSLCertificateViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
