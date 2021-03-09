#pragma mark - 字符串、字典、数组等类的验证宏定义
//*************************************字符串、字典、数组等类的验证宏定义******************************************************

#define Str(s) ([s isKindOfClass:[NSNull class]] || s==nil || ![s isKindOfClass:[NSString class]] || [s isEqualToString:@"(null)"] || [s isEqualToString:@"null"] || [s isEqualToString:@"<null>"] ? @"" : s)
#define StrDate(s)          (s==nil ? [NSDate date] : s)
#define StrNull(f)          (f==nil || ![f isKindOfClass:[NSString class]] || ([f isKindOfClass:[NSString class]] && [f isEqualToString:@""]))
#define StrValid(f)         (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f)          (StrValid(Str(f)) ? f:@"")
#define HasString(str,key)  ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f)         StrValid(f)
#define ValidDict(f)        (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define ValidArray(f)       (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f)         (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls)   (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f)        (f!=nil && [f isKindOfClass:[NSData class]])



