#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinConnectionResponse.m
//  Lookin
//
//  Created by Li Kai on 2019/1/15.
//  https://lookin.work
//



#import "LookinConnectionResponseAttachment.h"
#import "LookinDefines.h"

@interface LookinConnectionResponseAttachment ()

@end

@implementation LookinConnectionResponseAttachment

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.lookinServerVersion forKey:@"lookinServerVersion"];
    [aCoder encodeObject:self.error forKey:@"error"];
    [aCoder encodeObject:@(self.dataTotalCount) forKey:@"dataTotalCount"];
    [aCoder encodeObject:@(self.currentDataCount) forKey:@"currentDataCount"];
    [aCoder encodeBool:self.appIsInBackground forKey:@"appIsInBackground"];
}

- (instancetype)init {
    if (self = [super init]) {
        self.lookinServerVersion = LOOKIN_SERVER_VERSION;
        self.dataTotalCount = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.lookinServerVersion = [aDecoder decodeIntForKey:@"lookinServerVersion"];
        self.error = [aDecoder decodeObjectForKey:@"error"];
        self.dataTotalCount = [[aDecoder decodeObjectForKey:@"dataTotalCount"] unsignedIntegerValue];
        self.currentDataCount = [[aDecoder decodeObjectForKey:@"currentDataCount"] unsignedIntegerValue];
        self.appIsInBackground = [aDecoder decodeBoolForKey:@"appIsInBackground"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (instancetype)attachmentWithError:(NSError *)error {
    LookinConnectionResponseAttachment *attachment = [LookinConnectionResponseAttachment new];
    attachment.error = error;
    return attachment;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
