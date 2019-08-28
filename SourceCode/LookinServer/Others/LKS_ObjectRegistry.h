//
//  LKS_ObjectRegistry.h
//  LookinServer
//
//  
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_ObjectRegistry : NSObject

+ (instancetype)sharedInstance;

- (unsigned long)addObject:(NSObject *)object;

- (NSObject *)objectWithOid:(unsigned long)oid;

@end
