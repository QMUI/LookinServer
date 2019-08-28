//
//  LookinIvarTrace.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 如果 hostClassName 和 ivarName 均 equal，则认为两个 LookinIvarTrace 对象彼此 equal
@interface LookinIvarTrace : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSString *hostClassName;

@property(nonatomic, copy) NSString *ivarName;

@end
