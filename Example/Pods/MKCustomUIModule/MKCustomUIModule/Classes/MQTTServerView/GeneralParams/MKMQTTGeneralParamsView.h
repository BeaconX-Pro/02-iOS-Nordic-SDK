//
//  MKMQTTGeneralParamsView.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMQTTGeneralParamsViewModel : NSObject

@property (nonatomic, assign)BOOL clean;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@end

@protocol MKMQTTGeneralParamsViewDelegate <NSObject>

- (void)mk_mqtt_generalParams_cleanSessionStatusChanged:(BOOL)isOn;

- (void)mk_mqtt_generalParams_qosChanged:(NSInteger)qos;

- (void)mk_mqtt_generalParams_KeepAliveChanged:(NSString *)keepAlive;

@end

@interface MKMQTTGeneralParamsView : UIView

@property (nonatomic, strong)MKMQTTGeneralParamsViewModel *dataModel;

@property (nonatomic, weak)id <MKMQTTGeneralParamsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
