//
//  NSObject+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/4/21.
//  https://lookin.work
//

#import "NSObject+Lookin.h"
#import "NSObject+LookinServer.h"
#import "LookinServerDefines.h"
#import "LKS_ObjectRegistry.h"
#import <objc/runtime.h>

@implementation NSObject (LookinServer)

#pragma mark - oid

- (unsigned long)lks_registerOid {
    if (!self.lks_oid) {
        unsigned long oid = [[LKS_ObjectRegistry sharedInstance] addObject:self];
        self.lks_oid = oid;
    }
    return self.lks_oid;
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

- (NSArray<NSString *> *)lks_classChainListWithSwiftPrefix:(BOOL)hasSwiftPrefix {
    NSMutableArray<NSString *> *classChainList = [NSMutableArray array];
    Class currentClass = self.class;
    
    while (currentClass) {
        NSString *rawClassName = NSStringFromClass(currentClass);
        
        NSString *currentClassName = hasSwiftPrefix ? rawClassName : [rawClassName lookin_shortClassNameString];
        if (currentClassName) {
            [classChainList addObject:currentClassName];
        }
        currentClass = [currentClass superclass];
    }
    return classChainList.copy;
}

- (NSString *)lks_shortClassName {
    NSString *rawName = NSStringFromClass([self class]);
    NSString *shortName = [rawName lookin_shortClassNameString];
    return shortName;
}

@end
