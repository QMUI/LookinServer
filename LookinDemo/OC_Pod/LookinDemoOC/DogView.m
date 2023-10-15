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
    
    // string
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Nickname",
        @"value": @"Corgi",
        @"valueType": @"string",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSString class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // number
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Age",
        @"value": @13.2,
        @"valueType": @"number",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // bool
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"IsFriendly",
        @"value": @YES,
        @"valueType": @"bool",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // color
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"SkinColor",
        @"value": [UIColor redColor],
        @"valueType": @"color",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[UIColor class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // enum
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Gender",
        @"value": @"Male",
        @"valueType": @"enum",
        // Set object for this key when the valueType is "enum".
        @"allEnumCases": @[@"Male", @"Female"],
        // Optional. Set this key to allow user to modify the property value in Lookin.
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
