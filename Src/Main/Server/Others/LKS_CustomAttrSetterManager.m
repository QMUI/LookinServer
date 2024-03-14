#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrSetterManager.m
//  LookinServer
//
//  Created by likai.123 on 2023/11/4.
//

#import "LKS_CustomAttrSetterManager.h"

@interface LKS_CustomAttrSetterManager ()

@property(nonatomic, strong) NSMutableDictionary *settersMap;

@end

@implementation LKS_CustomAttrSetterManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_CustomAttrSetterManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.settersMap = [NSMutableDictionary new];
    }
    return self;
}

- (void)removeAll {
    [self.settersMap removeAllObjects];
}

- (void)saveStringSetter:(nonnull LKS_StringSetter)setter uniqueID:(nonnull NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (nullable LKS_StringSetter)getStringSetterWithID:(nonnull NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveNumberSetter:(LKS_NumberSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (nullable LKS_NumberSetter)getNumberSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveBoolSetter:(LKS_BoolSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_BoolSetter)getBoolSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveColorSetter:(LKS_ColorSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_ColorSetter)getColorSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveEnumSetter:(LKS_EnumSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_EnumSetter)getEnumSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveRectSetter:(LKS_RectSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_RectSetter)getRectSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveSizeSetter:(LKS_SizeSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_SizeSetter)getSizeSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)savePointSetter:(LKS_PointSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_PointSetter)getPointSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

- (void)saveInsetsSetter:(LKS_InsetsSetter)setter uniqueID:(NSString *)uniqueID {
    self.settersMap[uniqueID] = setter;
}

- (LKS_InsetsSetter)getInsetsSetterWithID:(NSString *)uniqueID {
    return self.settersMap[uniqueID];
}

@end
#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
