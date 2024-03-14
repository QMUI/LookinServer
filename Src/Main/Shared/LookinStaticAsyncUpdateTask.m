#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinStaticAsyncUpdateTask.m
//  Lookin
//
//  Created by Li Kai on 2019/6/21.
//  https://lookin.work
//



#import "LookinStaticAsyncUpdateTask.h"

@implementation LookinStaticAsyncUpdateTask

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.oid) forKey:@"oid"];
    [aCoder encodeInteger:self.taskType forKey:@"taskType"];
    [aCoder encodeObject:self.clientReadableVersion forKey:@"clientReadableVersion"];
    [aCoder encodeInteger:self.attrRequest forKey:@"attrRequest"];
    [aCoder encodeBool:self.needBasisVisualInfo forKey:@"needBasisVisualInfo"];
    [aCoder encodeBool:self.needSubitems forKey:@"needSubitems"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.oid = [[aDecoder decodeObjectForKey:@"oid"] unsignedLongValue];
        self.taskType = [aDecoder decodeIntegerForKey:@"taskType"];
        self.clientReadableVersion = [aDecoder decodeObjectForKey:@"clientReadableVersion"];
        if ([aDecoder containsValueForKey:@"attrRequest"]) {
            NSInteger value = [aDecoder decodeIntegerForKey:@"attrRequest"];
            if (value >= LookinDetailUpdateTaskAttrRequest_Automatic && value <= LookinDetailUpdateTaskAttrRequest_NotNeed) {
                self.attrRequest = value;
            } else {
                self.attrRequest = LookinDetailUpdateTaskAttrRequest_Automatic;
            }
        } else {
            self.attrRequest = LookinDetailUpdateTaskAttrRequest_Automatic;
        }

        if ([aDecoder containsValueForKey:@"needBasisVisualInfo"]) {
            self.needBasisVisualInfo = [aDecoder decodeBoolForKey:@"needBasisVisualInfo"];
        } else {
            self.needBasisVisualInfo = NO;
        }
        
        if ([aDecoder containsValueForKey:@"needSubitems"]) {
            self.needSubitems = [aDecoder decodeBoolForKey:@"needSubitems"];
        } else {
            self.needSubitems = NO;
        }
        
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSUInteger)hash {
    return self.oid ^ self.taskType ^ self.attrRequest ^ self.needBasisVisualInfo ^ self.needSubitems;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinStaticAsyncUpdateTask class]]) {
        return NO;
    }
    LookinStaticAsyncUpdateTask *targetTask = object;
    if (self.oid == targetTask.oid
        && self.taskType == targetTask.taskType
        && self.attrRequest == targetTask.attrRequest
        && self.needBasisVisualInfo == targetTask.needBasisVisualInfo
        && self.needSubitems == targetTask.needSubitems) {
        return YES;
    }
    return NO;
}

@end

@implementation LookinStaticAsyncUpdateTasksPackage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.tasks forKey:@"tasks"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.tasks = [aDecoder decodeObjectForKey:@"tasks"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
