//
//  UIView+Custom.m
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos_0 {
    NSDictionary<NSString *, id> *ret = @{
        @"properties": [self category_makeCustomProperties],
    };
    return ret;
}

- (NSArray *)category_makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    [properties addObject:@{
        @"section": @"Appearance",
        @"title": @"Brightness",
        @"value": @8.8,
        @"valueType": @"number"
    }];
    
    return [properties copy];;
}

@end
