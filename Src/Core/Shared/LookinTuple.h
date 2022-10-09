//
//  LookinTuples.h
//  Lookin
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@interface LookinTwoTuple : NSObject <NSSecureCoding>

@property(nonatomic, strong) NSObject *first;
@property(nonatomic, strong) NSObject *second;

@end

@interface LookinStringTwoTuple : NSObject <NSSecureCoding, NSCopying>

+ (instancetype)tupleWithFirst:(NSString *)firstString second:(NSString *)secondString;

@property(nonatomic, copy) NSString *first;
@property(nonatomic, copy) NSString *second;

@end
