//
//  MKAttributedString.h
//  MKHomePage
//
//  Created by aa on 2018/9/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKAttributedString : NSObject

+ (NSMutableAttributedString *)getAttributedString:(NSArray *)strings
                                             fonts:(NSArray *)fonts
                                            colors:(NSArray *)colors;

@end
