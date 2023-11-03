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

@end

@implementation LKS_CustomAttrSetterManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stringSetterMap = [NSMutableDictionary new];
    }
    return self;
}

- (void)removeAll {
    [self.stringSetterMap removeAllObjects];
}

- (void)saveStringSetter:(nonnull LKS_StringSetter)setter uniqueID:(nonnull NSString *)uniqueID {
    self.stringSetterMap[uniqueID] = setter;
}

- (nullable LKS_StringSetter)getSetterWithUniqueID:(nonnull NSString *)uniqueID {
    return self.stringSetterMap[uniqueID];
}

@end
#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
