//
//  SomeViewModel.m
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/11.
//

#import "SomeViewModel.h"

@implementation SomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_RelationSearch" object:self];
    }
    return self;
}

@end
