#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinConnectionAttachment.m
//  Lookin
//
//  Created by Li Kai on 2019/2/15.
//  https://lookin.work
//



#import "LookinConnectionAttachment.h"
#import "LookinDefines.h"
#import "NSObject+Lookin.h"

static NSString * const Key_Data = @"0";
static NSString * const Key_DataType = @"1";

@interface LookinConnectionAttachment ()

@end

@implementation LookinConnectionAttachment

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[self.data lookin_encodedObjectWithType:self.dataType] forKey:Key_Data];
    [aCoder encodeInteger:self.dataType forKey:Key_DataType];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.dataType = [aDecoder decodeIntegerForKey:Key_DataType];
        self.data = [[aDecoder decodeObjectForKey:Key_Data] lookin_decodedObjectWithType:self.dataType];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
