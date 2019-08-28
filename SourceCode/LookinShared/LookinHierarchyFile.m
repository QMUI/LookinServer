//
//  LookinHierarchyFile.m
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinHierarchyFile.h"

@implementation LookinHierarchyFile

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.hierarchyInfo forKey:@"hierarchyInfo"];
    [aCoder encodeObject:self.soloScreenshots forKey:@"soloScreenshots"];
    [aCoder encodeObject:self.groupScreenshots forKey:@"groupScreenshots"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.hierarchyInfo = [aDecoder decodeObjectForKey:@"hierarchyInfo"];
        self.soloScreenshots = [aDecoder decodeObjectForKey:@"soloScreenshots"];
        self.groupScreenshots = [aDecoder decodeObjectForKey:@"groupScreenshots"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
