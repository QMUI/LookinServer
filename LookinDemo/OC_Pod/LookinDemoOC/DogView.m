//
//  DogView.m
//  LookinDemoOC
//
//  Created by likai.123 on 2023/10/15.
//

#import "DogView.h"
#import <UIKit/UIKit.h>

@implementation DogView

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSMutableDictionary<NSString *, id> *ret = [NSMutableDictionary dictionary];
    
    NSMutableArray *properties = [NSMutableArray array];
    
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Nickname",
        @"value": @"Corgi",
        // string, number, bool, color, enum
        @"valueType": @"string",
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSString class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Age",
        @"value": @13.2,
        @"valueType": @"number",
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
        NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"IsFriendly",
        @"value": @YES,
        @"valueType": @"bool",
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"SkinColor",
        @"value": [UIColor redColor],
        @"valueType": @"color",
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[UIColor class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Gender",
        @"value": @"Male",
        @"allEnumCases": @[@"Male", @"Female"],
        @"valueType": @"enum",
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSString class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    ret[@"properties"] = properties;
    return [ret copy];
}

@end
