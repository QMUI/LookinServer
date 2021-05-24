//
//  LookinHierarchyFile.m
//  Lookin
//
//  Created by Li Kai on 2019/5/12.
//  https://lookin.work
//



#import "LookinHierarchyFile.h"

#import "NSArray+Lookin.h"

@implementation LookinHierarchyFile

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.serverVersion forKey:@"serverVersion"];
    [aCoder encodeObject:self.hierarchyInfo forKey:@"hierarchyInfo"];
    [aCoder encodeObject:self.soloScreenshots forKey:@"soloScreenshots"];
    [aCoder encodeObject:self.groupScreenshots forKey:@"groupScreenshots"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.serverVersion = [aDecoder decodeIntForKey:@"serverVersion"];
        self.hierarchyInfo = [aDecoder decodeObjectForKey:@"hierarchyInfo"];
        self.soloScreenshots = [aDecoder decodeObjectForKey:@"soloScreenshots"];
        self.groupScreenshots = [aDecoder decodeObjectForKey:@"groupScreenshots"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (NSError *)verifyHierarchyFile:(LookinHierarchyFile *)hierarchyFile {
    if (![hierarchyFile isKindOfClass:[LookinHierarchyFile class]]) {
        return LookinErr_Inner;
    }
    
    if (hierarchyFile.serverVersion < LOOKIN_SUPPORTED_SERVER_MIN) {
        // 文件版本太旧
        // 如果不存在 serverVersion 这个字段，说明版本是 6
        int fileVersion = hierarchyFile.serverVersion ? : 6;
        NSString *detail = [NSString stringWithFormat:NSLocalizedString(@"The document was created by a Lookin app with too old version. Current Lookin app version is %@, but the document version is %@.", nil), @(LOOKIN_CLIENT_VERSION), @(fileVersion)];
        return [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ServerVersionTooLow userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Failed to open the document.", nil), NSLocalizedRecoverySuggestionErrorKey:detail}];
    }
    
    if (hierarchyFile.serverVersion > LOOKIN_SUPPORTED_SERVER_MAX) {
        // 文件版本太新
        NSString *detail = [NSString stringWithFormat:NSLocalizedString(@"Current Lookin app is too old to open this document. Current Lookin app version is %@, but the document version is %@.", nil), @(LOOKIN_CLIENT_VERSION), @(hierarchyFile.serverVersion)];
        return [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ServerVersionTooHigh userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Failed to open the document.", nil), NSLocalizedRecoverySuggestionErrorKey:detail}];
    }
    
    return nil;
}

@end
