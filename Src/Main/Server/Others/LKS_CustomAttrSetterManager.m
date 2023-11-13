#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrSetterManager.m
//  LookinServer
//
//  Created by likai.123 on 2023/11/4.
//

#import "LKS_CustomAttrSetterManager.h"

@interface LKS_CustomAttrSetterManager ()

@property(nonatomic, strong) NSMutableDictionary *stringSetterMap;
@property(nonatomic, strong) NSMutableDictionary *numberSetterMap;
@property(nonatomic, strong) NSMutableDictionary *boolSetterMap;
@property(nonatomic, strong) NSMutableDictionary *colorSetterMap;
@property(nonatomic, strong) NSMutableDictionary *enumSetterMap;

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
        self.stringSetterMap = [NSMutableDictionary new];
        self.numberSetterMap = [NSMutableDictionary new];
        self.boolSetterMap = [NSMutableDictionary new];
        self.colorSetterMap = [NSMutableDictionary new];
        self.enumSetterMap = [NSMutableDictionary new];
    }
    return self;
}

- (void)removeAll {
    [self.stringSetterMap removeAllObjects];
    [self.numberSetterMap removeAllObjects];
    [self.boolSetterMap removeAllObjects];
    [self.colorSetterMap removeAllObjects];
    [self.enumSetterMap removeAllObjects];
}

- (void)saveStringSetter:(nonnull LKS_StringSetter)setter uniqueID:(nonnull NSString *)uniqueID {
    self.stringSetterMap[uniqueID] = setter;
}

- (nullable LKS_StringSetter)getStringSetterWithID:(nonnull NSString *)uniqueID {
    return self.stringSetterMap[uniqueID];
}

- (void)saveNumberSetter:(LKS_NumberSetter)setter uniqueID:(NSString *)uniqueID {
    self.numberSetterMap[uniqueID] = setter;
}

- (nullable LKS_NumberSetter)getNumberSetterWithID:(NSString *)uniqueID {
    return self.numberSetterMap[uniqueID];
}

- (void)saveBoolSetter:(LKS_BoolSetter)setter uniqueID:(NSString *)uniqueID {
    self.boolSetterMap[uniqueID] = setter;
}

- (LKS_BoolSetter)getBoolSetterWithID:(NSString *)uniqueID {
    return self.boolSetterMap[uniqueID];
}

- (void)saveColorSetter:(LKS_ColorSetter)setter uniqueID:(NSString *)uniqueID {
    self.colorSetterMap[uniqueID] = setter;
}

- (LKS_ColorSetter)getColorSetterWithID:(NSString *)uniqueID {
    return self.colorSetterMap[uniqueID];
}

- (void)saveEnumSetter:(LKS_EnumSetter)setter uniqueID:(NSString *)uniqueID {
    self.enumSetterMap[uniqueID] = setter;
}

- (LKS_EnumSetter)getEnumSetterWithID:(NSString *)uniqueID {
    return self.enumSetterMap[uniqueID];
}

@end
#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
