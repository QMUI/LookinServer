//
//  LookinObjectIvar.m
//  LookinClient
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinObjectIvar.h"

@implementation LookinObjectIvar

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.objectValue forKey:@"objectValue"];
    [aCoder encodeObject:self.nonObjectTypeDescription forKey:@"nonObjectTypeDescription"];
    [aCoder encodeObject:self.nonObjectValueDescription forKey:@"nonObjectValueDescription"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.objectValue = [aDecoder decodeObjectForKey:@"objectValue"];
        self.nonObjectTypeDescription = [aDecoder decodeObjectForKey:@"nonObjectTypeDescription"];
        self.nonObjectValueDescription = [aDecoder decodeObjectForKey:@"nonObjectValueDescription"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
