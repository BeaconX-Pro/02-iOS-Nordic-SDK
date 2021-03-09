//
//  MKClassInfo.h
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2020/12/30.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, MKEncodingType) {
    MKEncodingTypeMask       = 0xFF, ///< mask of type value
    MKEncodingTypeUnknown    = 0, ///< unknown
    MKEncodingTypeVoid       = 1, ///< void
    MKEncodingTypeBool       = 2, ///< bool
    MKEncodingTypeInt8       = 3, ///< char / BOOL
    MKEncodingTypeUInt8      = 4, ///< unsigned char
    MKEncodingTypeInt16      = 5, ///< short
    MKEncodingTypeUInt16     = 6, ///< unsigned short
    MKEncodingTypeInt32      = 7, ///< int
    MKEncodingTypeUInt32     = 8, ///< unsigned int
    MKEncodingTypeInt64      = 9, ///< long long
    MKEncodingTypeUInt64     = 10, ///< unsigned long long
    MKEncodingTypeFloat      = 11, ///< float
    MKEncodingTypeDouble     = 12, ///< double
    MKEncodingTypeLongDouble = 13, ///< long double
    MKEncodingTypeObject     = 14, ///< id
    MKEncodingTypeClass      = 15, ///< Class
    MKEncodingTypeSEL        = 16, ///< SEL
    MKEncodingTypeBlock      = 17, ///< block
    MKEncodingTypePointer    = 18, ///< void*
    MKEncodingTypeStruct     = 19, ///< struct
    MKEncodingTypeUnion      = 20, ///< union
    MKEncodingTypeCString    = 21, ///< char*
    MKEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    MKEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    MKEncodingTypeQualifierConst  = 1 << 8,  ///< const
    MKEncodingTypeQualifierIn     = 1 << 9,  ///< in
    MKEncodingTypeQualifierInout  = 1 << 10, ///< inout
    MKEncodingTypeQualifierOut    = 1 << 11, ///< out
    MKEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    MKEncodingTypeQualifierByref  = 1 << 13, ///< byref
    MKEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    MKEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    MKEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    MKEncodingTypePropertyCopy         = 1 << 17, ///< copy
    MKEncodingTypePropertyRetain       = 1 << 18, ///< retain
    MKEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    MKEncodingTypePropertyWeak         = 1 << 20, ///< weak
    MKEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    MKEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    MKEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
MKEncodingType MKEncodingGetType(const char *typeEncoding);


/**
 Instance variable information.
 */
@interface MKClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) MKEncodingType type;    ///< Ivar's type

/**
 Creates and returns an ivar info object.
 
 @param ivar ivar opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;
@end


/**
 Method information.
 */
@interface MKClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

/**
 Creates and returns a method info object.
 
 @param method method opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithMethod:(Method)method;
@end


/**
 Property information.
 */
@interface MKClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) MKEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

/**
 Creates and returns a property info object.
 
 @param property property opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithProperty:(objc_property_t)property;
@end


/**
 Class information for a class.
 */
@interface MKClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) MKClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, MKClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, MKClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, MKClassPropertyInfo *> *propertyInfos; ///< properties

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, `needUpdate` will returns `YES`, and you should call
 'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
