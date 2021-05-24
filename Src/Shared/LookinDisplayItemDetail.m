//
//  LookinDisplayItemDetail.m
//  Lookin
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//



#import "LookinDisplayItemDetail.h"

#if TARGET_OS_IPHONE
#import "UIImage+LookinServer.h"
#endif

@implementation LookinDisplayItemDetail

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.displayItemOid) forKey:@"displayItemOid"];
    [aCoder encodeObject:self.groupScreenshot.lookin_data forKey:@"groupScreenshot"];
    [aCoder encodeObject:self.soloScreenshot.lookin_data forKey:@"soloScreenshot"];
    [aCoder encodeObject:self.frameValue forKey:@"frameValue"];
    [aCoder encodeObject:self.boundsValue forKey:@"boundsValue"];
    [aCoder encodeObject:self.hiddenValue forKey:@"hiddenValue"];
    [aCoder encodeObject:self.alphaValue forKey:@"alphaValue"];
    [aCoder encodeObject:self.attributesGroupList forKey:@"attributesGroupList"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.displayItemOid = [[aDecoder decodeObjectForKey:@"displayItemOid"] unsignedLongValue];
        self.groupScreenshot = [[LookinImage alloc] initWithData:[aDecoder decodeObjectForKey:@"groupScreenshot"]];
        self.soloScreenshot = [[LookinImage alloc] initWithData:[aDecoder decodeObjectForKey:@"soloScreenshot"]];
        self.frameValue = [aDecoder decodeObjectForKey:@"frameValue"];
        self.boundsValue = [aDecoder decodeObjectForKey:@"boundsValue"];
        self.hiddenValue = [aDecoder decodeObjectForKey:@"hiddenValue"];
        self.alphaValue = [aDecoder decodeObjectForKey:@"alphaValue"];
        self.attributesGroupList = [aDecoder decodeObjectForKey:@"attributesGroupList"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
