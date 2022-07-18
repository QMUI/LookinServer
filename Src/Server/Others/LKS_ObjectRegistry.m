//
//  LKS_ObjectRegistry.m
//  LookinServer
//
//  Created by Li Kai on 2019/4/21.
//  https://lookin.work
//

#import "LKS_ObjectRegistry.h"
#import <objc/runtime.h>

@interface LKS_ObjectRegistry ()

@property(nonatomic, strong) NSPointerArray *data;

@end

@implementation LKS_ObjectRegistry

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_ObjectRegistry *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        self.data = [NSPointerArray weakObjectsPointerArray];
        // index 为 0 用 Null 填充
        self.data.count = 1;
    }
    return self;
}

- (unsigned long)addObject:(NSObject *)object {
    if (!object) {
        return 0;
    }
    [self.data addPointer:(void *)object];
    return self.data.count - 1;
}

- (NSObject *)objectWithOid:(unsigned long)oid {
    if (self.data.count <= oid) {
        return nil;
    }
    id object = [self.data pointerAtIndex:oid];
    return object;
}

@end
