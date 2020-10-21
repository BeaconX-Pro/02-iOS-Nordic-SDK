//
//  NSDateFormatter+MKAdd.h
//  mokoLibrary
//
//  Created by aa on 2020/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (MKAdd)

+ (NSDateFormatter *)dateFormatter;

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat;

+ (NSDateFormatter *)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end

NS_ASSUME_NONNULL_END
