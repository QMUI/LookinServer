//
//  NSObject+LookinServer.m
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "NSObject+LookinServer.h"
#import "LKS_ObjectRegistry.h"
#import <objc/runtime.h>

@implementation NSObject (LookinServer)

#pragma mark - oid

- (void)lks_registerOid {
    if (self.lks_oid) {
        return;
    }
    unsigned long oid = [[LKS_ObjectRegistry sharedInstance] addObject:self];
    self.lks_oid = oid;
}

- (void)setLks_oid:(unsigned long)lks_oid {
    [self lookin_bindObject:@(lks_oid) forKey:@"lks_oid"];
}

- (unsigned long)lks_oid {
    NSNumber *number = [self lookin_getBindObjectForKey:@"lks_oid"];
    return [number unsignedLongValue];
}

+ (NSObject *)lks_objectWithOid:(unsigned long)oid {
    return [[LKS_ObjectRegistry sharedInstance] objectWithOid:oid];
}

#pragma mark - trace

- (void)setLks_ivarTraces:(NSArray<LookinIvarTrace *> *)lks_ivarTraces {
    [self lookin_bindObject:lks_ivarTraces.copy forKey:@"lks_ivarTraces"];
    
    if (lks_ivarTraces) {
        [[NSObject lks_allObjectsWithTraces] addPointer:(void *)self];
    }
}

- (NSArray<LookinIvarTrace *> *)lks_ivarTraces {
    return [self lookin_getBindObjectForKey:@"lks_ivarTraces"];
}

- (void)setLks_specialTrace:(NSString *)lks_specialTrace {
    [self lookin_bindObject:lks_specialTrace forKey:@"lks_specialTrace"];
    if (lks_specialTrace) {
        [[NSObject lks_allObjectsWithTraces] addPointer:(void *)self];
    }
}
- (NSString *)lks_specialTrace {
    return [self lookin_getBindObjectForKey:@"lks_specialTrace"];
}

+ (void)lks_clearAllObjectsTraces {
    [[[NSObject lks_allObjectsWithTraces] allObjects] enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.lks_ivarTraces = nil;
        obj.lks_specialTrace = nil;
    }];
    [NSObject lks_allObjectsWithTraces].count = 0;
}

+ (NSPointerArray *)lks_allObjectsWithTraces {
    static dispatch_once_t onceToken;
    static NSPointerArray *lks_allObjectsWithTraces = nil;
    dispatch_once(&onceToken,^{
        lks_allObjectsWithTraces = [NSPointerArray weakObjectsPointerArray];
    });
    return lks_allObjectsWithTraces;
}

- (NSArray<NSString *> *)lks_classChainList {
    NSMutableArray<NSString *> *classChainList = [NSMutableArray array];
    Class currentClass = self.class;
    while (currentClass) {
        NSString *currentClassName = NSStringFromClass(currentClass);
        if (currentClassName) {
            [classChainList addObject:currentClassName];
        }
        currentClass = [currentClass superclass];
    }
    return classChainList.copy;
}

@end
