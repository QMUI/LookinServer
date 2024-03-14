#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LookinCustomDisplayItemInfo.m
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import "LookinCustomDisplayItemInfo.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@implementation LookinCustomDisplayItemInfo

- (id)copyWithZone:(NSZone *)zone {
    LookinCustomDisplayItemInfo *newInstance = [[LookinCustomDisplayItemInfo allocWithZone:zone] init];
    
    if (self.frameInWindow) {
#if TARGET_OS_IPHONE
        CGRect rect = [self.frameInWindow CGRectValue];
        newInstance.frameInWindow = [NSValue valueWithCGRect:rect];
#elif TARGET_OS_MAC
        CGRect rect = [self.frameInWindow rectValue];
        newInstance.frameInWindow = [NSValue valueWithRect:rect];
#endif
    }
    newInstance.title = self.title;
    newInstance.subtitle = self.subtitle;
    newInstance.danceuiSource = self.danceuiSource;
    
    return newInstance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.frameInWindow forKey:@"frameInWindow"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeObject:self.danceuiSource forKey:@"danceuiSource"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.frameInWindow = [aDecoder decodeObjectForKey:@"frameInWindow"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        self.danceuiSource = [aDecoder decodeObjectForKey:@"danceuiSource"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
