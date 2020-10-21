//
//  NSObject+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MKAdd)

- (void)autoEncodeWithCoder: (NSCoder *)coder;
- (void)autoDecode:(NSCoder *)coder;
- (NSDictionary *)properties;

@end
