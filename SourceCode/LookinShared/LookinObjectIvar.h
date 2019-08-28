//
//  LookinObjectIvar.h
//  LookinClient
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinObject;

/**
 当 ivar 为一个指向 nil 的对象时，比如指向一个 UIView，则 objectValue 为 nil，nonObjectTypeDescription 为 @"UIView *"，nonObjectValueDescription 为 @"nil"
 */
@interface LookinObjectIvar : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSString *name;

@property(nonatomic, strong) LookinObject *objectValue;

@property(nonatomic, copy) NSString *nonObjectTypeDescription;
@property(nonatomic, copy) NSString *nonObjectValueDescription;

@end
