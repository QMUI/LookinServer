//
//  LookinObject+LookinServer.m
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinObject+LookinServer.h"
#import "NSObject+LookinServer.h"
#import "LookinIvarTrace.h"

@implementation LookinObject (LookinServer)
+ (instancetype)instanceWithObject:(NSObject *)object {
    LookinObject *lookinObj = [LookinObject new];
    lookinObj.oid = [object lks_registerOid];
    
    lookinObj.memoryAddress = [NSString stringWithFormat:@"%p", object];
    lookinObj.classChainList = [object lks_classChainList];
    
    lookinObj.specialTrace = object.lks_specialTrace;
    lookinObj.ivarTraces = object.lks_ivarTraces;
    
    return lookinObj;
}

@end
