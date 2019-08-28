//
//  LookinObject.m
//  LookinClient
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinObject.h"
#import "LookinIvarTrace.h"

@implementation LookinObject

#if TARGET_OS_IPHONE
+ (instancetype)instanceWithObject:(NSObject *)object {
    LookinObject *lookinObj = [LookinObject new];
    [object lks_registerOid];
    lookinObj.oid = object.lks_oid;
    
    lookinObj.memoryAddress = [NSString stringWithFormat:@"%p", object];
    lookinObj.classChainList = [object lks_classChainList];
    
    lookinObj.specialTrace = object.lks_specialTrace;
    lookinObj.ivarTraces = object.lks_ivarTraces;
    
    return lookinObj;
}
#endif

#pragma mark - <NSSecureCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.oid) forKey:@"oid"];
    [aCoder encodeObject:self.memoryAddress forKey:@"memoryAddress"];
    [aCoder encodeObject:self.classChainList forKey:@"classChainList"];
    [aCoder encodeObject:self.ivarList forKey:@"ivarList"];
    [aCoder encodeObject:self.specialTrace forKey:@"specialTrace"];
    [aCoder encodeObject:self.ivarTraces forKey:@"ivarTraces"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.oid = [[aDecoder decodeObjectForKey:@"oid"] unsignedLongValue];
        self.memoryAddress = [aDecoder decodeObjectForKey:@"memoryAddress"];
        self.classChainList = [aDecoder decodeObjectForKey:@"classChainList"];
        self.ivarList = [aDecoder decodeObjectForKey:@"ivarList"];
        self.specialTrace = [aDecoder decodeObjectForKey:@"specialTrace"];
        self.ivarTraces = [aDecoder decodeObjectForKey:@"ivarTraces"];
    }
    return self;
}

- (void)setClassChainList:(NSArray<NSString *> *)classChainList {
    _classChainList = classChainList;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)selfClassName {
    return self.classChainList.firstObject;
}

- (NSString *)nonNamespaceSelfClassName {
    return [[self selfClassName] componentsSeparatedByString:@"."].lastObject;
}

@end
