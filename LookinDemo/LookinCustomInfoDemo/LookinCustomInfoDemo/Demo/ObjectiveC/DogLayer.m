//
//  DogLayer.m
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

#import "DogLayer.h"

@implementation DogLayer

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSDictionary<NSString *, id> *ret = @{
        @"properties": [self makeCustomProperties],
    };
    return ret;
}

- (NSArray *)makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    // string property
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Nickname",
        @"value": @"Sushi",
        @"valueType": @"string"
    }];
    
    // number property
    [properties addObject:@{
        @"section": @"DogInfo",
        @"title": @"Age",
        @"value": @8,
        @"valueType": @"number"
    }];
    
    // bool property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"IsFriendly",
        @"value": @YES,
        @"valueType": @"bool"
    }];
    
    // color property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"SkinColor",
        @"value": [UIColor blueColor],
        @"valueType": @"color"
    }];
    
    // enum property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"Type",
        @"value": @"Corgi",
        @"valueType": @"enum",
        // Set object for this key when the valueType is "enum".
        @"allEnumCases": @[@"Corgi", @"Samoyed", @"Golden Retriever", @"Teddy"]
    }];
    
    return [properties copy];;
}

@end
