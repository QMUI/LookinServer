//
//  DanceView.m
//  LookinCustomInfoDemo
//
//  Created by LikaiMacStudioWork on 2023/11/27.
//

#import "DanceView.h"

@implementation DanceView

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos5 {
    NSDictionary<NSString *, id> *ret = @{
        @"properties": [self danceView_makeCustomProperties]
    };
    return ret;
}

- (NSArray *)danceView_makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
        
    [properties addObject:@{
        @"section": @"Dance Info",
        @"title": @"GoodRect",
        @"value": [NSValue valueWithCGRect:CGRectMake(50, 60, 70, 80)],
        @"valueType": @"rect",
        @"retainedSetter": ^(UIColor *newColor) {
            NSLog(@"Try to modify by Lookin.");
        }
    }];
    
    return [properties copy];;
}

@end
