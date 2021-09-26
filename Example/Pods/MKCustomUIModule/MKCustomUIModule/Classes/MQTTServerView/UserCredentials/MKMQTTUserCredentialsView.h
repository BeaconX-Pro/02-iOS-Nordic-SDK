//
//  MKMQTTUserCredentialsView.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMQTTUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKMQTTUserCredentialsViewDelegate <NSObject>

- (void)mk_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)mk_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKMQTTUserCredentialsView : UIView

@property (nonatomic, strong)MKMQTTUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKMQTTUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
