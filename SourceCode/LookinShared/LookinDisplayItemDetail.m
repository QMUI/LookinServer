//
//  LookinDisplayItemDetail.m
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinDisplayItemDetail.h"

@implementation LookinDisplayItemDetail

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.displayItemOid) forKey:@"displayItemOid"];
    [aCoder encodeObject:self.groupScreenshot.lookin_data forKey:@"groupScreenshot"];
    [aCoder encodeObject:self.soloScreenshot.lookin_data forKey:@"soloScreenshot"];
    [aCoder encodeObject:self.groupScreenshotError forKey:@"groupScreenshotError"];
    [aCoder encodeObject:self.soloScreenshotError forKey:@"soloScreenshotError"];
    [aCoder encodeObject:self.attrGroupsError forKey:@"attrGroupsError"];
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
        self.groupScreenshotError = [aDecoder decodeObjectForKey:@"groupScreenshotError"];
        self.soloScreenshotError = [aDecoder decodeObjectForKey:@"soloScreenshotError"];
        self.attrGroupsError = [aDecoder decodeObjectForKey:@"attrGroupsError"];
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
